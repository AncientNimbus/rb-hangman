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
  include FileUtils

  attr_reader :dict_path, :p1

  def initialize(dict_path: FileUtils.assets_path("dictionary.txt"))
    @dict_path = dict_path
    @p1 = Player.new
    # game_loop
    test
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
    puts p1.resume_session
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
