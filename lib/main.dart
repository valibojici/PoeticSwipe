import 'package:flutter/material.dart';
import 'package:PoeticSwipe/app/initialization.dart';
import 'package:PoeticSwipe/app/poetic_swipe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize();
  runApp(PoeticSwipe(initialize: initializeDatabase()));
}
