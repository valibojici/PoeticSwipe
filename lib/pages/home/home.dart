import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:poetry_app/components/poem_card.dart';
import 'package:poetry_app/models/poem/poem.dart';
import 'package:poetry_app/services/interfaces/poem_repository_interface.dart';
import 'package:poetry_app/services/poem_repository.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PoemRepositoryI _poemRepository = GetIt.I.get<PoemRepositoryI>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Poems'),
      ),
      body: Center(
        child: FutureBuilder(
          future: () async {
            Poem currentPoem = await _poemRepository.getOldest();
            await _poemRepository.markRead(currentPoem);
            return currentPoem;
          }(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return PoemCard(poem: snapshot.data!);
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error :("));
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {}),
        child: Icon(
          Icons.arrow_right_rounded,
          size: 40.0,
        ),
      ),
    );
  }
}
