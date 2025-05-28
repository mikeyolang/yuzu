import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:yuzu/features/home/letterCombinationModel.dart';
import 'package:yuzu/features/home/wordDataModel.dart';

// Import these from home_screen.dart in your actual implementation
// For the artifact, I'm including them here for completeness

class GameScreen extends StatefulWidget {
  final List<LetterCombination> letterCombinations;

  const GameScreen({
    super.key,
    required this.letterCombinations,
  });

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Current letter combination index
  int _currentIndex = 0;

  // Currently displayed letters
  late String _displayLetters;

  // Current possible words data
  late List<WordData> _possibleWords;

  // Words found by the user
  final List<String> foundWords = [];
  final TextEditingController _wordController = TextEditingController();
  late Timer _timer;
  int _seconds = 0;
  bool _allWordsFound = false;

  @override
  void initState() {
    super.initState();
    // Initialize with the first letter combination
    _loadCurrentCombination();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _wordController.dispose();
    super.dispose();
  }

  void _loadCurrentCombination() {
    if (_currentIndex < widget.letterCombinations.length) {
      final combo = widget.letterCombinations[_currentIndex];

      // Get the current letter combination
      setState(() {
        // Randomize the display order of letters
        List<String> lettersList = combo.letters.split('');
        lettersList.shuffle();
        _displayLetters = lettersList.join('');

        // Set possible words
        _possibleWords = combo.possibleWords;

        // Reset found words
        foundWords.clear();

        // Reset all words found flag
        _allWordsFound = false;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _checkWord() {
    String word = _wordController.text.trim().toUpperCase();

    if (word.isEmpty) return;

    // Check if the word is in the possible words list
    WordData? matchedWordData;
    for (var wordData in _possibleWords) {
      if (wordData.word.toUpperCase() == word && !foundWords.contains(word)) {
        matchedWordData = wordData;
        break;
      }
    }

    if (matchedWordData != null) {
      setState(() {
        foundWords.add(word);
        _wordController.clear();

        // Check if all words have been found
        if (foundWords.length == _possibleWords.length) {
          _allWordsFound = true;
          _timer.cancel(); // Stop the timer when all words are found
        }
      });

      // Show success message with hooks information
      String hooksInfo = '';

      if (matchedWordData.frontHooks.isNotEmpty) {
        hooksInfo += '\nFront hooks: ${matchedWordData.frontHooks.join(', ')}';
      }

      if (matchedWordData.backHooks.isNotEmpty) {
        hooksInfo += '\nBack hooks: ${matchedWordData.backHooks.join(', ')}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Great job! "$word" is correct!$hooksInfo'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } else if (foundWords.contains(word)) {
      // Word already found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You already found "$word"'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 1),
        ),
      );
      _wordController.clear();
    } else {
      // Incorrect word
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"$word" is not a valid word for these letters'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 1),
        ),
      );
      _wordController.clear();
    }
  }

  void _moveToNextCombination() {
    // Save current stats before moving to next combination
    // In a real app, you would store these stats in a database

    // Move to next combination
    setState(() {
      _currentIndex++;

      // Check if we've reached the end of combinations
      if (_currentIndex >= widget.letterCombinations.length) {
        // If we've gone through all combinations, show completion dialog
        _showCompletionDialog();
        return;
      }

      // Reset for new combination
      foundWords.clear();
      _seconds = 0;
      _allWordsFound = false;
      _loadCurrentCombination();
      _startTimer();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Moving to next letter combination...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: const Text('You have completed all letter combinations!'),
          actions: [
            TextButton(
              child: const Text('Return to Home'),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }

  void _shuffleLetters() {
    setState(() {
      List<String> letters = _displayLetters.split('');
      letters.shuffle();
      _displayLetters = letters.join('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Yuzu',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFF9800),
        elevation: 0,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                _formatTime(_seconds),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF9800), Color(0xFFFFF3E0)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Progress indicator
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${foundWords.length}/${_possibleWords.length} words found",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE65100),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Letter combination display
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Unscramble these letters:",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _displayLetters.split('').map((letter) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 50,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF9800),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                letter,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _shuffleLetters,
                        icon:
                            const Icon(Icons.shuffle, color: Color(0xFFFF9800)),
                        label: const Text(
                          "Shuffle Letters",
                          style: TextStyle(color: Color(0xFFFF9800)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFFFF9800)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Word input field
                TextField(
                  controller: _wordController,
                  textCapitalization: TextCapitalization.characters,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: "Enter a word",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFFFF9800)),
                      onPressed: _checkWord,
                    ),
                  ),
                  onSubmitted: (_) => _checkWord(),
                ),

                const SizedBox(height: 24),

                // Found words list
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Words Found:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE65100),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: foundWords.isEmpty
                              ? const Center(
                                  child: Text(
                                    "No words found yet. Start typing!",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: foundWords.length,
                                  itemBuilder: (context, index) {
                                    // Find the corresponding WordData for this word
                                    WordData? wordData;
                                    for (var data in _possibleWords) {
                                      if (data.word.toUpperCase() ==
                                          foundWords[index]) {
                                        wordData = data;
                                        break;
                                      }
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                foundWords[index],
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (wordData != null)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 28, top: 4),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (wordData
                                                      .frontHooks.isNotEmpty)
                                                    Text(
                                                      "Front hooks: ${wordData.frontHooks.join(', ')}",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[700],
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                    ),
                                                  if (wordData
                                                      .backHooks.isNotEmpty)
                                                    Text(
                                                      "Back hooks: ${wordData.backHooks.join(', ')}",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[700],
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          const Divider(height: 8),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Next button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _allWordsFound ? _moveToNextCombination : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9800),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    child: const Text(
                      "Next Combination",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
