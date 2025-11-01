import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

class AppStateService {
  int attendance = 92;

  void setAttendance(int newAttendance) { attendance = newAttendance; }
}

void setupLocator() {
  locator.registerSingleton<AppStateService>(AppStateService());
}
void main(List<String> args){
  GetIt.I.registerFactory(()=> MyClass(), instanceName: 'my_class');
}
