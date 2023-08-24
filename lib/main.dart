import 'package:flutter/material.dart';
import 'package:poetry_app/app/initialization.dart';
import 'package:poetry_app/app/poetic_swipe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize();
  runApp(PoeticSwipe(initialize: initializeDatabase()));
}
