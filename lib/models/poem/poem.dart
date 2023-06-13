import 'package:isar/isar.dart';

part 'poem.g.dart';

@collection
class Poem {
  Id id = Isar.autoIncrement;

  String title;
  String author;
  String poem;
  DateTime lastAccess;

  Poem(
      {required this.title,
      required this.author,
      required this.poem,
      DateTime? lastAccessTime})
      : lastAccess = lastAccessTime ?? DateTime(1970);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'poem': poem,
      'lastAccess': lastAccess
    };
  }
}
