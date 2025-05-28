import 'package:yuzu/features/home/wordDataModel.dart';

class LetterCombination {
  final String letters;
  final List<WordData> possibleWords;

  LetterCombination({
    required this.letters,
    required this.possibleWords,
  });
}
