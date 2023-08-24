import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:PoeticSwipe/services/interfaces/poem_repository_interface.dart';

import '../models/poem/poem.dart';

class FavoriteProvider extends ChangeNotifier {
  bool isLoading = false;
  bool loadedAllPoems = false;
  int loadedCount = 0;
  // bool loadedAllPoems = false;

  final PoemRepositoryI _poemRepo = GetIt.I.get<PoemRepositoryI>();
  FavoriteProvider() {
    init();
  }

  List<Poem> loadedPoems = [];
  List<int> favoritesIds = [];

  void init() async {
    isLoading = true;
    notifyListeners();

    favoritesIds = await _poemRepo.getFavorites();
    // loadedPoems = List<Poem>.from(await _poemRepo.findAllById(favoritesIds));

    isLoading = false;
    notifyListeners();
  }

  Future<void> favoritePoem(Poem poem) async {
    // isLoading = true;
    // notifyListeners();

    if (poem.favoriteTime == null) {
      favoritesIds.insert(0, poem.id);
      await _poemRepo.toggleFavorite(poem);
      loadedPoems.insert(0, (await _poemRepo.findById(poem.id))!);
      loadedCount++;
    } else {
      favoritesIds.removeWhere((id) => id == poem.id);
      await _poemRepo.toggleFavorite(poem);
      loadedPoems.removeWhere((p) => p.id == poem.id);
      loadedCount--;
    }

    // isLoading = false;
    notifyListeners();
  }

  void loadPoems({int count = 10}) async {
    if (loadedAllPoems) return;

    // check if new poems have been favorited
    List<Poem> newPoems = List<Poem>.from(await _poemRepo
        .findAllById(favoritesIds.skip(loadedCount).take(count).toList()));

    loadedCount += count;
    loadedPoems.addAll(newPoems);

    loadedAllPoems = loadedPoems.last.id == favoritesIds.last;
    notifyListeners();
  }
}
