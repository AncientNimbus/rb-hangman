# frozen_string_literal: true

require "colorize"
require_relative "file_utils"
require_relative "player"

# Hangman class
# @author Ancient Nimbus
# @since 0.1.0
# @version 1.4.0
class Hangman
  include FUS

  attr_accessor :p1, :load_save, :active_session, :play_set, :lives
  attr_reader :cli, :dict_path, :s_word_obj, :s_word

  # Game mode configurations
  MODE = { 1 => 7, 2 => 6, 3 => 5 }.freeze

  def initialize(console, dict_path: FUS.assets_path("dictionary.txt"))
    @cli = console
    cli.app_running = true
    @dict_path = dict_path
    @active_session = nil
    @p1 = Player.new(console)

    # Boot_screen
    puts cli.t("boot", prefix: "").colorize(:yellow)

    @load_save = cli.load_session
    player_profile(load_save)
    resume_session
    init_game
  end

  # Set the player of the play session.
  # @since 0.2.6
  # @version 1.0.0
  def player_profile(load_savefile)
    profile = p1.profile_lookup(load_savefile)
    # if profile returns nil, switch back to new user mode otherwise replace p1 with profile
    profile.nil? ? self.load_save = false : self.p1 = profile
  end

  # @since 0.1.4
  # @version 1.2.0
  def create_session
    @s_word_obj = FUS.random_word(dict_path)
    { id: p1.session_counts += 1, status: :active, win?: false, play_set: FUS.t("hm.set"), word_id: s_word_obj[:id],
      remaining_lives: MODE[p1.mode], state: Array.new(s_word_obj[:word].size, "_") }
  end

  def resume_session
    return unless load_save

    p1.load_save
    self.active_session = p1.resume_session
    puts cli.t("hm.welcome.resume", { name: p1.name.colorize(:yellow) })
  end

  # @since 0.1.4
  # @version 1.7.0
  def init_game
    self.active_session ||= create_session
    @lives = active_session[:remaining_lives]
    @play_set = active_session[:play_set]
    @s_word = word_lookup(active_session[:word_id])
    p1.save_game(active_session)

    print_session(first: true)

    game_loop
  end

  # @since 0.1.6
  # @version 1.5.0
  def print_session(first: true)
    # puts s_word
    # display blanks
    puts "\n* #{active_session[:state].join(' ').colorize(:light_blue)}"
    # display gallows
    print_gallows(first: first)
  end

  # @since 0.3.5
  # @version 1.4.0
  def print_gallows(first: false)
    first = false if lives != MODE[p1.mode]
    puts FUS.t("hm.gallows.#{first ? 7 : lives}", format_alphabet_grid([0..2, 3..6, 7..12, 13..18, 19..22, 23..25]))
  end

  # @since 1.3.0
  # @version 1.0.0
  def format_alphabet_grid(layout)
    layout.map.with_index(1) do |range, row_num|
      ["r#{row_num}", play_set[range].upcase.chars.join(" ")]
    end.to_h
  end

  # @since 0.2.0
  # @version 1.5.0
  def make_guess
    cli.process_input(cli.user_input(cli.t("hm.guess.msg")).downcase, reg: /\b[#{play_set.gsub('_', '')}]\b/,
                                                                      invalid_msg: cli.t("hm.same_char_warning"))
  end

  # @since 1.1.0
  # @version 1.0.0
  def delete_from_set(char)
    self.play_set = play_set.sub(char, "_")
    active_session[:play_set] = play_set
  end

  # @since 0.1.6
  # @version 1.6.0
  def game_loop
    until active_session[:win?] || lives <= 0
      # get user input + input check
      guess = make_guess
      delete_from_set(guess)
      # validate result
      self.lives -= 1 unless matching_character?(guess)
      # update session data
      update_session(guess)
      # save session
      p1.save_game(active_session)
      # update display
      print_session(first: false)
    end
    announce_result
  end

  # @since 0.1.6
  # @version 1.1.0
  def update_session(guess)
    # Update game state
    s_word.chars.each_with_index { |char, idx| active_session[:state][idx] = guess if guess == char }
    # Update remaining lives
    active_session[:remaining_lives] = lives
    # Check result
    active_session[:win?] = active_session[:state].include?("_") ? false : true
  end

  # @since 0.1.6
  # @version 1.1.0
  def matching_character?(guess)
    guess.match?(/\b[#{s_word}]\b/)
  end

  # @since 0.1.6
  # @version 1.2.0
  def announce_result
    puts active_session[:win?] ? cli.t("hm.win").colorize(:green) : cli.t("hm.lose", { word: s_word }).colorize(:red)
    active_session[:status] = :ended
    p1.save_game(active_session)

    next_game
  end

  # @since 0.2.2
  # @version 1.1.0
  def next_game
    response = cli.restart
    return puts cli.t("hm.next_game.exit_msg").colorize(:yellow) unless response

    self.active_session = nil
    init_game
  end

  # @since 0.3.3
  # @version 1.0.0
  def word_lookup(id)
    FUS.lookup_line(dict_path, id)
  end
end
