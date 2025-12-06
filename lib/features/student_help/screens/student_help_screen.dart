import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/student_help_cubit.dart';
import 'tabs/books_tab.dart';
import 'tabs/tests_tab.dart';
import 'tabs/articles_tab.dart';

class StudentHelpScreen extends StatelessWidget {
  const StudentHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentHelpCubit(),
      child: const _StudentHelpScreenContent(),
    );
  }
}

class _StudentHelpScreenContent extends StatelessWidget {
  const _StudentHelpScreenContent();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Помощь студенту'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          bottom: TabBar(
            tabs: const [
              Tab(icon: Icon(Icons.library_books), text: 'Библиотека'),
              Tab(icon: Icon(Icons.quiz), text: 'Тесты'),
              Tab(icon: Icon(Icons.article), text: 'Статьи'),
            ],
            labelColor: colorScheme.primary,
            unselectedLabelColor: Colors.grey.shade600,
            indicatorColor: colorScheme.secondary,
            indicatorWeight: 3,
          ),
        ),
        body: const TabBarView(
          children: [
            BooksTab(),
            TestsTab(),
            ArticlesTab(),
          ],
        ),
      ),
    );
  }
}

