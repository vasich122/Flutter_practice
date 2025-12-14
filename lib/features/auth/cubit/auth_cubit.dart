import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../data/datasources/core/preferences_helper.dart';
import '../../../data/datasources/core/secure_storage_helper.dart';

class AuthState {
  final bool isAuthorized;
  final String? login;
  final bool isLoading;

  const AuthState({
    this.isAuthorized = false,
    this.login,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isAuthorized,
    String? login,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthorized: isAuthorized ?? this.isAuthorized,
      login: login ?? this.login,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  final PreferencesHelper _prefsHelper = PreferencesHelper.instance;
  final SecureStorageHelper _secureStorage = SecureStorageHelper.instance;
  final _uuid = const Uuid();

  AuthCubit() : super(const AuthState(isLoading: true)) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      String? authToken;
      try {
        authToken = await _secureStorage.getAuthToken();
      } catch (e) {
        debugPrint('Не удалось получить токен из SecureStorage: $e');
      }

      if (authToken != null && authToken.isNotEmpty) {
        final login = await _prefsHelper.getUserLogin();

        if (login != null && login.isNotEmpty) {
          await _prefsHelper.saveIsAuthorized(true);
          emit(AuthState(isAuthorized: true, login: login, isLoading: false));
          return;
        }
      }

      final isAuthorized = await _prefsHelper.getIsAuthorized();
      final login = await _prefsHelper.getUserLogin();

      if (isAuthorized && login != null && login.isNotEmpty) {

        final token = _generateToken(login);
        try {
          await _secureStorage.saveAuthToken(token);
        } catch (e) {
          debugPrint('Не удалось сохранить токен: $e');
        }
        emit(AuthState(isAuthorized: true, login: login, isLoading: false));
      } else {
        emit(const AuthState(isLoading: false));
      }
    } catch (e) {
      emit(const AuthState(isLoading: false));
    }
  }

  /// Генерирует уникальный токен для пользователя
  String _generateToken(String login) {
    return _uuid.v4(); // Используем UUID для уникальности
  }

  Future<void> login(String login) async {
    try {
      // Генерируем и сохраняем токен авторизации
      final token = _generateToken(login);
      
      try {
        await _secureStorage.saveAuthToken(token);
      } catch (e) {
        debugPrint('Не удалось сохранить токен в SecureStorage: $e');
      }
      
      // Сохраняем логин в SharedPreferences
      await _prefsHelper.saveUserLogin(login);
      await _prefsHelper.saveIsAuthorized(true);
      
      emit(state.copyWith(isAuthorized: true, login: login));
    } catch (e) {
      // В случае ошибки все равно устанавливаем авторизацию
      emit(state.copyWith(isAuthorized: true, login: login));
    }
  }

  Future<void> logout() async {
    try {
      // Удаляем токен авторизации
      try {
        await _secureStorage.deleteAuthToken();
      } catch (e) {
        debugPrint('Не удалось удалить токен из SecureStorage: $e');
      }
      
      // Удаляем флаг авторизации и логин из SharedPreferences
      await _prefsHelper.saveIsAuthorized(false);
      await _prefsHelper.saveUserLogin('');
      
      emit(const AuthState());
    } catch (e) {
      // В случае ошибки все равно сбрасываем состояние
      emit(const AuthState());
    }
  }
}