import '../../core/models/academic_info_model.dart';

/// Абстрактный интерфейс репозитория академической информации
abstract class AcademicRepository {
  /// Получить академическую информацию
  Future<AcademicInfoModel> getAcademicInfo();

  /// Обновить научные активности
  Future<void> updateScientificActivities(String activities);
}

