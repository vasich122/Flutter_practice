import '../../core/models/application_model.dart';
import '../repositories/application_repository.dart';

/// Use Case для создания заявления
class CreateApplicationUseCase {
  final ApplicationRepository _repository;

  CreateApplicationUseCase(this._repository);

  Future<ApplicationModel> call(String type, String description) =>
      _repository.createApplication(type, description);
}

