import '../core/preferences_helper.dart';

class AcademicLocalDataSource {
  final PreferencesHelper _prefsHelper = PreferencesHelper.instance;
  
  static const String _defaultScientificActivities = 
      'Участие в проекте «Умный кампус», публикация в сборнике МИРЭА';

  Future<Map<String, dynamic>> getAcademicInfo() async {
    final scientificActivities = await _prefsHelper.getScientificActivities() 
        ?? _defaultScientificActivities;
    
    return {
      'institute': 'Институт искусственного интеллекта',
      'profile': 'Разработка программного обеспечения',
      'profilePeriod': '2022–2026',
      'averageGrade': 4.3,
      'semester': 'Весна 2025/2026',
      'scientificActivities': scientificActivities,
      'practice': 'Преддипломная практика в лаборатории искусственного интеллекта',
      'courseWorks': 'Подготовлено 6 работ, 2 отмечены как лучшие в группе',
    };
  }

  Future<void> updateScientificActivities(String activities) async {
    await _prefsHelper.saveScientificActivities(activities);
  }
}

