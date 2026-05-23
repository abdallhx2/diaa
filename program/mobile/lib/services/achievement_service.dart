import 'package:edu_smart_assistant/services/api_service.dart';
import 'package:edu_smart_assistant/models/achievement_model.dart';
import 'package:edu_smart_assistant/models/streak_model.dart';

class AchievementService {
  final ApiService _api = ApiService();

  Future<List<AchievementModel>> getCatalog() async {
    try {
      final response = await _api.get('/achievements/catalog');
      final data = response.data;
      if (data['success'] == true) {
        final list = data['data'] as List<dynamic>;
        return list
            .map((e) => AchievementModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (_) {
      throw Exception('فشل في جلب الإنجازات');
    }
  }

  Future<({List<AchievementModel> achievements, StreakModel streak})>
      getMyProgress() async {
    try {
      final response = await _api.get('/achievements/me');
      final data = response.data;
      if (data['success'] == true) {
        final body = data['data'] as Map<String, dynamic>;
        final achievements = (body['achievements'] as List<dynamic>)
            .map((e) => AchievementModel.fromJson(e as Map<String, dynamic>))
            .toList();
        final streak = StreakModel.fromJson(
            body['streak'] as Map<String, dynamic>);
        return (achievements: achievements, streak: streak);
      }
      throw Exception('فشل في جلب تقدم الطالب');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('فشل في جلب تقدم الطالب');
    }
  }
}
