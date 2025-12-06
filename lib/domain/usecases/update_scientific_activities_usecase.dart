import '../repositories/academic_repository.dart';

/// Use Case для обновления научных активностей
class UpdateScientificActivitiesUseCase {
  final AcademicRepository _repository;

  UpdateScientificActivitiesUseCase(this._repository);

  Future<void> call(String activities) =>
      _repository.updateScientificActivities(activities);
}

