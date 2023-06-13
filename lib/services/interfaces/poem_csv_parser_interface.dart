import 'package:poetry_app/models/poem/poem.dart';

abstract class PoemCsvParserI {
  Future<List<Poem>> parse();
}
