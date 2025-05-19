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
    # game_loop
    init_game
    test
  end

  # @version 0.1.4
  # @version 1.0.0
  def init_game
    # mode selection
    @active_session = create_session
    p active_session
    p1.save_game(active_session)
  end

  # @version 0.1.4
  # @version 1.0.0
  def create_session
    guess_word = FUS.random_word(@dict_path)
    p guess_word
    { id: p1.session_counts += 1, word_id: guess_word[:id],
      remaining_lives: MODE[p1.mode], state: Array.new(guess_word[:word].size, "_"),
      status: :active, win?: false }
  end

  def game_loop
    round = 6

    round.times do |idx|
      puts "#{round - idx} round#{'s' if round - idx >= 1}"
      test
      gets
    end
  end

  private

  def test
    # puts FileUtils.random_word(dict_path)
    # p1.load_save
    # p1.save_game(test_session)
    # p p1.session_counts
    # p p1.sessions[-1][:id] = 100
    # p p1.sessions[-1][:state].fill("_")
    # p1.save_game(p1.sessions[-1])
  end
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
