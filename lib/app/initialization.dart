import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:PoeticSwipe/services/interfaces/isar_provider_interface.dart';
import 'package:PoeticSwipe/services/interfaces/poem_repository_interface.dart';
import 'package:PoeticSwipe/services/interfaces/root_bundle_provider_interface.dart';
import 'package:PoeticSwipe/services/interfaces/settings_interface.dart';
import 'package:PoeticSwipe/services/isar_provider.dart';
import 'package:PoeticSwipe/services/notifications.dart';
import 'package:PoeticSwipe/services/poem_repository.dart';
import 'package:PoeticSwipe/services/root_bundle_provider.dart';
import 'package:PoeticSwipe/services/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

Future<void> initialize() async {
  // setup DI
  _setupDI();
  // init flutter_local_notifications
  await GetIt.I.get<NotificationService>().init();
}

Future<void> initializeDatabase() async {
  int poemCount = (await GetIt.I.get<PoemRepositoryI>().count());
  if (poemCount > 0) {
    // poems loaded
    return;
  }

  final String appDirPath = (await getApplicationDocumentsDirectory()).path;
  final String dbPath = p.join(appDirPath, "default.isar");

  // load zip file
  final ByteData data =
      await rootBundle.load(p.join("assets", "poems.isar.zip"));
  final List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  // unzip and get content
  final dynamic content = ZipDecoder().decodeBytes(bytes).first.content;
  // overwrite original (empty) DB
  await File(dbPath).writeAsBytes(content as List<int>);
}

void _setupDI() {
  final getIt = GetIt.I;
  getIt.registerSingleton<RootBundleProviderI>(RootBundleProvider());
  getIt.registerSingleton<IsarProviderI>(IsarProvider());
  getIt.registerSingleton<PoemRepositoryI>(
      PoemRepository(getIt.get<IsarProviderI>()));
  getIt.registerSingletonAsync<SettingsServiceI>(
      () async => SettingsService(await SharedPreferences.getInstance()));
  getIt.registerSingleton<NotificationService>(NotificationService());
}
