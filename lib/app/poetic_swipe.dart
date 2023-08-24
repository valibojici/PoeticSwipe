import 'package:flutter/material.dart';
import 'package:poetry_app/pages/home/home.dart';
import 'package:poetry_app/providers/favorite_provider.dart';
import 'package:poetry_app/providers/poem_provider.dart';
import 'package:poetry_app/themes/theme.dart';
import 'package:provider/provider.dart';

class PoeticSwipe extends StatelessWidget {
  final Future<void> initialize;
  const PoeticSwipe({super.key, required this.initialize});

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
                future: initialize,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return const Home();
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
