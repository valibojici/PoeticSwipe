import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:poetry_app/models/poem/poem.dart';
import 'package:poetry_app/pages/poem/poem.dart';

class PoemCard extends StatelessWidget {
  final Poem? poem;
  final Color color;
  final Function()? onDoubleTap;

  const PoemCard(
      {super.key,
      required this.poem,
      this.color = const Color.fromRGBO(255, 224, 178, 1),
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
        color: color,
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
        poem!.favoriteTime == null ? Icons.favorite_border : Icons.favorite);
  }
}
