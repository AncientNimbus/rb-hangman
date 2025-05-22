# Hangman ♦️

The [Hangman](https://en.wikipedia.org/wiki/Hangman_(game)) is a classic guessing game.

![Hangman Cover](https://github.com/user-attachments/assets/9609f77a-809a-44d0-aff1-77934d58456e)

## User Features Highlights

- Mutliple diffculty levels
  - Easy, Standard or Hard
- Unique Hangman gallows design with progressive updates
- Save & Resume gameplay, never lose progress mid-game with autosave
- Visual alphabet tracker, showing used and available letters
- Colorized terminal output

## Technical Highlights

- OOP structure
- Code design with i18n in mind (YAML locale files)
- Guess word is not stored in player savefile to prevent cheating
- Regex-based input validation
- Session management, supporting multiple concurrent games

A demo savefile is storeed in the `data/` directory.

## Getting Started

Follow the simple steps below to get started:

1. Ensure that Ruby `v3.X.X` is correctly installed on your device.
2. Clone the repo to your device.
3. Open the directory via the terminal: `cd rb-hangman/`.
4. Installed the required Gems: `bundle install`.
5. You are ready to launch the program: `bundle exec ruby main.rb`.

## Example Game flow (New Game)

Once you have launched the program, follow the steps below to start a game session.

1. Launch Hangman with a launch command: `--play hangman` or `-p hangman`.
2. Read the How-to-play section to learn more about the game.
3. Type `1` to create a new player profile.
4. Give your profile a name.
5. Select a level difficulty, e.g., `2` for standard.
6. A game session will start.
7. Start guessing by typing a single character to the prompt.
8. You can leave the game any time by typing the following command: `-q`, `--exit`, `--ttfn`.
9. You can find the savefile(player name) in the `data/` folder.

**Load a session**

1. Launch Hangman with a launch command. (See above)
2. Type `2` to load save.
3. Type your player profile name
4. If a savefile is found, your session is resumed.
5. If a savefile is not found(or type a wrong name), a new profile will be created.

For more command, type `-h` or `--help` to print the command tips.

## Screenshots

![Guess and Losing showcase](https://github.com/user-attachments/assets/06f808fc-df66-4c0f-822b-8eda77c9f3b2)


## Gems used

- Rubocop
- Colorize
- Yard

## Resources

I have published my Hangman gallows design as a separate file [here](https://gist.github.com/AncientNimbus/d33025fe15718289c7168caa5b0c34c3). Feel free to use it for your own project ;) 
