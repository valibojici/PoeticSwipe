import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poetry_app/providers/favorite_provider.dart';
import 'package:poetry_app/providers/poem_provider.dart';
import 'package:poetry_app/pages/main/main_screen.dart';
import 'package:poetry_app/services/interfaces/isar_provider_interface.dart';
import 'package:poetry_app/services/interfaces/poem_repository_interface.dart';
import 'package:poetry_app/services/interfaces/root_bundle_provider_interface.dart';
import 'package:poetry_app/services/interfaces/settings_interface.dart';
import 'package:poetry_app/services/isar_provider.dart';
import 'package:poetry_app/services/notifications.dart';
import 'package:poetry_app/services/poem_repository.dart';
import 'package:poetry_app/services/root_bundle_provider.dart';
import 'package:poetry_app/services/settings.dart';
import 'package:poetry_app/themes/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDI();

  // check if DB need to be loaded (first launch)
  final Future<void> loadDB = (await GetIt.I.get<PoemRepositoryI>().count()) ==
          0
      ? () async {
          // get path to DB
          String dbPath = p.join(
              (await getApplicationDocumentsDirectory()).path, "default.isar");
          // load zip file
          ByteData data =
              await rootBundle.load(p.join("assets", "poems.isar.zip"));
          List<int> bytes =
              data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
          // unzip and get content
          final dynamic content = ZipDecoder().decodeBytes(bytes).first.content;
          // overwrite original (empty) DB
          await File(dbPath).writeAsBytes(content as List<int>);
        }()
      : Future(() => null);

  // init flutter_local_notifications
  await GetIt.I.get<NotificationService>().init();

  runApp(PoetryApp(loadDB: loadDB));
}

class PoetryApp extends StatelessWidget {
  final Future<void> loadDB;
  const PoetryApp({super.key, required this.loadDB});

  // final populatingDB = GetIt.I.get<PoemRepositoryI>().populate().then((value) => );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PoemProvider(batchSize: 10)),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider())
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, value, child) {
          return MaterialApp(
            title: 'Poetry',
            theme: value.theme,
            home: FutureBuilder(
                future: loadDB,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return const MainScreen();
                  }
                  return _loading();
                }),
          );
        },
      ),
    );
  }

  Widget _loading() {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Perfoming first time setup (populating database)...'),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

void setupDI() {
  final getIt = GetIt.I;
  getIt.registerSingleton<RootBundleProviderI>(RootBundleProvider());
  getIt.registerSingleton<IsarProviderI>(IsarProvider());
  getIt.registerSingleton<PoemRepositoryI>(
      PoemRepository(getIt.get<IsarProviderI>()));
  getIt.registerSingletonAsync<SettingsServiceI>(
      () async => SettingsService(await SharedPreferences.getInstance()));
  getIt.registerSingleton<NotificationService>(NotificationService());
}
