# frozen_string_literal: true

require_relative "file_utils"

# Player class
# @version 1.0.2
class Player
  include FUS

  attr_accessor :name, :mode, :savefile, :sessions, :session_counts
  attr_reader :cli

  def initialize(console, name: "Spock", mode: 1)
    @cli = console
    @name = name
    @mode = mode
    new_save
    @sessions = savefile.dig(:hangman_data, :sessions)
    @session_counts = sessions.size
  end

  # @since 0.2.9
  # @version 1.1.1
  def set_name
    # set player name
    self.name = cli.process_input(cli.user_input(cli.t("hm.p_name")),
                                  invalid_msg: cli.t("player.no_name_err")).capitalize
    refresh_savefile
  end

  # @since 0.2.9
  # @version 1.1.1
  def set_mode
    # set difficulty
    self.mode = cli.process_input(
      cli.user_input(
        cli.t("hm.mode.msg", { name: name.colorize(:yellow) })
      ), reg: cli.t("hm.mode.reg", prefix: ""), invalid_msg: cli.t("hm.mode.err")
    ).to_i
    refresh_savefile
  end

  # @since 0.3.1
  # @version 1.0.0
  def refresh_savefile
    savefile[:name] = name
    savefile[:hangman_data][:mode] = mode
  end

  # Set the name of the player, changing this will affect which save file to load.
  # @since 0.2.6
  # @version 1.2.0
  def profile_lookup(load_savefile)
    # Set name
    set_name

    # valid previous user or new player selecting mode 1
    return self if FUS.check_file?(FUS.data_path(name))

    # new player selecting the wrong option or no save found
    puts cli.t("player.no_profile_err") if load_savefile

    # Set mode
    set_mode
    # New player
    return self unless load_savefile

    nil
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
  # @version 1.1.0
  def load_save
    self.savefile = FUS.load_file(FUS.data_path(name))
    # overwrite_save
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
