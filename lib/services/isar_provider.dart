import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:PoeticSwipe/models/poem/poem.dart';
import 'package:PoeticSwipe/services/interfaces/isar_provider_interface.dart';

class IsarProvider implements IsarProviderI {
  static Isar? _db;
  @override
  Future<Isar> open() async {
    if (_db != null && _db!.isOpen) {
      return _db!;
    }
    final String dir = (await getApplicationDocumentsDirectory()).path;
    _db = await Isar.open([PoemSchema], directory: dir);
    return _db!;
  }
}
