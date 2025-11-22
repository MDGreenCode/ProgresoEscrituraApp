class WritingGoal {
  String id;
  String title;
  String description;
  int targetWords;
  int currentWords;
  DateTime startDate;
  DateTime endDate;
  Map<DateTime, int> dailyProgress;
  bool isCompleted;

  WritingGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetWords,
    required this.startDate,
    required this.endDate,
    this.currentWords = 0,
    this.dailyProgress = const {},
    this.isCompleted = false,
  });

  double get progressPercentage {
    return (currentWords / targetWords).clamp(0.0, 1.0);
  }

  int get wordsRemaining {
    return targetWords - currentWords;
  }

  int get daysRemaining {
    final now = DateTime.now();
    final remaining = endDate.difference(now).inDays;
    return remaining > 0 ? remaining : 0;
  }

  int get wordsPerDay {
    if (daysRemaining == 0) return wordsRemaining;
    return (wordsRemaining / daysRemaining).ceil();
  }

  void addWords(int words, DateTime date) {
    currentWords += words;
    dailyProgress[date] = (dailyProgress[date] ?? 0) + words;

    if (currentWords >= targetWords) {
      isCompleted = true;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetWords': targetWords,
      'currentWords': currentWords,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'dailyProgress': dailyProgress.map((key, value) =>
          MapEntry(key.toIso8601String(), value)),
      'isCompleted': isCompleted,
    };
  }

  factory WritingGoal.fromMap(Map<String, dynamic> map) {
    return WritingGoal(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      targetWords: map['targetWords'],
      currentWords: map['currentWords'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      dailyProgress: (map['dailyProgress'] as Map<String, dynamic>).map((key, value) =>
          MapEntry(DateTime.parse(key), value as int)),
      isCompleted: map['isCompleted'],
    );
  }
}