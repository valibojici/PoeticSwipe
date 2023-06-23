import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:poetry_app/services/interfaces/poem_repository_interface.dart';

import '../models/poem/poem.dart';

class FavoriteProvider extends ChangeNotifier {
  bool is_loading = false;
  // bool loadedAllPoems = false;

  final PoemRepositoryI _poemRepo = GetIt.I.get<PoemRepositoryI>();
  FavoriteProvider() {
    init();
  }

  List<Poem> loadedPoems = [];
  List<int> favoritesIds = [];

  void init() async {
    is_loading = true;
    notifyListeners();
    _favoriteStream = await _poemRepo.favoritesStream();

    _favoriteStream.listen((ids) async {
      if (ids.length == favoritesIds.length) return; // no changes
      if (favoritesIds.isEmpty) {
        // first load
        favoritesIds = ids;
        notifyListeners();
        return;
      }

      if (ids.length < favoritesIds.length) {
        // find which id was removed
        int index = 0;
        while (index < ids.length) {
          if (ids[index] != favoritesIds[index]) break;
          index++;
        }
        // delete loaded poem if necesary
        if (index < loadedPoems.length) {
          loadedPoems.removeAt(index);
        }
        favoritesIds.removeAt(index);
        notifyListeners();
        return;
      }
      // new poem added at position 0
      // load this poem in the cache
      is_loading = true;
      notifyListeners();

      loadedPoems.insert(0, (await _poemRepo.findById(ids[0]))!);

      is_loading = false;
      notifyListeners();

      favoritesIds = ids;
    });

    is_loading = false;
    notifyListeners();
  }

  late Stream<List<int>> _favoriteStream;

  Future<void> favoritePoem(Poem poem) async {
    is_loading = true;
    notifyListeners();

    await _poemRepo.toggleFavorite(poem);

    is_loading = false;
    // notifyListeners(); // done by stream listner
  }

  void loadPoems({int count = 10}) async {
    if (loadedAllPoems) return;

    // check if new poems have been favorited
    List<Poem> newPoems = List<Poem>.from(await _poemRepo.findAllById(
        favoritesIds.skip(loadedPoems.length).take(count).toList()));
    loadedPoems.addAll(newPoems);
    notifyListeners();
  }

  bool get loadedAllPoems => loadedPoems.length == favoritesIds.length;
}
