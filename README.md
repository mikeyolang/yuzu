# Yuzu - Scrabble Word Learning Tool

A Flutter-based application designed to help Scrabble players learn and practice word combinations, hooks, and anagrams.

## Features

- Upload custom word lists with front and back hooks
- Practice unscrambling letters to find valid Scrabble words
- Learn front and back hooks for common Scrabble words
- Track your learning progress with statistics
- Supports words from 2 to 10 letters

## File Format

The app accepts text files (.txt) with the following format:
```
WORD    FRONTHOOKS    BACKHOOKS
```
Example:
```
AIDA    z    s
IDEA         ls
```
- Words should be in capital letters
- Hooks should be separated by tabs or multiple spaces
- Front hooks appear before the word (e.g., zAIDA)
- Back hooks appear after the word (e.g., AIDAs)

## Getting Started

1. Clone this repository
2. Install Flutter if you haven't already
3. Run `flutter pub get` to install dependencies
4. Launch the app using `flutter run`

## Built With

- Flutter - Cross-platform UI framework
- File Picker - For handling file uploads
- Material Design - UI components and theming

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Version

Current Version: 1.0.0
