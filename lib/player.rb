# frozen_string_literal: true

# Player class
class Player
  attr_accessor :name, :savefile

  def initialize(name: "Spock")
    @name = name
    @savefile = create_savefile
  end

  def create_savefile
    { saved_date: Time.now.ceil, name: name, hangman_data: {
      mode: "standard",
      game1: { word_id: 123, remaining_lives: 3, state: ["a", "", "", "", "e"] },
      game2: { word_id: 456, remaining_lives: 5, state: ["", "o", "a", "", ""] }
    } }
  end
end
