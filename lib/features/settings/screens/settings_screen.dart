import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/theme_cubit.dart';
import '../../../shared/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                child: ListTile(
                  leading: const Icon(Icons.palette),
                  title: const Text('Тема приложения'),
                  subtitle: Text(_getThemeModeText(state.themeMode)),
                  trailing: PopupMenuButton<AppThemeMode>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (AppThemeMode mode) {
                      context.read<ThemeCubit>().setTheme(mode);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: AppThemeMode.light,
                        child: Text('Светлая'),
                      ),
                      const PopupMenuItem(
                        value: AppThemeMode.dark,
                        child: Text('Темная'),
                      ),
                      const PopupMenuItem(
                        value: AppThemeMode.system,
                        child: Text('Системная'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getThemeModeText(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Светлая';
      case AppThemeMode.dark:
        return 'Темная';
      case AppThemeMode.system:
        return 'Системная';
    }
  }
}

