# frozen_string_literal: true

require "colorize"
require_relative "file_utils"
require_relative "hangman"
require_relative "player"
# Console class
# Centralize command usage and event dispatcher
#
# @author Ancient Nimbus
# @since 0.1.7
# @version 1.2.0
class Console
  attr_accessor :cli_running, :app_running, :input_is_cmd, :app
  attr_reader :commands

  def initialize
    @cli_running = true
    @app_running = false
    @input_is_cmd = false
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
    # process_input(user_input) while cli_running
    process_input("--play hangman") while cli_running
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

  # Processes user input, determining if it is a command, a regular expression, or plain input.
  #
  # @param input [String] The user input to process.
  # @param regexp_on [Boolean] Whether to process the input as a regular expression. Defaults to false.
  # @param reg [Regexp] The regular expression to use if regexp_on is true. Defaults to /.*/.
  # @return [Object] The result of processing the command, the result of processing the regular expression,
  #   or the original input string.
  # @since 0.1.8
  # @version 1.3.0
  def process_input(input, use_reg: false, reg: /.*/, invalid_msg: t("console.invalid_warning"))
    self.input_is_cmd = false
    is_command = input[0..1] == "--"
    parts = input.split(" ")

    if is_command
      args = parts[1..] || []
      process_command(parts[0], args)
    end

    use_reg ? process_regexp(input, reg, invalid_msg) : input
  end

  # @since 0.1.9
  # @version 1.1.0
  def process_command(command, args = [])
    self.input_is_cmd = true
    command = command.downcase.gsub("-", "")
    commands.key?(command) ? commands[command].call(args) : puts(t("error.cmd_not_found", { command: command }))
    command
  end

  # @since 0.1.9
  # @version 1.2.0
  def process_regexp(input, reg, invalid_msg = t("console.invalid_warning"))
    until input.match?(reg) && !input.empty?
      input = process_input(user_input(input_is_cmd ? "" : invalid_msg)) # print on second entry
    end
    input
  end

  # @since 0.2.2
  # @version 1.0.0
  def restart(_args = [])
    return unless app_running

    process_input(user_input(t("hm.next_game.msg")), use_reg: true, reg: t("hm.next_game.reg", prefix: "")) == "yes"
  end

  # @since 0.2.3
  # @version 1.1.0
  def load_session(_args = [])
    return unless app_running

    process_input(user_input(t("hm.save.msg")), use_reg: true, reg: t("hm.save.reg", prefix: "")).to_i == 2
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
  def confirm(_args = []); end
  # @since 0.1.8
  # @version 1.0.0
  def decline(_args = []); end

  # Launch a program
  # @since 0.1.8
  # @version 1.1.0
  def play(args = [])
    return puts t("error.app_running").colorize(:red) if app_running

    @app = Hangman.new(self) if args.include?("hangman")
    self.app_running = false
  end
end
