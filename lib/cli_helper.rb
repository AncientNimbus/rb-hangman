# frozen_string_literal: true

require "io/console"

# CLI Operations helper module
#
# @author Ancient Nimbus
# @since 0.1.7
module CliHelper
  # A method that collects user input, and only returns the value
  # when it is validated against the provided Regex pattern.
  # @param reg [Regexp] a Regex pattern to check against user inputs
  # @param msg [String] prompt to print to the user
  # @param err_msg [String] display warning message when on invalid inputs
  # @param type_mode [Boolean] toggle true to enable typewriter style output
  # @return [String] user input
  # @version 2.0.1
  def get_input(reg = /.*/, msg = "Enter your input...", err_msg = nil, exit_str: "exit", type_mode: true)
    input_value = ""
    first_entry = true

    until input_value.match?(reg) && !input_value.empty?
      message = first_entry ? msg : err_msg
      slowed_reply("\n* #{message}", type_mode: type_mode)
      first_entry = false

      input_value = gets.chomp
      exit if input_value == exit_str
    end
    input_value
  end

  # A method that prints text to the console one character at a time.
  # @param str [String] text to print
  # @param delay [Float] character output rate in second
  # @return [nil] an empty line
  # @version 1.0.0
  def typewriter(str, delay: 0.025)
    str.each_char do |char|
      print char
      sleep(delay)
    end
    puts
  end

  # A method that prints text to the console at a delayed rate.
  # The idea here is to simulate a chatbot-like behavior.
  # @param str_arr [Array<String>] an array of strings, the method will print one element at a time
  # @param delay [Float] line output rate in second
  # @param type_mode [Boolean] toggle true to enable typewriter style output
  # @param tw_delay [Float] character output rate in second
  # @return [void]
  # @version 1.2.1
  def slowed_reply(str_arr, delay: 0.5, type_mode: true, tw_delay: 0.025)
    str_arr = [str_arr] if str_arr.is_a?(String)
    disable_user_input?(true)
    puts
    str_arr.each do |str|
      type_mode ? typewriter(str, delay: tw_delay) : puts(str)
      sleep(delay)
    end
    disable_user_input?(false)
  end

  # A method that masked user input.
  # @return [String]
  # @version 1.0.0
  def get_secret(str = "Enter your secret: ")
    print str
    secret = $stdin.noecho(&:gets).chomp
    puts
    secret
  end

  # Disable user input when prompt is printing.
  # @param toggle [Boolean] toggle true to disable user input
  # @version 1.0.0
  def disable_user_input?(toggle)
    if toggle
      $stdin.echo = false
    else
      $stdout.flush
      $stdin.echo = true
    end
  end

  # A method that prints a message upon exiting the program.
  # @param str [String] text to print when user exit the program
  # @return [void]
  # @version 1.0.0
  def self.do_at_exit(str = "* Bye~")
    puts
    at_exit { puts str }
  end
end

# CliHelper Alias
CH = CliHelper
