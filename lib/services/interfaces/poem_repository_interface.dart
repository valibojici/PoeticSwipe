import '../../models/poem/poem.dart';

abstract class PoemRepositoryI {
  Future<List<Poem>> getAll();
  Future<void> populate(List<Poem> poems);
  Future<Poem> getOldest();
  Future<void> markRead(Poem poem);
}
