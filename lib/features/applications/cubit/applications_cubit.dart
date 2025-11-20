import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pr1/features/applications/model/application_model.dart';
import 'package:uuid/uuid.dart';

class ApplicationCubit extends Cubit<List<ApplicationModel>> {
  ApplicationCubit() : super([]);

  final _uuid = const Uuid();

  void addApplication(String type, String description) {
    final newApp = ApplicationModel(
      id: _uuid.v4(),
      type: type,
      description: description,
      status: 'Создано',
      date: DateTime.now(),
    );
    emit([...state, newApp]);
  }

  void updateApplication(String id, String type, String description) {
    emit(state.map((app) {
      if (app.id == id && app.editable) {
        return app.copyWith(type: type, description: description);
      }
      return app;
    }).toList());
  }

  void deleteApplication(String id) {
    emit(state.where((app) => app.id != id).toList());
  }

  void sendApplication(String id) {
    emit(state.map((app) {
      if (app.id == id && app.editable) {
        return app.copyWith(status: 'Отправлено', editable: false);
      }
      return app;
    }).toList());
  }
}