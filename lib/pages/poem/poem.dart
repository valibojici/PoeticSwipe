import 'package:flutter/material.dart';
import 'package:poetry_app/models/poem/poem.dart';
import 'package:poetry_app/providers/favorite_provider.dart';
import 'package:poetry_app/providers/poem_provider.dart';
import 'package:provider/provider.dart';

class PoemView extends StatelessWidget {
  final Poem poem;
  const PoemView({super.key, required this.poem});

  final TextStyle titleStyle =
      const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);

  final TextStyle authorStyle =
      const TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic);

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final poemProvider = Provider.of<PoemProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () async {
                await favoriteProvider.favoritePoem(poem);
                poemProvider.refreshPoem(poem.id);
              },
              icon: Icon(
                  color: Colors.red[600],
                  poem.favoriteTime != null
                      ? Icons.favorite
                      : Icons.favorite_outline)),
        ],
      ),
      body: SingleChildScrollView(
        key: ObjectKey(poem.id),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Text(poem.title, style: titleStyle),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(poem.author, style: authorStyle),
                ),
                Text(poem.poem)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
