# frozen_string_literal: true

require "colorize"
require_relative "file_utils"
require_relative "player"
require_relative "logic"
require_relative "cli_helper"

# Hangman class
# @author Ancient Nimbus
# @since 0.1.0
# @version 1.0.1
class Hangman
  include FileUtils

  attr_reader :dict_path

  def initialize(dict_path: FileUtils.assets_path("dictionary.txt"))
    @dict_path = dict_path
    @p1 = Player.new
    test
  end

  def test
    puts FileUtils.random_word(dict_path)
  end
end
