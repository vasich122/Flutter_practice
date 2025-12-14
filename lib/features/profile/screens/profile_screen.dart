import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../cubit/profile_cubit.dart';
import '../../auth/cubit/auth_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditDialog(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final profileCubit = context.read<ProfileCubit>();

    final loginController = TextEditingController(text: authCubit.state.login);
    final passwordController = TextEditingController();
    String status = profileCubit.state.status;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Редактировать профиль'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: loginController,
                decoration: const InputDecoration(
                  labelText: 'Логин',
                  helperText: 'Введите новый логин, если хотите изменить',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                  helperText: 'Введите новый пароль',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: status,
                items: const [
                  DropdownMenuItem(value: 'онлайн', child: Text('Онлайн')),
                  DropdownMenuItem(value: 'невидимка', child: Text('Невидимка')),
                ],
                onChanged: (value) {
                  if (value != null) status = value;
                },
                decoration: const InputDecoration(labelText: 'Статус'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final login = loginController.text.trim();
                final password = passwordController.text.trim();

                if (login.isEmpty) return;

                authCubit.login(login);

                if (password.isNotEmpty) {
                }

                profileCubit.updateStatus(status);

                Navigator.of(dialogContext).pop();
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CachedNetworkImage(
                  imageUrl: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                  width: 100,
                  height: 100,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: 16),

                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, profileState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ФИО: Соваренко Василий Васильевич',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text('Группа: ИКБО-06-22',
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 8),
                        Text('Курс: ${profileState.course}',
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                    return Text('Логин: ${authState.login}',
                        style: Theme.of(context).textTheme.bodyLarge);
                  },
                ),
                const SizedBox(height: 8),
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, profileState) {
                    return Text('Статус: ${profileState.status}',
                        style: Theme.of(context).textTheme.bodyLarge);
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _showEditDialog(context),
                  icon: const Icon(Icons.edit),
                  label: const Text('Редактировать профиль'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    minimumSize: const Size(0, 0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}