import '../../core/models/academic_info_model.dart';
import '../repositories/academic_repository.dart';

/// Use Case для получения академической информации
class GetAcademicInfoUseCase {
  final AcademicRepository _repository;

  GetAcademicInfoUseCase(this._repository);

  Future<AcademicInfoModel> call() => _repository.getAcademicInfo();
}

