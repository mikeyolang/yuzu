class WordData {
  final String word;
  final List<String> frontHooks;
  final List<String> backHooks;

  const WordData({
    required this.word,
    required this.frontHooks,
    required this.backHooks,
  });

  bool hasHooks() => frontHooks.isNotEmpty || backHooks.isNotEmpty;

  List<String> getAllPossibleWords() {
    List<String> allWords = [word];

    for (var hook in frontHooks) {
      allWords.add('$hook$word');
    }

    for (var hook in backHooks) {
      allWords.add('$word$hook');
    }

    return allWords;
  }
}
