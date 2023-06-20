import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:poetry_app/components/poem_card.dart';
import 'package:poetry_app/models/poem/poem.dart';
import 'package:poetry_app/pages/settings/settings.dart';
import 'package:poetry_app/services/interfaces/poem_repository_interface.dart';
import 'dart:async';
import 'dart:math' as math;

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const int IDS_PER_BATCH = 10;
  static const int CARDS_ON_SCREEN = 2;
  final PoemRepositoryI _poemRepository = GetIt.I.get<PoemRepositoryI>();
  final StreamController<List<int>> _poemIdStream =
      StreamController<List<int>>();

  // store only visibile poems (dont load all)
  final List<Poem?> _activePoems =
      List<Poem?>.generate(CARDS_ON_SCREEN, (index) => null);

  // store colors for visible poems
  final List<Color> _activePoemsColors =
      List<Color>.generate(CARDS_ON_SCREEN, (index) => Colors.white);

  // actual ids for poems (load as user swipes)
  final List<int> _poemIds = [];
  // to make sure all poems are marked read before getting another batch
  List<Future<void>> _poemMarkReadFutures = [];

  // initially load poems
  Future<List<int>> _initPoems() async {
    List<int> poemIds =
        await _poemRepository.getOldestAll(limit: IDS_PER_BATCH);
    _poemIds.addAll(poemIds);
    return poemIds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Poems'),
        actions: [_settingsButton(context)],
      ),
      body: FutureBuilder(
          future: _initPoems(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return StreamBuilder(
                stream: _poemIdStream.stream,
                initialData: snapshot.data!,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _poemIds.addAll(snapshot.data!);
                    return _poemCards();
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('error'));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error'));
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  @override
  void dispose() {
    _poemIdStream.close();
    super.dispose();
  }

  Widget _poemCards() {
    return Center(
      child: FractionallySizedBox(
        heightFactor: 0.75,
        widthFactor: 0.95,
        child: AppinioSwiper(
          cardsCount: _poemIds.length,
          onSwipe: (index, direction) {
            final int lastIndex = (index - 1) % CARDS_ON_SCREEN;
            // mark as read the previous poem
            if (_activePoems[lastIndex] != null) {
              _poemMarkReadFutures
                  .add(_poemRepository.markRead(_activePoems[lastIndex]!));
            }
            // mark previous card as unloaded
            _activePoems[lastIndex] = null;
          },
          onEnd: _loadPoemBatch,
          cardsBuilder: (_, int index) {
            if (_activePoems[index % CARDS_ON_SCREEN] != null) {
              return PoemCard(
                poem: _activePoems[index % CARDS_ON_SCREEN]!,
                color: _activePoemsColors[index % CARDS_ON_SCREEN],
              );
            }
            return FutureBuilder(
              future: _loadPoem(index),
              builder: (_, AsyncSnapshot<Poem> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return PoemCard(
                    poem: snapshot.data!,
                    color: _activePoemsColors[index % CARDS_ON_SCREEN],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          },
        ),
      ),
    );
  }

  // load a poem from database at using saved id at position index
  Future<Poem> _loadPoem(int index) async {
    Poem poem = (await _poemRepository.findById(_poemIds[index]))!;
    // put in the cached list
    _activePoems[index % CARDS_ON_SCREEN] = poem;
    // generate a random color
    _activePoemsColors[index % CARDS_ON_SCREEN] = Colors
        .primaries[math.Random().nextInt(Colors.primaries.length)].shade50;
    return poem;
  }

  // load a batch of unread poem ids from database
  Future<void> _loadPoemBatch() async {
    // wait for marked poems
    await Future.wait(_poemMarkReadFutures);
    List<int> poemIds =
        await _poemRepository.getOldestAll(limit: IDS_PER_BATCH);
    _poemIdStream.add(poemIds);
    // reset marked poems list
    _poemMarkReadFutures = [];
  }

  Widget _settingsButton(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (c) => const Settings(),
        ),
      ),
      icon: const Icon(Icons.settings),
    );
  }
}
