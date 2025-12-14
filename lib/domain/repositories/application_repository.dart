import '../../core/models/application_model.dart';

abstract class ApplicationRepository {
  Future<List<ApplicationModel>> getApplications();


  Future<ApplicationModel> createApplication(String type, String description);

  Future<ApplicationModel> updateApplication(
    String id,
    String type,
    String description,
  );

  Future<void> deleteApplication(String id);

  Future<ApplicationModel> sendApplication(String id);
}

