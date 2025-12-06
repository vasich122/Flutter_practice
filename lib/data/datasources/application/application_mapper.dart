import '../../../core/models/application_model.dart';
import 'application_dto.dart';

extension ApplicationMapper on ApplicationDto {
  ApplicationModel toModel() {
    return ApplicationModel(
      id: id,
      type: type,
      description: description,
      status: status,
      date: date,
      editable: editable,
    );
  }
}

