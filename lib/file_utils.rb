# frozen_string_literal: true

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
    #
    # @param input_path [String] Path to the input file.
    # @param output_path [String] Path to the output file.
    # @param min_char [Integer] Minimum word length (default: 5).
    # @param max_char [Integer] Maximum word length (default: 12).
    # @version 1.0.0
    def text_filter(input_path, output_path, min_char: 5, max_char: 12)
      return puts "'#{input_path}' File does not exist." unless File.exist?(input_path)

      File.open(input_path, "r") do |input|
        File.open(output_path, "w") do |output|
          input.each_line(chomp: true) do |word|
            output.puts word if [*min_char..max_char].include?(word.size)
          end
        end
      end
    end
  end
end
