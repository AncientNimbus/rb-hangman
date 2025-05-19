# frozen_string_literal: true

require_relative "../lib/file_utils"

# Create a textfile that contains words between 5 to 12 characters long.
def create_textfile(ref_filename, new_filename)
  FileUtils.text_filter(FileUtils.assets_path(ref_filename), FileUtils.assets_path(new_filename))
end

create_textfile("wordlist-sfw-en-10k.txt", "dictionary.txt")
