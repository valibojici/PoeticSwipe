import '../../models/poem/poem.dart';

abstract class PoemRepositoryI {
  Future<int> count();
  Future<List<Poem>> getAll();
  Future<void> populate(List<Poem> poems);
  Future<Poem> getOldest();
  Future<void> markRead(Poem poem);

  Future<Poem?> findById(int id);
  Future<List<Poem?>> findAllById(List<int> ids);
  Future<List<Poem?>> getOldestAll({int limit = 5});

  Future<List<int>> getFavorites();
  Future<void> toggleFavorite(Poem poem);

  Future<List<int>> getByText(String text,
      {bool title = false,
      bool body = false,
      bool author = false,
      exact = false});
}
