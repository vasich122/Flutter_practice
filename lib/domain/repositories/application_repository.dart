import '../../core/models/application_model.dart';

/// Абстрактный интерфейс репозитория заявлений
abstract class ApplicationRepository {
  /// Получить все заявления
  Future<List<ApplicationModel>> getApplications();

  /// Создать новое заявление
  Future<ApplicationModel> createApplication(String type, String description);

  /// Обновить заявление
  Future<ApplicationModel> updateApplication(
    String id,
    String type,
    String description,
  );

  /// Удалить заявление
  Future<void> deleteApplication(String id);

  /// Отправить заявление
  Future<ApplicationModel> sendApplication(String id);
}

