import 'dart:io';
import 'dart:math';
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

    test('fetching poems by id', () async {
      // put some poems in DB
      List<Poem> poems = [
        Poem(title: 'title1', author: '', poem: ''),
        Poem(title: 'title2', author: '', poem: ''),
      ];

      Isar db = await getIt.get<IsarProviderI>().open();
      await db.writeTxn(() => db.poems.putAll(poems));

      PoemRepository poemRepository =
          PoemRepository(getIt.get<IsarProviderI>());

      int poemId1 = (await db.poems
          .filter()
          .titleEqualTo('title1')
          .idProperty()
          .findFirst())!;
      int poemId2 = (await db.poems
          .filter()
          .titleEqualTo('title2')
          .idProperty()
          .findFirst())!;
      Poem poem1 = (await poemRepository.findById(poemId1))!;
      Poem poem2 = (await poemRepository.findById(poemId2))!;
      expect(poems[0].title, poem1.title);
      expect(poems[1].title, poem2.title);
    });

    test('fetching oldest ids', () async {
      // put some poems in DB
      List<Poem> poems = [
        Poem(
            title: 'title2',
            author: '',
            poem: '',
            lastAccessTime: DateTime.now().subtract(Duration(days: 1))),
        Poem(
            title: 'title3',
            author: '',
            poem: '',
            lastAccessTime: DateTime.now()),
        Poem(
            title: 'title1',
            author: '',
            poem: '',
            lastAccessTime: DateTime.now().subtract(Duration(days: 2))),
      ];

      Isar db = await getIt.get<IsarProviderI>().open();
      await db.writeTxn(() => db.poems.putAll(poems));

      PoemRepository poemRepository =
          PoemRepository(getIt.get<IsarProviderI>());

      List<int> ids =
          await db.poems.where().sortByLastAccess().idProperty().findAll();

      List<Poem> fetchedPoems = await Future.wait(
          ids.map((e) async => (await poemRepository.findById(e))!).toList());

      expect(fetchedPoems[0].title, 'title1');
      expect(fetchedPoems[1].title, 'title2');
      expect(fetchedPoems[2].title, 'title3');
    });

    test('fetching oldest poems in batch', () async {
      PoemRepository poemRepository =
          PoemRepository(getIt.get<IsarProviderI>());

      List<Poem> initialPoems = [
        Poem(
            title: 'title1',
            author: '',
            poem: '',
            lastAccessTime: DateTime.now()),
        Poem(
            title: 'title2',
            author: '',
            poem: '',
            lastAccessTime: DateTime.now().subtract(Duration(days: 1))),
        Poem(
            title: 'title3',
            author: '',
            poem: '',
            lastAccessTime: DateTime.now().add(Duration(days: 1))),
      ];
      await poemRepository.populate(initialPoems);

      final List<String> oldestPoems =
          List<Poem>.from(await poemRepository.getOldestAll(limit: 2))
              .map((e) => e.title)
              .toList();

      expect(oldestPoems.length, equals(2));
      expect(oldestPoems, containsAllInOrder(['title2', 'title1']));
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

    test('test fetching all by id', () async {
      PoemRepository poemRepository =
          PoemRepository(getIt.get<IsarProviderI>());

      await poemRepository.populate([
        Poem(title: 'title1', author: '', poem: ''),
        Poem(title: 'title2', author: '', poem: ''),
        Poem(title: 'title3', author: '', poem: ''),
      ]);

      final List<int> ids = (await poemRepository.getAll())
          .where((element) => element.title != 'title3')
          .map((e) => e.id)
          .toList();

      final List<String> poemTitles =
          List<Poem>.from(await poemRepository.findAllById(ids))
              .map((e) => e.title)
              .toList();

      expect(poemTitles.length, equals(2));
      expect(poemTitles, containsAll(['title1', 'title2']));
    });

    test('toggle favorite test', () async {
      PoemRepository poemRepository =
          PoemRepository(getIt.get<IsarProviderI>());
      List<Poem> initialPoems = [
        Poem(title: 'title1', author: '', poem: ''),
        Poem(title: 'title2', author: '', poem: ''),
      ];
      await poemRepository.populate(initialPoems);

      expect(initialPoems.map((e) => e.favoriteTime), equals([null, null]));

      await poemRepository.toggleFavorite(initialPoems[1]);

      expect(initialPoems[0].favoriteTime, isNull);
      expect(initialPoems[1].favoriteTime, isNotNull);

      await poemRepository.toggleFavorite(initialPoems[1]);
      expect(initialPoems.map((e) => e.favoriteTime), equals([null, null]));
    });

    test('searching', () async {
      PoemRepository poemRepository =
          PoemRepository(getIt.get<IsarProviderI>());

      List<Poem> initialPoems = [
        Poem(title: 'title1', author: 'author1', poem: 'abc abcd qwerty'),
        Poem(title: 'word', author: 'author1', poem: 'poem2'),
        Poem(title: 'title3', author: 'author2', poem: 'abcd qwerty abc'),
        Poem(
            title: 'Îmi pasă',
            author: 'Adrian Păunescu',
            poem: 'Mi-e dor de tine\nMi-e tine de tine...'),
      ];
      await poemRepository.populate(initialPoems);

      List<int> ids;
      ids = await poemRepository.getByText('title1', title: true);
      expect(ids, equals([1]));

      ids = await poemRepository.getByText('wert', body: true);
      expect(ids, equals([1, 3]));

      ids = await poemRepository.getByText('abc qwerty',
          body: true, wordSearch: true);
      expect(ids, equals([1, 3]));

      ids =
          await poemRepository.getByText('abc qwerty', body: true, exact: true);
      expect(ids, equals([]));

      ids = await poemRepository.getByText('abc qwerty', body: true);
      expect(ids, equals([1, 3]));

      ids = await poemRepository.getByText('Îmi pasă', title: true);
      expect(ids, equals([4]));
    });

    test('Last view time query', () async {
      PoemRepository poemRepository =
          PoemRepository(getIt.get<IsarProviderI>());

      List<Poem> initialPoems = [
        Poem(
            title: 'title1',
            poem: 'poem1',
            author: 'author1',
            lastAccessTime: DateTime(2023, 1, 1, 23, 30)),
        Poem(
            title: 'title2',
            poem: 'poem2',
            author: 'author2',
            lastAccessTime: DateTime(2023, 1, 2, 12, 30)),
        Poem(
            title: 'title3',
            poem: 'poem3',
            author: 'author3',
            lastAccessTime: DateTime(2023, 1, 3, 10, 30)),
      ];
      await poemRepository.populate(initialPoems);

      List<int> ids;
      ids =
          await poemRepository.getLastViewed(from: DateTime(2023, 1, 1, 0, 0));
      expect(ids, equals([3, 2, 1]));

      ids = await poemRepository.getLastViewed(
          from: DateTime(2023, 1, 1, 0, 0),
          to: DateTime(2023, 1, 2, 12, 30, 1));
      expect(ids, equals([2, 1]));

      ids = await poemRepository.getLastViewed(
          from: DateTime(2023, 1, 1, 0, 0), to: DateTime(2023, 1, 2, 12, 30));
      expect(ids, equals([2, 1]));

      ids = await poemRepository.getLastViewed(
          from: DateTime(2023, 1, 1, 0, 0),
          to: DateTime(2023, 1, 2, 12, 29, 59));
      expect(ids, equals([1]));
    });
  });

  tearDownAll(() async {
    Isar db = await getIt.get<IsarProviderI>().open();
    await db.close(deleteFromDisk: true);
  });
}
