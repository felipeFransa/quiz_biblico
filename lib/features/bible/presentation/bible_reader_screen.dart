import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/app_providers.dart';

class BibleReaderScreen extends ConsumerStatefulWidget {
  const BibleReaderScreen({super.key});

  @override
  ConsumerState<BibleReaderScreen> createState() => _BibleReaderScreenState();
}

class _BibleReaderScreenState extends ConsumerState<BibleReaderScreen> {
  Map<String, String>? _selectedBook;
  int? _selectedChapter;
  List<Map<String, String>> _books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final books = await ref.read(databaseServiceProvider).getBibleBooks();
    setState(() {
      _books = books;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_selectedBook == null) {
      return _buildBookList();
    }

    if (_selectedChapter == null) {
      return _buildChapterGrid();
    }

    return _buildVerseList();
  }

  Widget _buildBookList() {
    return Scaffold(
      appBar: AppBar(title: const Text('Bíblia Sagrada')),
      body: ListView.separated(
        itemCount: _books.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final book = _books[index];
          return ListTile(
            title: Text(book['name']!, style: const TextStyle(fontWeight: FontWeight.w500)),
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () => setState(() => _selectedBook = book),
          );
        },
      ),
    );
  }

  Widget _buildChapterGrid() {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedBook!['name']!),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _selectedBook = null),
        ),
      ),
      body: FutureBuilder<int>(
        future: ref.read(databaseServiceProvider).getChapterCount(_selectedBook!['abbrev']!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: snapshot.data,
            itemBuilder: (context, index) {
              final chapter = index + 1;
              return InkWell(
                onTap: () => setState(() => _selectedChapter = chapter),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text('$chapter', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildVerseList() {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_selectedBook!['name']} $_selectedChapter'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _selectedChapter = null),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ref.read(databaseServiceProvider).getVersesByChapter(
          _selectedBook!['abbrev']!, 
          _selectedChapter!
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final verses = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: verses.length,
            itemBuilder: (context, index) {
              final verse = verses[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
                    children: [
                      TextSpan(
                        text: '${verse['verse']} ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(text: verse['text']),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
