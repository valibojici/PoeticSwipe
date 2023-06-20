import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:poetry_app/models/poem/poem.dart';
import 'package:poetry_app/pages/poem/poem.dart';

class PoemCard extends StatelessWidget {
  final Poem poem;
  final Color color;
  const PoemCard(
      {super.key,
      required this.poem,
      this.color = const Color.fromRGBO(255, 224, 178, 1)});
  final TextStyle titleStyle =
      const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);

  final TextStyle authorStyle =
      const TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => PoemView(poem: poem))),
      child: Card(
        elevation: 16,
        color: color,
        // color: Colors.orange[100],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
}
