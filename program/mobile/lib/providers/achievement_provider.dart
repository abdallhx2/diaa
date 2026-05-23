import 'package:flutter/material.dart';
import 'package:edu_smart_assistant/models/achievement_model.dart';
import 'package:edu_smart_assistant/models/streak_model.dart';
import 'package:edu_smart_assistant/services/achievement_service.dart';

class AchievementProvider extends ChangeNotifier {
  List<AchievementModel> _achievements = [];
  StreakModel _streak = StreakModel.empty;
  bool _isLoading = false;
  String? _errorMessage;

  // Tracks codes that were unlocked before last load — used for toast detection.
  Set<String> _previouslyUnlocked = {};
  List<AchievementModel> _newlyUnlocked = [];

  List<AchievementModel> get achievements => _achievements;
  StreakModel get streak => _streak;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<AchievementModel> get newlyUnlocked => _newlyUnlocked;

  final AchievementService _service = AchievementService();

  Future<void> loadProgress() async {
    _isLoading = true;
    _errorMessage = null;
    _newlyUnlocked = [];
    notifyListeners();

    try {
      final result = await _service.getMyProgress();
      final achievements = result.achievements;

      // Detect newly unlocked since last load.
      final nowUnlocked = achievements
          .where((a) => a.isUnlocked)
          .map((a) => a.code)
          .toSet();
      _newlyUnlocked = achievements
          .where((a) => a.isUnlocked && !_previouslyUnlocked.contains(a.code))
          .toList();
      _previouslyUnlocked = nowUnlocked;

      _achievements = achievements;
      _streak = result.streak;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
  }

  void cleanup() {
    _achievements = [];
    _streak = StreakModel.empty;
    _errorMessage = null;
    _newlyUnlocked = [];
    notifyListeners();
  }
}
