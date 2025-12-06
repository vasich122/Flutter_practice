import '../../core/models/academic_info_model.dart';
import '../../domain/repositories/academic_repository.dart';
import '../datasources/academic/academic_local_data_source.dart';

/// Реализация репозитория академической информации
class AcademicRepositoryImpl implements AcademicRepository {
  final AcademicLocalDataSource _localDataSource;

  AcademicRepositoryImpl(this._localDataSource);

  @override
  Future<AcademicInfoModel> getAcademicInfo() async {
    final data = await _localDataSource.getAcademicInfo();
    return AcademicInfoModel(
      institute: data['institute'] as String,
      profile: data['profile'] as String,
      profilePeriod: data['profilePeriod'] as String,
      averageGrade: data['averageGrade'] as double,
      semester: data['semester'] as String,
      scientificActivities: data['scientificActivities'] as String,
      practice: data['practice'] as String,
      courseWorks: data['courseWorks'] as String,
    );
  }

  @override
  Future<void> updateScientificActivities(String activities) async {
    await _localDataSource.updateScientificActivities(activities);
  }
}

