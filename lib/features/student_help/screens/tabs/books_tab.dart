import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../cubit/student_help_cubit.dart';
import '../../../../core/models/book_model.dart';

class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab> {
  final _searchController = TextEditingController();
  final _authorController = TextEditingController();
  final _subjectController = TextEditingController();
  final _yearController = TextEditingController();
  int _selectedFilter = 0; // 0: общий поиск, 1: по автору, 2: по предмету, 3: по году

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    _searchController.dispose();
    _authorController.dispose();
    _subjectController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StudentHelpCubit>();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'Общий',
                  isSelected: _selectedFilter == 0,
                  onSelected: () => setState(() => _selectedFilter = 0),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'По автору',
                  isSelected: _selectedFilter == 1,
                  onSelected: () => setState(() => _selectedFilter = 1),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'По предмету',
                  isSelected: _selectedFilter == 2,
                  onSelected: () => setState(() => _selectedFilter = 2),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'По году',
                  isSelected: _selectedFilter == 3,
                  onSelected: () => setState(() => _selectedFilter = 3),
                ),
              ],
            ),
          ),
        ),
        // Поле поиска в зависимости от выбранного фильтра
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildSearchField(cubit),
        ),
        Expanded(
          child: BlocBuilder<StudentHelpCubit, StudentHelpState>(
            builder: (context, state) {
              if (state.isLoadingBooks) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.errorBooks != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ошибка: ${state.errorBooks}',
                        style: TextStyle(color: colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => cubit.loadPopularBooks(),
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                );
              }

              if (state.books.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.library_books_outlined,
                        size: 64,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Книги не найдены',
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.books.length,
                itemBuilder: (context, index) {
                  final book = state.books[index];
                  return _BookCard(book: book);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField(StudentHelpCubit cubit) {
    switch (_selectedFilter) {
      case 0:
        return TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Поиск книг...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                cubit.loadPopularBooks();
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSubmitted: (query) {
            if (query.trim().isNotEmpty) {
              cubit.searchBooks(query);
            }
          },
        );
      case 1:
        return TextField(
          controller: _authorController,
          decoration: InputDecoration(
            hintText: 'Введите имя автора...',
            prefixIcon: const Icon(Icons.person),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                if (_authorController.text.trim().isNotEmpty) {
                  cubit.searchBooksByAuthor(_authorController.text.trim());
                }
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSubmitted: (query) {
            if (query.trim().isNotEmpty) {
              cubit.searchBooksByAuthor(query.trim());
            }
          },
        );
      case 2:
        return TextField(
          controller: _subjectController,
          decoration: InputDecoration(
            hintText: 'Введите предмет (например: mathematics)...',
            prefixIcon: const Icon(Icons.category),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                if (_subjectController.text.trim().isNotEmpty) {
                  cubit.searchBooksBySubject(_subjectController.text.trim());
                }
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSubmitted: (query) {
            if (query.trim().isNotEmpty) {
              cubit.searchBooksBySubject(query.trim());
            }
          },
        );
      case 3:
        return TextField(
          controller: _yearController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Введите год (например: 2020)...',
            prefixIcon: const Icon(Icons.calendar_today),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                final year = int.tryParse(_yearController.text.trim());
                if (year != null) {
                  cubit.searchBooksByYear(year);
                }
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSubmitted: (query) {
            final year = int.tryParse(query.trim());
            if (year != null) {
              cubit.searchBooksByYear(year);
            }
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _BookCard extends StatelessWidget {
  final BookModel book;

  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () async {
          // Открываем детальную информацию о книге
          final cubit = context.read<StudentHelpCubit>();
          final detailedBook = await cubit.getBookByKey(book.id);
          if (detailedBook != null && context.mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => _BookDetailScreen(book: detailedBook),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (book.coverUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: book.coverUrl!,
                    width: 80,
                    height: 120,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 80,
                      height: 120,
                      color: colorScheme.surfaceContainerHighest,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 80,
                      height: 120,
                      color: colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.book_outlined,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: 80,
                  height: 120,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.book_outlined,
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.authors.join(', '),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (book.publishYear != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${book.publishYear}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                      ),
                    ],
                    if (book.description != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        book.description!,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
    );
  }
}

class _BookDetailScreen extends StatelessWidget {
  final BookModel book;

  const _BookDetailScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали книги'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book.coverUrl != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: book.coverUrl!,
                    width: 200,
                    height: 300,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 200,
                      height: 300,
                      color: colorScheme.surfaceContainerHighest,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 200,
                      height: 300,
                      color: colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.book_outlined,
                        size: 64,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              )
            else
              Center(
                child: Container(
                  width: 200,
                  height: 300,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.book_outlined,
                    size: 64,
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Text(
              book.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Авторы: ${book.authors.join(', ')}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
            ),
            if (book.publishYear != null) ...[
              const SizedBox(height: 8),
              Text(
                'Год публикации: ${book.publishYear}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
            if (book.subjects != null && book.subjects!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: book.subjects!.map((subject) {
                  return Chip(
                    label: Text(subject),
                    labelStyle: const TextStyle(fontSize: 12),
                  );
                }).toList(),
              ),
            ],
            if (book.description != null) ...[
              const SizedBox(height: 24),
              Text(
                'Описание',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                book.description!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

