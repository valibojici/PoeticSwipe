import 'package:flutter/services.dart';
import 'package:poetry_app/services/interfaces/root_bundle_provider_interface.dart';

class RootBundleProvider implements RootBundleProviderI {
  @override
  Future<String> loadPoemCsv() async {
    return await rootBundle.loadString('assets/poems.csv');
  }
}
