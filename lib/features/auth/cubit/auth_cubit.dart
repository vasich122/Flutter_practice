import 'package:flutter_bloc/flutter_bloc.dart';

class AuthState {
  final bool isAuthorized;
  final String? login;

  const AuthState({this.isAuthorized = false, this.login});

  AuthState copyWith({bool? isAuthorized, String? login}) {
    return AuthState(
      isAuthorized: isAuthorized ?? this.isAuthorized,
      login: login ?? this.login,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  void login(String login) {
    emit(state.copyWith(isAuthorized: true, login: login));
  }

  void logout() {
    emit(const AuthState());
  }
}