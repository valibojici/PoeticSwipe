import 'package:flutter/material.dart';
import 'package:poetry_app/models/poem/poem.dart';
import 'package:poetry_app/providers/favorite_provider.dart';
import 'package:poetry_app/providers/poem_provider.dart';
import 'package:poetry_app/pages/poem/poem.dart';
import 'package:provider/provider.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer2<PoemProvider, FavoriteProvider>(
      builder: (context, poemProvider, favoritesProvider, child) {
        if (favoritesProvider.is_loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (favoritesProvider.loadedAllPoems &&
            favoritesProvider.favoritesIds.isEmpty) {
          return const Center(child: Text('No saved poems'));
        }
        return ListView.builder(
          itemCount: favoritesProvider.loadedPoems.length +
              (favoritesProvider.loadedAllPoems ? 0 : 1),
          itemBuilder: (context, index) {
            if (!favoritesProvider.loadedAllPoems &&
                index == favoritesProvider.loadedPoems.length) {
              favoritesProvider.loadPoems();
              return const ListTile(
                  title: Center(child: CircularProgressIndicator()));
            }
            Poem poem = favoritesProvider.loadedPoems[index];
            return ListTile(
              title: Text(poem.title),
              subtitle: Text(poem.author),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PoemView(poem: poem)),
              ),
            );
          },
        );
      },
    );
  }

  bool _keepAlive = true;
  @override
  bool get wantKeepAlive => _keepAlive;
}
