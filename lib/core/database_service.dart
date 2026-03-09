import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import '../shared/models/question.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'quiz_biblico.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY,
        text TEXT NOT NULL,
        correct_answer TEXT NOT NULL,
        options TEXT NOT NULL,
        category TEXT NOT NULL,
        difficulty TEXT NOT NULL DEFAULT 'easy',
        reference TEXT,
        explanation TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE bible_verses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        book_abbrev TEXT NOT NULL,
        chapter INTEGER NOT NULL,
        verse INTEGER NOT NULL,
        text TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE quiz_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        completed_at INTEGER NOT NULL,
        score INTEGER NOT NULL,
        total INTEGER NOT NULL,
        category TEXT NOT NULL
      )
    ''');

    await _preloadQuestions(db);
    await _preloadBible(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Forçar recarregamento de perguntas se for uma versão antiga
      await db.delete('questions');
      await _preloadQuestions(db);
    }
  }

  Future<void> _preloadQuestions(Database db) async {
    try {
      final String response = await rootBundle.loadString('assets/questions.json');
      final List<dynamic> data = json.decode(response);
      
      for (var item in data) {
        final question = Question.fromMap(item);
        await db.insert('questions', question.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
    } catch (e) {
      debugPrint('Error preloading questions: $e');
    }
  }

  Future<void> _preloadBible(Database db) async {
    try {
      final String response = await rootBundle.loadString('assets/data/bible_acf.json');
      final List<dynamic> data = json.decode(response);
      
      await db.transaction((txn) async {
        for (var bookData in data) {
          String abbrev = bookData['abbrev'];
          List<dynamic> chapters = bookData['chapters'];
          
          for (int c = 0; c < chapters.length; c++) {
            List<dynamic> verses = chapters[c];
            for (int v = 0; v < verses.length; v++) {
              await txn.insert('bible_verses', {
                'book_abbrev': abbrev,
                'chapter': c + 1,
                'verse': v + 1,
                'text': verses[v],
              }, conflictAlgorithm: ConflictAlgorithm.replace);
            }
          }
        }
      });
      debugPrint('Bible preloaded successfully!');
    } catch (e) {
      debugPrint('Error preloading bible: $e');
    }
  }

  Future<List<Question>> getQuestionsByCategory(String category, {int limit = 5}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'questions',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'RANDOM()',
      limit: limit,
    );
    return List.generate(maps.length, (i) => Question.fromMap(maps[i]));
  }

  Future<bool> syncFromApi(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final db = await database;
        
        await db.transaction((txn) async {
          for (var item in data) {
            final question = Question.fromMap(item);
            await txn.insert('questions', question.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
          }
        });
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error syncing from API: $e');
      return false;
    }
  }

  Future<bool> syncFullBible() async {
    const url = 'https://raw.githubusercontent.com/thiagobodruk/bible/master/json/pt_acf.json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final db = await database;

        await db.transaction((txn) async {
          // Limpar dados anteriores para evitar duplicação ou inconsistência
          await txn.delete('bible_verses');
          
          for (var bookData in data) {
            String abbrev = bookData['abbrev'];
            List<dynamic> chapters = bookData['chapters'];
            
            for (int c = 0; c < chapters.length; c++) {
              List<dynamic> verses = chapters[c];
              for (int v = 0; v < verses.length; v++) {
                await txn.insert('bible_verses', {
                  'book_abbrev': abbrev,
                  'chapter': c + 1,
                  'verse': v + 1,
                  'text': verses[v],
                });
              }
            }
          }
        });
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error syncing full bible: $e');
      return false;
    }
  }

  Future<String?> getLocalVerse(String reference) async {
    final bookMap = {
      'gênesis': 'gn', 'êxodo': 'ex', 'levítico': 'lv', 'números': 'nm', 'deuteronômio': 'dt',
      'josué': 'js', 'juízes': 'jz', 'rute': 'rt', '1 samuel': '1sm', '2 samuel': '2sm',
      '1 reis': '1re', '2 reis': '2re', '1 crônicas': '1cr', '2 crônicas': '2cr', 'esdras': 'er',
      'neemias': 'ne', 'ester': 'et', 'jó': 'jó', 'salmos': 'sl', 'provérbios': 'pv',
      'eclesiastes': 'ec', 'cantares': 'ct', 'isaías': 'is', 'jeremias': 'jr', 'lamentações': 'lm',
      'ezequiel': 'ez', 'daniel': 'dn', 'oséias': 'os', 'joel': 'jl', 'amós': 'am',
      'obadias': 'ob', 'jonas': 'jn', 'miquéias': 'mq', 'naum': 'na', 'habacuque': 'hc',
      'sofonias': 'sf', 'ageu': 'ag', 'zacarias': 'zc', 'malaquias': 'ml',
      'mateus': 'mt', 'marcos': 'mc', 'lucas': 'lc', 'joão': 'jo', 'atos': 'at',
      'romanos': 'rm', '1 coríntios': '1co', '2 coríntios': '2co', 'gálatas': 'gl', 'efésios': 'ef',
      'filipenses': 'fp', 'colossenses': 'cl', '1 tessalonicenses': '1ts', '2 tessalonicenses': '2ts',
      '1 timóteo': '1tm', '2 timóteo': '2tm', 'tito': 'tt', 'filemon': 'fm', 'hebreus': 'hb',
      'tiago': 'tg', '1 pedro': '1pe', '2 pedro': '2pe', '1 joão': '1jo', '2 joão': '2jo',
      '3 joão': '3jo', 'judas': 'jd', 'apocalipse': 'ap'
    };

    try {
      final db = await database;
      // Regex para extrair Livro, Capítulo e Versículo
      final match = RegExp(r'^(.+?)\s+(\d+)[:\s]+(\d+)$').firstMatch(reference);
      if (match != null) {
        String bookName = match.group(1)!.toLowerCase().trim();
        int chapter = int.parse(match.group(2)!);
        int verse = int.parse(match.group(3)!);

        String? abbrev = bookMap[bookName];
        abbrev ??= bookMap.entries
            .where((e) => bookName.startsWith(e.key) || e.key.startsWith(bookName))
            .map((e) => e.value)
            .firstOrNull;

        if (abbrev != null) {
          final List<Map<String, dynamic>> maps = await db.query(
            'bible_verses',
            where: 'book_abbrev = ? AND chapter = ? AND verse = ?',
            whereArgs: [abbrev, chapter, verse],
          );

          if (maps.isNotEmpty) {
            return maps.first['text'] as String;
          }
        }
      }
    } catch (e) {
      debugPrint('Error getting local verse: $e');
    }
    return null;
  }

  Future<List<Map<String, String>>> getBibleBooks() async {
    final books = [
      {'abbrev': 'gn', 'name': 'Gênesis'}, {'abbrev': 'ex', 'name': 'Êxodo'}, {'abbrev': 'lv', 'name': 'Levítico'},
      {'abbrev': 'nm', 'name': 'Números'}, {'abbrev': 'dt', 'name': 'Deuteronômio'}, {'abbrev': 'js', 'name': 'Josué'},
      {'abbrev': 'jz', 'name': 'Juízes'}, {'abbrev': 'rt', 'name': 'Rute'}, {'abbrev': '1sm', 'name': '1 Samuel'},
      {'abbrev': '2sm', 'name': '2 Samuel'}, {'abbrev': '1re', 'name': '1 Reis'}, {'abbrev': '2re', 'name': '2 Reis'},
      {'abbrev': '1cr', 'name': '1 Crônicas'}, {'abbrev': '2cr', 'name': '2 Crônicas'}, {'abbrev': 'er', 'name': 'Esdras'},
      {'abbrev': 'ne', 'name': 'Neemias'}, {'abbrev': 'et', 'name': 'Ester'}, {'abbrev': 'jó', 'name': 'Jó'},
      {'abbrev': 'sl', 'name': 'Salmos'}, {'abbrev': 'pv', 'name': 'Provérbios'}, {'abbrev': 'ec', 'name': 'Eclesiastes'},
      {'abbrev': 'ct', 'name': 'Cantares'}, {'abbrev': 'is', 'name': 'Isaías'}, {'abbrev': 'jr', 'name': 'Jeremias'},
      {'abbrev': 'lm', 'name': 'Lamentações'}, {'abbrev': 'ez', 'name': 'Ezequiel'}, {'abbrev': 'dn', 'name': 'Daniel'},
      {'abbrev': 'os', 'name': 'Oséias'}, {'abbrev': 'jl', 'name': 'Joel'}, {'abbrev': 'am', 'name': 'Amós'},
      {'abbrev': 'ob', 'name': 'Obadias'}, {'abbrev': 'jn', 'name': 'Jonas'}, {'abbrev': 'mq', 'name': 'Miquéias'},
      {'abbrev': 'na', 'name': 'Naum'}, {'abbrev': 'hc', 'name': 'Habacuque'}, {'abbrev': 'sf', 'name': 'Sofonias'},
      {'abbrev': 'ag', 'name': 'Ageu'}, {'abbrev': 'zc', 'name': 'Zacarias'}, {'abbrev': 'ml', 'name': 'Malaquias'},
      {'abbrev': 'mt', 'name': 'Mateus'}, {'abbrev': 'mc', 'name': 'Marcos'}, {'abbrev': 'lc', 'name': 'Lucas'},
      {'abbrev': 'jo', 'name': 'João'}, {'abbrev': 'at', 'name': 'Atos'}, {'abbrev': 'rm', 'name': 'Romanos'},
      {'abbrev': '1co', 'name': '1 Coríntios'}, {'abbrev': '2co', 'name': '2 Coríntios'}, {'abbrev': 'gl', 'name': 'Gálatas'},
      {'abbrev': 'ef', 'name': 'Efésios'}, {'abbrev': 'fp', 'name': 'Filipenses'}, {'abbrev': 'cl', 'name': 'Colossenses'},
      {'abbrev': '1ts', 'name': '1 Tessalonicenses'}, {'abbrev': '2ts', 'name': '2 Tessalonicenses'},
      {'abbrev': '1tm', 'name': '1 Timóteo'}, {'abbrev': '2tm', 'name': '2 Timóteo'}, {'abbrev': 'tt', 'name': 'Tito'},
      {'abbrev': 'fm', 'name': 'Filemon'}, {'abbrev': 'hb', 'name': 'Hebreus'}, {'abbrev': 'tg', 'name': 'Tiago'},
      {'abbrev': '1pe', 'name': '1 Pedro'}, {'abbrev': '2pe', 'name': '2 Pedro'}, {'abbrev': '1jo', 'name': '1 João'},
      {'abbrev': '2jo', 'name': '2 João'}, {'abbrev': '3jo', 'name': '3 João'}, {'abbrev': 'jd', 'name': 'Judas'},
      {'abbrev': 'ap', 'name': 'Apocalipse'}
    ];
    return books;
  }

  Future<int> getChapterCount(String abbrev) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT MAX(chapter) as count FROM bible_verses WHERE book_abbrev = ?',
      [abbrev],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Map<String, dynamic>>> getVersesByChapter(String abbrev, int chapter) async {
    final db = await database;
    return await db.query(
      'bible_verses',
      where: 'book_abbrev = ? AND chapter = ?',
      whereArgs: [abbrev, chapter],
      orderBy: 'verse ASC',
    );
  }

  Future<List<String>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT DISTINCT category FROM questions');
    return result.map((row) => row['category'] as String).toList();
  }

  Future<Map<String, dynamic>> getRandomVerse() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT text, book_abbrev, chapter, verse
      FROM bible_verses
      ORDER BY RANDOM() LIMIT 1
    ''');
    
    if (result.isNotEmpty) {
      final row = result.first;
      return {
        'text': row['text'],
        'book': getBookName(row['book_abbrev']),
        'chapter': row['chapter'],
        'verse': row['verse'],
      };
    }
    
    // Fallback caso não encontre (o que é raro se houver dados)
    return {
      'text': 'Tudo posso naquele que me fortalece.',
      'book': 'Filipenses',
      'chapter': 4,
      'verse': 13
    };
  }

  // Helper para buscar o nome do livro pela abreviação (caso não exista tabela de livros)
  String getBookName(String abbrev) {
    final books = {
      'gn': 'Gênesis', 'ex': 'Êxodo', 'lv': 'Levítico', 'nm': 'Números', 'dt': 'Deuteronômio',
      'js': 'Josué', 'jz': 'Juízes', 'rt': 'Rute', '1sm': '1 Samuel', '2sm': '2 Samuel',
      '1re': '1 Reis', '2re': '2 Reis', '1cr': '1 Crônicas', '2cr': '2 Crônicas', 'er': 'Esdras',
      'ne': 'Neemias', 'et': 'Ester', 'jó': 'Jó', 'sl': 'Salmos', 'pv': 'Provérbios',
      'ec': 'Eclesiastes', 'ct': 'Cantares', 'is': 'Isaías', 'jr': 'Jeremias', 'lm': 'Lamentações',
      'ez': 'Ezequiel', 'dn': 'Daniel', 'os': 'Oséias', 'jl': 'Joel', 'am': 'Amós',
      'ob': 'Obadias', 'jn': 'Jonas', 'mq': 'Miquéias', 'na': 'Naum', 'hc': 'Habacuque',
      'sf': 'Sofonias', 'ag': 'Ageu', 'zacarias': 'zc', 'ml': 'Malaquias',
      'mt': 'Mateus', 'mc': 'Marcos', 'lc': 'Lucas', 'jo': 'Joao', 'at': 'Atos',
      'rm': 'Romanos', '1co': '1 Corintios', '2co': '2 Corintios', 'gl': 'Gálatas', 'ef': 'Efésios',
      'fp': 'Filipenses', 'cl': 'Colossenses', '1ts': '1 Tessalonicenses', '2ts': '2 Tessalonicenses',
      '1tm': '1 Timóteo', '2tm': '2 Timóteo', 'tt': 'Tito', 'fm': 'Filemom', 'hb': 'Hebreus',
      'tg': 'Tiago', '1pe': '1 Pedro', '2pe': '2 Pedro', '1jo': '1 Joao', '2jo': '2 Joao',
      '3jo': '3 Joao', 'jd': 'Judas', 'ap': 'Apocalipse'
    };
    return books[abbrev] ?? abbrev;
  }
}
