import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:poetry_app/models/poem/poem.dart';
import 'package:poetry_app/services/poem_repository.dart';
import 'package:poetry_app/services/interfaces/isar_provider_interface.dart';

class FakeIsarProvider extends Fake implements IsarProviderI {
  static Isar? _db;
  @override
  Future<Isar> open() async {
    final String dbPath = Directory(r'test\isar').absolute.path;
    if (_db == null || !_db!.isOpen) {
      _db = await Isar.open([PoemSchema], directory: dbPath);
    }
    return _db!;
  }
}

void main() {
  final getIt = GetIt.I;

  group('Poem repository tests:', () {
    setUpAll(() async {
      await getIt.reset();
      await Isar.initializeIsarCore(download: true);
      getIt.registerSingleton<IsarProviderI>(FakeIsarProvider());
    });

    setUp(() async {
      // for each test delete database
      Isar db = await getIt.get<IsarProviderI>().open();
      await db.close(deleteFromDisk: true);
    });

    test('getting poems from DB', () async {
      // put some poems in DB
      List<Poem> poems = [
        Poem(title: 'title1', author: 'author1', poem: 'poem1\npoem1\npoem1'),
        Poem(title: 'title2', author: 'author2', poem: 'poem2')
      ];

      Isar db = await getIt.get<IsarProviderI>().open();
      await db.writeTxn(() => db.poems.putAll(poems));

      PoemRepository poemRepository =
          PoemRepository(getIt.get<IsarProviderI>());

      // get poems from DB
      List<Poem> dbPoems = await poemRepository.getAll();
      expect(dbPoems.length, equals(2));
      expect(true, mapEquals(poems[0].toMap(), dbPoems[0].toMap()));
      expect(true, mapEquals(poems[1].toMap(), dbPoems[1].toMap()));
      expect(dbPoems[0].poem.contains(RegExp(r'\\n')), isFalse);
      expect(dbPoems[0].poem.split('\n').length, equals(3));
    });

    test('populate DB with a poem list', () async {
      PoemRepository poemRepository =
          PoemRepository(getIt.get<IsarProviderI>());

      List<Poem> poems = [
        Poem(title: 'title1', author: 'author1', poem: 'poem1'),
        Poem(title: 'title2', author: 'author2', poem: 'poem2')
      ];

      // put some poems in DB twice
      await poemRepository.populate(poems);
      await poemRepository.populate(poems);
      // get all DB
      List<Poem> dbPoems = await poemRepository.getAll();
      // poems should be in DB
      expect(dbPoems.length, equals(2));
    });

    test('fetching oldest poems', () async {
      // put some poems in DB
      List<Poem> poems = [
        Poem(title: 'title1', author: '', poem: ''),
        Poem(
            title: 'title3',
            author: '',
            poem: '',
            lastAccessTime: DateTime.now()),
      ];

      Isar db = await getIt.get<IsarProviderI>().open();
      await db.writeTxn(() => db.poems.putAll(poems));

      PoemRepository poemRepository =
          PoemRepository(getIt.get<IsarProviderI>());

      Poem? poem = await poemRepository.getOldest();
      expect(poem.title, equals('title1'));
    });

    test('mark poem as read', () async {
      // put some poems in DB
      List<Poem> poems = [
        Poem(
            title: 'title3',
            author: '',
            poem: '',
            lastAccessTime: DateTime.now()),
        Poem(title: 'title1', author: '', poem: ''),
        Poem(
            title: 'title2',
            author: '',
            poem: '',
            lastAccessTime: DateTime.now().subtract(const Duration(days: 1))),
      ];

      Isar db = await getIt.get<IsarProviderI>().open();
      await db.writeTxn(() => db.poems.putAll(poems));

      PoemRepository poemRepository =
          PoemRepository(getIt.get<IsarProviderI>());

      Poem? poem = await poemRepository.getOldest();
      expect(poem.title, equals('title1'));
      poem = await poemRepository.getOldest();
      expect(poem.title, equals('title1'));
      await poemRepository.markRead(poem);

      poem = await poemRepository.getOldest();
      await poemRepository.markRead(poem);
      expect(poem.title, equals('title2'));

      poem = await poemRepository.getOldest();
      await poemRepository.markRead(poem);
      expect(poem.title, equals('title3'));

      poem = await poemRepository.getOldest();
      await poemRepository.markRead(poem);
      expect(poem.title, equals('title1'));
    });
  });

  tearDownAll(() async {
    Isar db = await getIt.get<IsarProviderI>().open();
    await db.close(deleteFromDisk: true);
  });
}
