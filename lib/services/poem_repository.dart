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
    final int count = await db.poems.count();
    if (count == 0) {
      await db.writeTxn(() => db.poems.putAll(poems));
    }
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
  Future<List<int>> getOldestAll({int limit = 5}) async {
    final Isar db = await _isarProvider.open();
    return db.poems
        .where()
        .sortByLastAccess()
        .limit(limit)
        .idProperty()
        .findAll();
  }
}
