import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('Создан компонент состояния: ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('Изменение состояния в ${bloc.runtimeType}: ${change.currentState} → ${change.nextState}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('Ошибка в компоненте состояния ${bloc.runtimeType}: $error');
    super.onError(bloc, error, stackTrace);
  }
}