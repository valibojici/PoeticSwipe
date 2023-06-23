import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:poetry_app/models/poem/poem.dart';
import 'package:poetry_app/services/interfaces/poem_repository_interface.dart';

class PoemProvider extends ChangeNotifier {
  final int _batchSize;

  bool isLoading = false;

  List<Poem> poems = [];
  List<Color> colors = [];
  final PoemRepositoryI _poemRepo = GetIt.I.get<PoemRepositoryI>();

  List<Future<void>> _poemMarkReadFutures = [];

  PoemProvider({required int batchSize}) : _batchSize = batchSize {
    loadPoemBatch();
  }

  void markRead(int index) {
    _poemMarkReadFutures.add(_poemRepo.markRead(poems[index]));
  }

  Poem getPoem(int index) {
    return poems[index % _batchSize];
  }

  void loadPoemBatch() {
    _callAsync(() async {
      // wait to mark previous poems
      await Future.wait(_poemMarkReadFutures);
      _poemMarkReadFutures = [];
      poems = List<Poem>.from(await _poemRepo.getOldestAll(limit: _batchSize));
      colors = List<Color>.generate(poems.length, (_) => _getRandomColor());
    });
  }

  Color _getRandomColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)].shade50;
  }

  Color getColor(int index) {
    return colors[index % _batchSize];
  }

  void refreshPoem(int id) async {
    int index = poems.indexWhere((element) => element.id == id);
    if (index == -1) return;
    _callAsync(() async {
      poems[index] = (await _poemRepo.findById(id))!;
    });
  }

  void _callAsync(Function callback) async {
    assert(isLoading == false);
    isLoading = true;
    notifyListeners();

    await callback.call();

    isLoading = false;
    notifyListeners();
  }
}
