# frozen_string_literal: true

require "yaml"
require "json"

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
    # @version 1.1.0
    def assets_path(filename)
      File.join(proj_root, "assets", formatted_filename(filename))
    end

    # Return the data path.
    # @version 1.1.0
    def data_path(filename)
      File.join(proj_root, "data", formatted_filename(filename))
    end

    # Return cross-system friendly filename
    # @param filename [String]
    # @return [String] Formatted filename
    # @since 0.1.3
    # @version 1.0.0
    def formatted_filename(filename)
      filename.downcase.gsub(" ", "_")
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
    # @return [Hash, nil] hash of index and word, or nil if file not found
    # @since 0.1.2
    # @version 1.1.0
    def random_word(filepath)
      return puts "File not found: #{filepath}" unless File.exist?(filepath)

      File.open(filepath, "r") do |textfile|
        lines = textfile.readlines(chomp: true)
        word = lines.sample
        idx = lines.index(word)
        return { id: idx, word: word }
      end
    end

    # @since 0.1.5
    # @version 1.0.0
    def lookup_line(filepath, line_num)
      return puts "File not found: #{filepath}" unless File.exist?(filepath)

      File.open(filepath, "r") do |textfile|
        lines = textfile.readlines(chomp: true)
        lines[line_num]
      end
    end

    # @since 0.2.8
    # @version 1.0.0
    def check_file?(filepath, use_filetype: true, default_type: ".yml")
      default_type = "" unless use_filetype
      File.exist?(filepath + default_type)
    end

    # Writes the given data to a file in YAML or JSON format.
    # @param filepath [String] The base path of the file to write (extension is added automatically).
    # @param data [Object] The data to serialize and write.
    # @param format [Symbol] The format to use (:yml or :json). Defaults to :yml.
    # @since 0.1.3
    # @version 1.2.0
    def write_savefile(filepath, data, format: :yml)
      # @todo error handling
      filepath += format == :yml ? ".yml" : ".json"
      File.open(filepath, "w") do |output|
        return output.puts data.to_yaml if format == :yml
        return output.puts data.to_json if format == :json
      end
    end

    # Load file in YAML or JSON format.
    # @param filepath [String] The base path of the file to write (extension is added automatically).
    # @return [Hash]
    # @since 0.1.3
    # @version 1.1.0
    def load_file(filepath, format: :yml, symbols: true)
      filepath += format == :yml ? ".yml" : ".json"
      return puts "File not found: #{filepath}" unless File.exist?(filepath)

      File.open(filepath, "r") do |save|
        data = if format == :yml
                 YAML.safe_load(save, permitted_classes: [Time, Symbol], aliases: true, freeze: true)
               else
                 JSON.parse(save.read)
               end
        return symbols ? to_symbols(data) : data
      end
    end

    # Convert string keys to symbol keys.
    # @param obj [Object]
    # @return [Hash]
    # @since 0.1.3
    # @version 1.0.0
    def to_symbols(obj)
      case obj
      when Hash
        obj.transform_keys(&:to_sym).transform_values { |v| to_symbols(v) }
      when Array
        obj.map { |e| to_symbols(e) }
      else
        obj
      end
    end

    # Retrieves a localized string by key path from the specified locale file.
    # Returns a missing message if the locale or key is not found.
    # @param key_path [String] e.g., "welcome.greeting"
    # @since 0.1.7
    # @version 1.0.0
    def get(key_path, locale: "en")
      filepath = File.join(proj_root, ".config", "locales", locale)
      strings = load_file(filepath, symbols: false)

      locale_strings = strings[locale]
      return "Missing locale: #{locale}" unless locale_strings

      keys = key_path.to_s.split(".")

      result = keys.reduce(locale_strings) do |val, key|
        val&.[](key)
      end

      result || "Missing string: #{key_path}"
    end

    # Translates a string by key and replaces placeholders with provided values.
    # @param key_path [String] the translation key path e.g., "welcome.greeting"
    # @param swaps [Hash] placeholders and their replacement values
    # @param locale [String] the locale to use (default: "en")
    # @return [String] the translated and interpolated string
    # @since 0.1.7
    # @version 1.1.0
    def t(key_path, swaps = {}, locale: "en")
      string = get(key_path, locale: locale)

      swaps.each do |key, value|
        string = string.gsub(/%\{#{key}\}/, value.to_s)
      end

      string
    end
  end
end

# Alias to FileUtils helper module
FUS = FileUtils
