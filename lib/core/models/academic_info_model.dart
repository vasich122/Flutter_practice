/// Бизнес-модель академической информации
/// Представляет академические данные студента
class AcademicInfoModel {
  final String institute;
  final String profile;
  final String profilePeriod;
  final double averageGrade;
  final String semester;
  final String scientificActivities;
  final String practice;
  final String courseWorks;

  const AcademicInfoModel({
    required this.institute,
    required this.profile,
    required this.profilePeriod,
    required this.averageGrade,
    required this.semester,
    required this.scientificActivities,
    required this.practice,
    required this.courseWorks,
  });

  AcademicInfoModel copyWith({
    String? institute,
    String? profile,
    String? profilePeriod,
    double? averageGrade,
    String? semester,
    String? scientificActivities,
    String? practice,
    String? courseWorks,
  }) {
    return AcademicInfoModel(
      institute: institute ?? this.institute,
      profile: profile ?? this.profile,
      profilePeriod: profilePeriod ?? this.profilePeriod,
      averageGrade: averageGrade ?? this.averageGrade,
      semester: semester ?? this.semester,
      scientificActivities: scientificActivities ?? this.scientificActivities,
      practice: practice ?? this.practice,
      courseWorks: courseWorks ?? this.courseWorks,
    );
  }
}

