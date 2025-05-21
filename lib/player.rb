# frozen_string_literal: true

require_relative "file_utils"

# Player class
# @version 1.0.2
class Player
  include FUS

  attr_accessor :name, :mode, :savefile, :sessions, :session_counts
  attr_reader :cli

  def initialize(console, name: "Spock", mode: 6)
    @cli = console
    @name = name
    @mode = mode
    new_save
    @sessions = savefile.dig(:hangman_data, :sessions)
    @session_counts = sessions.size
  end

  # Set the name of the player, changing this will affect which save file to load.
  # @since 0.2.6
  # @version 1.1.0
  def profile_lookup(load_savefile)
    # set player name
    self.name = cli.user_input(cli.t("hm.p_name"))
    savefile[:name] = name

    if FUS.check_file?(FUS.data_path(name)) || !load_savefile
      # valid previous user or new player selecting mode 1
      self
    else
      # new player selecting the wrong option or no save found
      puts "No save found. Switching to new player mode..."
      nil
    end
  end

  # @since 0.1.1
  # @version 1.1.2
  def new_save
    @savefile = { saved_date: Time.now.ceil, name: name, hangman_data: { mode: mode, sessions: [] } }
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
    overwrite_save
    @sessions = savefile.dig(:hangman_data, :sessions)
    @session_counts = sessions.size
  end

  # Add latest session to savefile and store game save to disk
  # @since 0.1.4
  # @version 1.0.1
  def save_game(session_obj)
    sessions[session_counts - 1] = session_obj
    overwrite_save
  end

  # Find the latest session
  # @since 0.1.3
  # @version 1.1.0
  def resume_session
    session = sessions.bsearch { |game| game[:status] == :active }
    puts cli.t("player.no_active_err") if session.nil?
    session
  end
end
