# frozen_string_literal: true

require "colorize"
require_relative "file_utils"
require_relative "player"
require_relative "logic"
require_relative "cli_helper"

# Hangman class
# @author Ancient Nimbus
# @since 0.1.0
# @version 1.0.2
class Hangman
  include FUS

  attr_accessor :active_session, :lives, :new_char, :prev_char
  attr_reader :cli, :dict_path, :p1, :load_save, :secret_word_obj, :secret_word

  # Game mode configurations
  MODE = { easy: 7, standard: 6, hard: 5 }.freeze

  def initialize(console, dict_path: FUS.assets_path("dictionary.txt"))
    @cli = console
    cli.app_running = true
    @dict_path = dict_path
    @p1 = Player.new(mode: :standard) # @todo user prompt
    @load_save = false # @todo user prompt
    init_game
  end

  # @since 0.1.4
  # @version 1.0.2
  def create_session
    @secret_word_obj = FUS.random_word(dict_path)
    { id: p1.session_counts += 1, status: :active, win?: false, word_id: secret_word_obj[:id],
      remaining_lives: MODE[p1.mode], state: Array.new(secret_word_obj[:word].size, "_") }
  end

  # @since 0.1.4
  # @version 1.2.0
  def init_game
    # mode selection
    @active_session = load_save ? p1.load_save : create_session
    @lives = active_session[:remaining_lives]
    @secret_word = secret_word_obj[:word]
    @prev_char = ""
    @new_char = ""

    p1.save_game(active_session)

    # Initial display
    print_session
    # Enter game loop
    game_loop
  end

  # @since 0.1.6
  # @version 1.1.0
  def print_session
    puts secret_word
    puts
    # display blanks
    puts active_session[:state].join(" ")
    # display gallows
    print_gallows
    # display lives
    puts "#{lives} live#{'s' if lives > 1} remaining"
  end

  def print_gallows
    puts "Will print hangman stage: #{MODE[p1.mode] - lives}"
  end

  # @since 0.2.0
  # @version 1.1.0
  def make_guess
    self.new_char = cli.process_input(cli.user_input(cli.t("hm.guess.msg")),
                                      use_reg: true, reg: cli.t("hm.guess.reg", prefix: ""))
    puts cli.t("hm.same_char_warning") if new_char == prev_char
    new_char
  end

  # @since 0.1.6
  # @version 1.3.0
  def game_loop
    until active_session[:win?] || lives <= 0
      # get user input + input check
      guess = make_guess
      self.prev_char = new_char
      # validate result
      self.lives -= 1 unless matching_character?(guess)
      # update session data
      update_session(guess)
      # save session
      p1.save_game(active_session)
      # update display
      print_session
    end
    announce_result
  end

  # @since 0.1.6
  # @version 1.0.0
  def update_session(guess)
    # Update game state
    char_idx = 0
    secret_word.each_char do |char|
      active_session[:state][char_idx] = guess if guess == char
      char_idx += 1
    end
    # Update remaining lives
    active_session[:remaining_lives] = lives
    # Check result
    active_session[:win?] = active_session[:state].include?("_") ? false : true
  end

  # @since 0.1.6
  # @version 1.0.0
  def matching_character?(guess)
    guess.match?(/\b[#{secret_word}]\b/)
  end

  # @since 0.1.6
  # @version 1.1.0
  def announce_result
    puts active_session[:win?] ? cli.t("hm.win").colorize(:green) : cli.t("hm.lose",
                                                                          { word: secret_word }).colorize(:red)
    active_session[:status] = :ended
    p1.save_game(active_session)

    next_game
  end

  # @since 0.2.2
  # @version 1.0.0
  def next_game
    input = cli.restart
    p input
  end
end

# @todo resume game state from load save
# @todo option to choose new game and load game
# @todo option to save file
# @todo auto save toggle
# @todo game mode selection
# @todo CLI command handling
# @todo CLI user experience
# @todo CLI display game state
# @todo CLI how to play
# @todo CLI ASCII art
# @todo
