# frozen_string_literal: true

# Console class
# Centralize command usage and event dispatcher
#
# @author Ancient Nimbus
# @since 0.1.7
# @version 1.0.0
class Console
  def initialize
    @app_running = true
    @commands = {
      "exit" => method(:quit), "quit" => method(:quit),
      "help" => method(:show_help),
      "save" => method(:save_session), "load" => method(:load_session),
      "yes" => method(:confirm), "y" => method(:confirm),
      "no" => method(:decline), "n" => method(:decline)
    }
  end

  def run
    puts "Welcome to the central command, type 'help' for more commands."
    quit
  end

  def process_input; end

  def quit
    at_exit { puts "Goodbye" }
    exit
  end

  def show_help; end
  def save_session; end
  def load_session; end
  def confirm; end
  def decline; end
end

Console.new.run
