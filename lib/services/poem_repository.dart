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
  Future<Poem?> getOldest() async {
    final Isar db = await _isarProvider.open();
    // get a poem that has not been accessed recently
    Poem? poem = await db.poems.where().sortByLastAccess().findFirst();
    // if its null return null
    if (poem == null) return null;
    // update time access and return
    poem.lastAccess = DateTime.now();
    await db.writeTxn(() => db.poems.put(poem));

    return poem;
  }
}
