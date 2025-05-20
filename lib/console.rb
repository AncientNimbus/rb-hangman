# frozen_string_literal: true

require "colorize"
require_relative "file_utils"
require_relative "hangman"
# Console class
# Centralize command usage and event dispatcher
#
# @author Ancient Nimbus
# @since 0.1.7
# @version 1.2.0
class Console
  attr_accessor :app_running, :game
  attr_reader :commands

  def initialize
    @app_running = true
    @commands = {
      exit: method(:quit), quit: method(:quit), ttfn: method(:quit),
      help: method(:show_help),
      save: method(:save_session), load: method(:load_session),
      yes: method(:confirm), y: method(:confirm), no: method(:decline), n: method(:decline),
      play: method(:play), restart: method(:restart)
    }.transform_keys(&:to_s)
  end

  # @since 0.1.8
  # @version 1.0.0
  def run
    puts t("welcome.greeting").colorize(:green)
    # process_input(user_input, regexp_on: true, reg: /\A[1-2]\z/) regex ver
    process_input(user_input) while app_running
  end

  # Shorthand for FUS.t() method
  # @since 0.1.8
  # @version 1.1.0
  def t(key_path, swaps = {}, locale: "en", prefix: "* ")
    prefix + FUS.t(key_path, swaps, locale: locale)
  end

  # Get user input
  # @since 0.1.8
  # @version 1.1.0
  def user_input(msg = t("console.prompt"))
    puts msg
    print t("console.input_prefix", prefix: "")
    gets.chomp
  end

  # param input [String]
  # @since 0.1.8
  # @version 1.1.0
  def process_input(input, regexp_on: false, reg: /.*/)
    is_command = input[0..1] == "--"
    parts = input.split(" ")

    if is_command
      args = parts[1..] || []
      process_command(parts[0], args)
    elsif regexp_on
      process_regexp(input, reg)
    else
      input
    end
  end

  # @since 0.1.9
  # @version 1.0.0
  def process_command(command, args = [])
    command = command.downcase.gsub("-", "")
    commands.key?(command) ? commands[command].call(args) : puts(t("error.cmd_not_found", { command: command }))
    command
  end

  # @since 0.1.9
  # @version 1.0.0
  def process_regexp(input, reg)
    until input.match?(reg) && !input.empty?
      # puts "User has entered: #{input}"
      input = process_input(user_input(t("console.invalid_warning"))) # print on second entry
    end
    input
  end

  private

  # @since 0.1.8
  # @version 1.0.0
  def quit(_args = [])
    at_exit { puts t("exit.bye") }
    exit
  end

  # @since 0.1.8
  # @version 1.0.0
  def show_help(_args = [])
    puts t("help")
  end

  # @since 0.1.8
  # @version 1.0.0
  def save_session(_args = []); end
  # @since 0.1.8
  # @version 1.0.0
  def load_session(_args = []); end
  # @since 0.1.8
  # @version 1.0.0
  def confirm(_args = []); end
  # @since 0.1.8
  # @version 1.0.0
  def decline(_args = []); end

  # Launch a program
  # @since 0.1.8
  # @version 1.0.0
  def play(args = [])
    @game = Hangman.new(self) if args.include?("hangman")
  end

  # @since 0.1.8
  # @version 1.0.0
  def restart(args = []); end
end
