import 'package:isar/isar.dart';
import 'package:poetry_app/models/poem/poem.dart';
import 'package:poetry_app/services/interfaces/isar_provider_interface.dart';
import 'package:poetry_app/services/interfaces/poem_repository_interface.dart';

class PoemRepository implements PoemRepositoryI {
  final IsarProviderI _isarProvider;

  PoemRepository(this._isarProvider);

  @override
  Future<List<Poem>> getAll() async {
    final Isar db = await _isarProvider.open();
    return await db.txn(() => db.poems.where().findAll());
  }

  @override
  Future<void> populate(List<Poem> poems) async {
    final Isar db = await _isarProvider.open();
    await db.writeTxn(() => db.poems.putAll(poems));
  }

  @override
  Future<Poem> getOldest() async {
    final Isar db = await _isarProvider.open();
    // get a poem that has not been accessed recently
    Poem? poem = await db.poems.where().sortByLastAccess().findFirst();
    if (poem == null) throw Exception("No poems");
    return poem;
  }

  @override
  Future<void> markRead(Poem poem) async {
    final Isar db = await _isarProvider.open();
    // update time access and return
    poem.lastAccess = DateTime.now();
    await db.writeTxn(() => db.poems.put(poem));
  }

  @override
  Future<Poem?> findById(int id) async {
    final Isar db = await _isarProvider.open();
    return await db.poems.get(id);
  }

  @override
  Future<List<Poem?>> getOldestAll({int limit = 5}) async {
    final Isar db = await _isarProvider.open();
    return await db.poems.where().sortByLastAccess().limit(limit).findAll();
  }

  @override
  Future<void> toggleFavorite(Poem poem) async {
    final Isar db = await _isarProvider.open();
    poem.favoriteTime = poem.favoriteTime == null ? DateTime.now() : null;

    await db.writeTxn(() async => await db.poems.put(poem));
  }

  @override
  Future<List<Poem?>> findAllById(List<int> ids) async {
    final Isar db = await _isarProvider.open();
    return await db.poems.getAll(ids);
  }

  @override
  Future<List<int>> getFavorites() async {
    final Isar db = await _isarProvider.open();
    return await db.poems
        .filter()
        .favoriteTimeIsNotNull()
        .idProperty()
        .findAll();
  }

  @override
  Future<List<int>> getByText(String text,
      {bool title = false,
      bool body = false,
      bool author = false,
      exact = false,
      wordSearch = false}) async {
    final Isar db = await _isarProvider.open();

    if (wordSearch) {
      List<String> words = Isar.splitWords(text);
      return await db.poems
          .filter()
          .optional(
            title,
            (q) => q.allOf(
                words,
                (q, element) =>
                    q.titleWordsElementEqualTo(element, caseSensitive: false)),
          )
          .or()
          .optional(
            body,
            (q) => q.allOf(
                words,
                (q, element) =>
                    q.poemWordsElementEqualTo(element, caseSensitive: false)),
          )
          .or()
          .optional(
            author,
            (q) => q.allOf(
                words,
                (q, element) =>
                    q.authorWordsElementEqualTo(element, caseSensitive: false)),
          )
          .idProperty()
          .findAll();
    }

    // if !exact => split text in words using Isar
    if (!exact) {
      text = Isar.splitWords(text).join('*');
    }

    // find text anywhere
    text = '*$text*';

    return await db.poems
        .filter()
        .optional(title, (q) => q.titleMatches(text, caseSensitive: false))
        .or()
        .optional(body, (q) => q.poemMatches(text, caseSensitive: false))
        .or()
        .optional(author, (q) => q.authorMatches(text, caseSensitive: false))
        .idProperty()
        .findAll();
  }

  @override
  Future<int> count() async {
    final Isar db = await _isarProvider.open();
    final int count = await db.poems.count();
    return count;
  }
}
