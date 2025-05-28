import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:yuzu/features/home/letterCombinationModel.dart';
import 'package:yuzu/features/home/wordDataModel.dart';

class FilePickerService {
  static Future<List<LetterCombination>?> pickAndProcessFile(
      BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
      );

      if (result != null) {
        final File file = File(result.files.single.path!);
        final String content = await file.readAsString();
        return _processFileContent(content);
      }
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing file: ${e.toString()}')),
      );
      return null;
    }
  }

  static List<LetterCombination> _processFileContent(String content) {
    final lines = content.split('\n');
    final Map<String, List<WordData>> wordsByLetters = {};

    for (var line in lines) {
      if (line.trim().isEmpty) continue;

      final parts = line.trim().split(RegExp(r'\t+|\s{2,}'));
      if (parts.isEmpty || parts[0].trim().isEmpty) continue;

      final String word = parts[0].trim().toUpperCase();
      if (word.length < 2 || word.length > 10) continue;
      if (!RegExp(r'^[A-Z]+$').hasMatch(word)) continue;

      List<String> frontHooks = [];
      List<String> backHooks = [];

      if (parts.length > 1 && parts[1].trim().isNotEmpty) {
        String frontHooksStr = parts[1].trim().toUpperCase();
        frontHooks = frontHooksStr
            .split('')
            .where((hook) => RegExp(r'^[A-Z]$').hasMatch(hook))
            .toList();
      }

      if (parts.length > 2 && parts[2].trim().isNotEmpty) {
        String backHooksStr = parts[2].trim().toUpperCase();
        backHooks = backHooksStr
            .split('')
            .where((hook) => RegExp(r'^[A-Z]$').hasMatch(hook))
            .toList();
      }

      final wordData = WordData(
        word: word,
        frontHooks: frontHooks,
        backHooks: backHooks,
      );

      final sortedLetters = word.split('').toList()..sort();
      final String letterKey = sortedLetters.join('');

      if (!wordsByLetters.containsKey(letterKey)) {
        wordsByLetters[letterKey] = [];
      }
      wordsByLetters[letterKey]!.add(wordData);
    }

    final List<LetterCombination> result = [];
    wordsByLetters.forEach((letters, words) {
      if (words.isNotEmpty) {
        result.add(LetterCombination(
          letters: letters,
          possibleWords: words,
        ));
      }
    });

    return result;
  }
}
