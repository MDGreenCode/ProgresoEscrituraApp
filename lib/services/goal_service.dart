import 'package:flutter/foundation.dart';
import '../models/writing_goal.dart';

class GoalService extends ChangeNotifier {
  final List<WritingGoal> _goals = [];

  List<WritingGoal> get goals => List.unmodifiable(_goals);

  void addGoal(WritingGoal goal) {
    _goals.add(goal);
    notifyListeners();
  }

  void updateGoal(String id, WritingGoal updatedGoal) {
    final index = _goals.indexWhere((goal) => goal.id == id);
    if (index != -1) {
      _goals[index] = updatedGoal;
      notifyListeners();
    }
  }

  void deleteGoal(String id) {
    _goals.removeWhere((goal) => goal.id == id);
    notifyListeners();
  }

  WritingGoal? getGoal(String id) {
    try {
      return _goals.firstWhere((goal) => goal.id == id);
    } catch (e) {
      return null;
    }
  }

  void addWordsToGoal(String goalId, int words) {
    final goal = getGoal(goalId);
    if (goal != null) {
      goal.addWords(words, DateTime.now());
      notifyListeners();
    }
  }
}