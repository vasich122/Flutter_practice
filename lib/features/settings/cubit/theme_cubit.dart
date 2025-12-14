import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/datasources/core/preferences_helper.dart';
import '../../../shared/app_theme.dart';

class ThemeState extends Equatable {
  final AppThemeMode themeMode;

  const ThemeState({required this.themeMode});

  @override
  List<Object> get props => [themeMode];
}

class ThemeCubit extends Cubit<ThemeState> {
  final PreferencesHelper _prefsHelper = PreferencesHelper.instance;

  ThemeCubit() : super(const ThemeState(themeMode: AppThemeMode.light)) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final themeString = await _prefsHelper.getAppTheme();
      final themeMode = AppTheme.themeModeFromString(themeString);
      emit(ThemeState(themeMode: themeMode));
    } catch (e) {
      emit(const ThemeState(themeMode: AppThemeMode.light));
    }
  }

  Future<void> setTheme(AppThemeMode themeMode) async {
    try {
      await _prefsHelper.saveAppTheme(AppTheme.themeModeToString(themeMode));
      emit(ThemeState(themeMode: themeMode));
    } catch (e) {
      emit(ThemeState(themeMode: themeMode));
    }
  }
}

