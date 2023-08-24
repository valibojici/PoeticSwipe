import 'package:flutter/material.dart';
import 'package:PoeticSwipe/models/poem/poem.dart';
import 'package:PoeticSwipe/pages/poem/poem.dart';
import 'package:PoeticSwipe/providers/favorite_provider.dart';
import 'package:PoeticSwipe/themes/theme.dart';
import 'package:provider/provider.dart';

class PoemCard extends StatelessWidget {
  final Poem poem;
  final MaterialColor color;

  const PoemCard({super.key, required this.poem, this.color = Colors.amber});
  final TextStyle titleStyle =
      const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);

  final TextStyle authorStyle =
      const TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic);
  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return GestureDetector(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => PoemView(poem: poem))),
      onDoubleTap: () => favoriteProvider.isLoading
          ? null
          : favoriteProvider.favoritePoem(poem),
      child: Card(
        elevation: 16,
        color: _getColor(
            Provider.of<ThemeProvider>(context).darkModeEnabled, color),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Icon(
                    color: Colors.red[600],
                    favoriteProvider.favoritesIds.contains(poem.id)
                        ? Icons.favorite
                        : Icons.favorite_border),
              ),
              Text(poem.title, style: titleStyle),
              Text(poem.author, style: authorStyle),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    poem.poem,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColor(bool darkMode, MaterialColor color) {
    if (!darkMode) {
      return color.shade50;
    }
    Color temp = color.shade900;
    const L = 0.1;
    return Color.fromRGBO((temp.red * L).round(), (temp.green * L).round(),
        (temp.blue * L).round(), 1);
  }
}
