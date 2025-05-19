# frozen_string_literal: true

require_relative "file_utils"
FUS = FileUtils
# Player class
# @version 1.0.1
class Player
  include FUS

  attr_accessor :name, :savefile

  def initialize(name: "Spock")
    @name = name
    new_save
  end

  # @since 0.1.1
  # @version 1.1.0
  def new_save
    @savefile = { saved_date: Time.now.ceil, name: name, hangman_data: {
      mode: "standard", sessions: [
        { id: 1, word_id: 123, remaining_lives: 3, state: %w[a _ p l e], status: :ended, win?: true },
        { id: 2, word_id: 456, remaining_lives: 0, state: %w[_ o a _ _], status: :ended, win?: false },
        { id: 3, word_id: 789, remaining_lives: 5, state: %w[_ o a _ _], status: :active, win?: false }
      ]
    } }
    FUS.write_savefile(FUS.data_path(name), savefile)
  end

  def save_game(session_obj)
    savefile[:hangman_data].store(:"game#{}")
  end

  def load_game; end

  # Find the latest session
  # @since 0.1.3
  # @version 1.0.0
  def resume_session
    savefile.dig(:hangman_data, :sessions).bsearch { |game| game[:status] == :active }
  end
end
