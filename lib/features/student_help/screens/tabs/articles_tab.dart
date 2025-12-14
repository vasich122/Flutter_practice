import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../cubit/student_help_cubit.dart';
import '../../../../core/models/article_model.dart';

class ArticlesTab extends StatefulWidget {
  const ArticlesTab({super.key});

  @override
  State<ArticlesTab> createState() => _ArticlesTabState();
}

class _ArticlesTabState extends State<ArticlesTab> {
  final _searchController = TextEditingController();
  final _authorController = TextEditingController();
  final _doiController = TextEditingController();
  final _yearController = TextEditingController();
  int _selectedFilter = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _authorController.dispose();
    _doiController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _openPdf(String? url) async {
    if (url == null) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
                  label: 'По DOI',
                  isSelected: _selectedFilter == 2,
                  onSelected: () => setState(() => _selectedFilter = 2),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'По году',
                  isSelected: _selectedFilter == 3,
                  onSelected: () => setState(() => _selectedFilter = 3),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Топ цитирований',
                  isSelected: _selectedFilter == 4,
                  onSelected: () => setState(() => _selectedFilter = 4),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildSearchField(cubit),
        ),
        Expanded(
          child: BlocBuilder<StudentHelpCubit, StudentHelpState>(
            builder: (context, state) {
              if (state.isLoadingArticles) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.errorArticles != null) {
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
                        'Ошибка: ${state.errorArticles}',
                        style: TextStyle(color: colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => cubit.loadRecentArticles(),
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                );
              }

              if (state.articles.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 64,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Статьи не найдены',
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
                itemCount: state.articles.length,
                itemBuilder: (context, index) {
                  final article = state.articles[index];
                  return _ArticleCard(
                    article: article,
                    onPdfTap: () => _openPdf(article.pdfUrl),
                    onTap: () async {
                      final detailedArticle = await cubit.getArticleById(article.id);
                      if (detailedArticle != null && context.mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => _ArticleDetailScreen(article: detailedArticle),
                          ),
                        );
                      }
                    },
                  );
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
            hintText: 'Поиск научных статей...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                cubit.loadRecentArticles();
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSubmitted: (query) {
            if (query.trim().isNotEmpty) {
              cubit.searchArticles(query);
            }
          },
        );
      case 1:
        return TextField(
          controller: _authorController,
          decoration: InputDecoration(
            hintText: 'Введите ID автора OpenAlex (например: A2208157607)...',
            helperText: 'ID можно найти на openalex.org',
            prefixIcon: const Icon(Icons.person),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                if (_authorController.text.trim().isNotEmpty) {
                  cubit.searchArticlesByAuthor(_authorController.text.trim());
                }
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSubmitted: (query) {
            if (query.trim().isNotEmpty) {
              cubit.searchArticlesByAuthor(query.trim());
            }
          },
        );
      case 2:
        return TextField(
          controller: _doiController,
          decoration: InputDecoration(
            hintText: 'Введите DOI (например: 10.1038/nature12373)...',
            prefixIcon: const Icon(Icons.qr_code),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                if (_doiController.text.trim().isNotEmpty) {
                  cubit.searchArticleByDoi(_doiController.text.trim());
                }
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSubmitted: (query) {
            if (query.trim().isNotEmpty) {
              cubit.searchArticleByDoi(query.trim());
            }
          },
        );
      case 3:
        return TextField(
          controller: _yearController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Введите год (например: 2023)...',
            prefixIcon: const Icon(Icons.calendar_today),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                final year = int.tryParse(_yearController.text.trim());
                if (year != null) {
                  cubit.searchArticlesByYear(year);
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
              cubit.searchArticlesByYear(year);
            }
          },
        );
      case 4:
        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  cubit.loadMostCitedArticles();
                },
                icon: const Icon(Icons.trending_up),
                label: const Text('Загрузить топ статей'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
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

class _ArticleCard extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onPdfTap;
  final VoidCallback onTap;

  const _ArticleCard({
    required this.article,
    required this.onPdfTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (article.pdfUrl != null)
                  IconButton(
                    icon: const Icon(Icons.picture_as_pdf),
                    color: colorScheme.error,
                    onPressed: onPdfTap,
                    tooltip: 'Открыть PDF',
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (article.authors.isNotEmpty)
              Text(
                article.authors.join(', '),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            if (article.publishedDate != null) ...[
              const SizedBox(height: 4),
              Text(
                'Опубликовано: ${_formatDate(article.publishedDate!)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
              ),
            ],
            if (article.abstract != null) ...[
              const SizedBox(height: 12),
              Text(
                article.abstract!,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (article.categories != null && article.categories!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: article.categories!.take(3).map((category) {
                  return Chip(
                    label: Text(
                      category,
                      style: const TextStyle(fontSize: 11),
                    ),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}

class _ArticleDetailScreen extends StatelessWidget {
  final ArticleModel article;

  const _ArticleDetailScreen({required this.article});

  Future<void> _openPdf(BuildContext context, String? url) async {
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF недоступен')),
      );
      return;
    }
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось открыть PDF')),
        );
      }
    }
  }

  Future<void> _openDoi(BuildContext context, String? doi) async {
    if (doi == null) return;
    final url = doi.startsWith('http') ? doi : 'https://doi.org/$doi';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось открыть DOI')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали статьи'),
        actions: [
          if (article.pdfUrl != null)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: () => _openPdf(context, article.pdfUrl),
              tooltip: 'Открыть PDF',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            if (article.authors.isNotEmpty) ...[
              Text(
                'Авторы',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              ...article.authors.map((author) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            author,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
            ],
            if (article.publishedDate != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Опубликовано: ${_formatDate(article.publishedDate!)}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            if (article.doi != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.link,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () => _openDoi(context, article.doi),
                      child: Text(
                        'DOI: ${article.doi}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            if (article.categories != null && article.categories!.isNotEmpty) ...[
              Text(
                'Категории',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: article.categories!.map((category) {
                  return Chip(
                    label: Text(category),
                    labelStyle: const TextStyle(fontSize: 12),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
            if (article.abstract != null) ...[
              Text(
                'Аннотация',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                article.abstract!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
            if (article.pdfUrl != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _openPdf(context, article.pdfUrl),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Открыть PDF'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}

