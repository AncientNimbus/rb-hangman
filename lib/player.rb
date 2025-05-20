# frozen_string_literal: true

require_relative "file_utils"

# Player class
# @version 1.0.2
class Player
  include FUS

  attr_accessor :name, :mode, :savefile, :sessions, :session_counts

  def initialize(name: "Spock", mode: :standard)
    @name = name
    @mode = mode
    new_save
    @sessions = savefile.dig(:hangman_data, :sessions)
    @session_counts = sessions.size
  end

  # @since 0.1.1
  # @version 1.1.2
  def new_save
    @savefile = { saved_date: Time.now.ceil, name: name, hangman_data: { mode: mode, sessions: [] } }
    overwrite_save
  end

  # Write game save to disk
  # @since 0.1.4
  # @version 1.0.1
  def overwrite_save
    FUS.write_savefile(FUS.data_path(name), savefile)
  end

  # Load save from player's disk
  # @since 0.1.4
  # @version 1.0.1
  def load_save
    self.savefile = FUS.load_file(FUS.data_path(name))
  end

  # Add latest session to savefile and store game save to disk
  # @since 0.1.4
  # @version 1.0.1
  def save_game(session_obj)
    sessions.push(session_obj)
    overwrite_save
  end

  # Find the latest session
  # @since 0.1.3
  # @version 1.0.2
  def resume_session
    sessions.bsearch { |game| game[:status] == :active }
  end
end
