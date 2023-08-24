import 'package:flutter/material.dart';
import 'package:PoeticSwipe/models/poem/poem.dart';
import 'package:PoeticSwipe/providers/favorite_provider.dart';
import 'package:PoeticSwipe/pages/poem/poem.dart';
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
    return Consumer<FavoriteProvider>(
      builder: (context, favoritesProvider, child) {
        if (favoritesProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (favoritesProvider.favoritesIds.isEmpty) {
          return const Center(child: Text('No saved poems'));
        }
        return ListView.separated(
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
          separatorBuilder: (context, index) => const Divider(),
        );
      },
    );
  }

  final bool _keepAlive = true;
  @override
  bool get wantKeepAlive => _keepAlive;
}
