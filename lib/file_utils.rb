# frozen_string_literal: true

require "yaml"
# Helper module for file operations
# @author Ancient Nimbus
# @since 0.1.1
module FileUtils
  class << self
    # Return the root path.
    # @version 1.0.0
    def proj_root
      @proj_root ||= File.expand_path("../", __dir__)
    end

    # Return the assets path.
    # @version 1.0.0
    def assets_path(filename)
      File.join(proj_root, "assets", filename)
    end

    # Return the data path.
    # @version 1.0.0
    def data_path(filename)
      File.join(proj_root, "data", filename)
    end

    # Filters lines from the input file by word length and writes them to the output file.
    # Only words with length between min_char and max_char (inclusive) are kept.
    # Prints an error if the file does not exist.
    #
    # @param input_path [String] Path to the input file.
    # @param output_path [String] Path to the output file.
    # @param min_char [Integer] Minimum word length (default: 5).
    # @param max_char [Integer] Maximum word length (default: 12).
    # @version 1.0.2
    def text_filter(input_path, output_path, min_char: 5, max_char: 12)
      return puts "File not found: #{filepath}" unless File.exist?(input_path)

      File.open(input_path, "r") do |input|
        File.open(output_path, "w") do |output|
          input.each_line(chomp: true) do |word|
            output.puts word.downcase if [*min_char..max_char].include?(word.size)
          end
        end
      end
    end

    # Selects a random word from the given file.
    # Returns a hash with the line index as key and the word as value.
    # Prints an error if the file does not exist.
    #
    # @param filepath [String] the path to the file containing words
    # @return [Hash{Integer => String}, nil] hash of index and word, or nil if file not found
    # @since 0.1.2
    # @version 1.0.0
    def random_word(filepath)
      return puts "File not found: #{filepath}" unless File.exist?(filepath)

      File.open(filepath, "r") do |textfile|
        lines = textfile.readlines(chomp: true)
        word = lines.sample
        idx = lines.index(word)
        return { idx => word }
      end
    end

    def write_savefile(filepath, data, format: "yaml")
      File.open(filepath, "w") do |output|
        output.puts data.to_yaml if format == "yaml"
      end
    end
  end
end

test_data = { saved_date: Time.now.ceil, name: "Sean Bean", hangman_data: {
  mode: "standard",
  game1: { word_id: 123, remaining_lives: 3, state: ["a", "", "", "", "e"] },
  game2: { word_id: 456, remaining_lives: 5, state: ["", "o", "a", "", ""] }
} }
FileUtils.write_savefile(FileUtils.data_path("#{test_data[:name]}.yaml"), test_data)
