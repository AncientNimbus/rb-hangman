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

  attr_accessor :active_session
  attr_reader :dict_path, :p1

  # Game mode configurations
  MODE = { easy: 7, standard: 6, hard: 5 }.freeze

  def initialize(dict_path: FUS.assets_path("dictionary.txt"))
    @dict_path = dict_path
    @p1 = Player.new(mode: :standard)
    init_game
  end

  # @since 0.1.4
  # @version 1.1.0
  def init_game
    # mode selection
    @active_session = create_session
    # p active_session
    p1.save_game(active_session)
    game_loop
  end

  # @since 0.1.4
  # @version 1.0.0
  def create_session
    guess_word = FUS.random_word(dict_path)
    p guess_word
    { id: p1.session_counts += 1, word_id: guess_word[:id],
      remaining_lives: MODE[p1.mode], state: Array.new(guess_word[:word].size, "_"),
      status: :active, win?: false }
  end

  def game_display(as, lives, idx)
    # display lives
    puts "#{lives} live#{'s' if lives - idx > 1} remaining"
    # display blanks
    puts as[:state].join(" ")
    # display gallows
  end

  # @since 0.1.5
  # @version 1.0.0
  def game_loop
    as = active_session
    lives = as[:remaining_lives]

    secret_word = lookup_word(as[:word_id], as[:state].size)

    idx = 0
    game_display(as, lives, idx)
    until as[:win?] || lives <= 0
      # get user input + input check
      guess = gets.chomp

      # validate result
      p secret_word
      char_in_word = guess.match?(/\b[#{secret_word}]\b/)
      lives -= 1 unless char_in_word

      char_idx = 0

      # update display for next print
      secret_word.each_char do |char|
        as[:state][char_idx] = guess if guess == char
        # p char, idx
        char_idx += 1
      end

      # Check result
      as[:win?] = as[:state].include?("_") ? false : true

      # save session
      as[:remaining_lives] = lives
      p1.save_game(active_session)

      # update display
      game_display(as, lives, idx)

    end
    announce_result
  end

  def announce_result
    puts active_session[:win?] ? "Win" : "lose"
    active_session[:status] = :ended
    p1.save_game(active_session)
  end

  private

  def lookup_word(word_id, word_char_length)
    word = FUS.lookup_line(dict_path, word_id)
    word.length == word_char_length ? word : "Error"
  end

  # def test
  #   # puts FileUtils.random_word(dict_path)
  #   # p1.load_save
  #   # p1.save_game(test_session)
  #   # p p1.session_counts
  #   # p p1.sessions[-1][:id] = 100
  #   # p p1.sessions[-1][:state].fill("_")
  #   # p1.save_game(p1.sessions[-1])
  # end
end

# @todo resume game state from load save
# @todo option to choose new game and load game
# @todo option to save file
# @todo auto save toggle
# @todo game mode selection
# @todo core game loop
# @todo CLI input handling
# @todo CLI command handling
# @todo CLI user experience
# @todo CLI display game state
# @todo CLI how to play
# @todo CLI ASCII art
# @todo
