import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:poetry_app/pages/home/home.dart';
import 'package:poetry_app/services/interfaces/isar_provider_interface.dart';
import 'package:poetry_app/services/interfaces/poem_csv_parser_interface.dart';
import 'package:poetry_app/services/interfaces/poem_repository_interface.dart';
import 'package:poetry_app/services/interfaces/root_bundle_provider_interface.dart';
import 'package:poetry_app/services/interfaces/settings_interface.dart';
import 'package:poetry_app/services/isar_provider.dart';
import 'package:poetry_app/services/notifications.dart';
import 'package:poetry_app/services/poem_csv_parser.dart';
import 'package:poetry_app/services/poem_repository.dart';
import 'package:poetry_app/services/root_bundle_provider.dart';
import 'package:poetry_app/services/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDI();
  final Future<void> loadDB = GetIt.I
      .get<PoemCsvParserI>()
      .parse()
      .then((poems) => GetIt.I.get<PoemRepositoryI>().populate(poems));

  // init flutter_local_notifications
  await GetIt.I.get<NotificationService>().init();

  runApp(PoetryApp(loadDB: loadDB));
}

class PoetryApp extends StatelessWidget {
  final Future<void> loadDB;
  PoetryApp({super.key, required this.loadDB});

  // final populatingDB = GetIt.I.get<PoemRepositoryI>().populate().then((value) => );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poetry',
      home: FutureBuilder(
          future: loadDB,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Home();
            }
            return _loading();
          }),
    );
  }

  Widget _loading() {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

void setupDI() {
  final getIt = GetIt.I;
  getIt.registerSingleton<RootBundleProviderI>(RootBundleProvider());
  getIt.registerSingleton<PoemCsvParserI>(
      PoemCsvParser(getIt.get<RootBundleProviderI>()));
  getIt.registerSingleton<IsarProviderI>(IsarProvider());
  getIt.registerSingleton<PoemRepositoryI>(
      PoemRepository(getIt.get<IsarProviderI>()));
  getIt.registerSingletonAsync<SettingsServiceI>(
      () async => SettingsService(await SharedPreferences.getInstance()));
  getIt.registerSingleton<NotificationService>(NotificationService());
}
