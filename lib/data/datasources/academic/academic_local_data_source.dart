/// Локальный источник данных для академической информации
class AcademicLocalDataSource {
  String _scientificActivities = 'Участие в проекте «Умный кампус», публикация в сборнике МИРЭА';

  Future<Map<String, dynamic>> getAcademicInfo() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return {
      'institute': 'Институт искусственного интеллекта',
      'profile': 'Разработка программного обеспечения',
      'profilePeriod': '2022–2026',
      'averageGrade': 4.3,
      'semester': 'Весна 2025/2026',
      'scientificActivities': _scientificActivities,
      'practice': 'Преддипломная практика в лаборатории искусственного интеллекта',
      'courseWorks': 'Подготовлено 6 работ, 2 отмечены как лучшие в группе',
    };
  }

  Future<void> updateScientificActivities(String activities) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _scientificActivities = activities;
  }
}

