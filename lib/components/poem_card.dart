import 'package:flutter/material.dart';
import 'package:poetry_app/models/poem/poem.dart';

class PoemCard extends StatelessWidget {
  final Poem poem;
  const PoemCard({super.key, required this.poem});
  final TextStyle titleStyle =
      const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);

  final TextStyle authorStyle =
      const TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }
}
