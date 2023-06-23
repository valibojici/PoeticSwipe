import 'package:flutter/material.dart';
import 'package:poetry_app/models/poem/poem.dart';
import 'package:poetry_app/pages/poem/poem.dart';
import 'package:poetry_app/themes/theme.dart';
import 'package:provider/provider.dart';

class PoemCard extends StatelessWidget {
  final Poem? poem;
  final MaterialColor color;
  final Function()? onDoubleTap;

  const PoemCard(
      {super.key,
      required this.poem,
      this.color = Colors.amber,
      this.onDoubleTap});
  final TextStyle titleStyle =
      const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);

  final TextStyle authorStyle =
      const TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: poem == null
          ? null
          : () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => PoemView(poem: poem!))),
      onDoubleTap: onDoubleTap,
      child: Card(
        elevation: 16,
        color: Provider.of<ThemeProvider>(context).darkModeEnabled
            ? _getColor(true, color)
            : _getColor(false, color),
        // color: Colors.orange[100],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: poem == null
              ? Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: _getIcon(),
                    ),
                    Text(poem!.title, style: titleStyle),
                    Text(poem!.author, style: authorStyle),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          poem!.poem,
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

  Widget _getIcon() {
    return Icon(
        color: Colors.red[600],
        poem!.favoriteTime == null ? Icons.favorite_border : Icons.favorite);
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
