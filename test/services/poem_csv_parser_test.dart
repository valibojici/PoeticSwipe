import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:poetry_app/models/poem/poem.dart';
import 'package:poetry_app/services/poem_csv_parser.dart';
import 'package:poetry_app/services/interfaces/poem_csv_parser_interface.dart';
import 'package:poetry_app/services/interfaces/root_bundle_provider_interface.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// generate Mocks and import them
@GenerateNiceMocks([MockSpec<RootBundleProviderI>(as: #MockRootBundleProvider)])
import 'poem_csv_parser_test.mocks.dart';

void main() {
  final GetIt getIt = GetIt.instance;
  group('importing poems', () {
    setUpAll(() async {
      await getIt.reset();
      // setup depedency injection with mocking
      getIt.registerSingleton<RootBundleProviderI>(MockRootBundleProvider());
      getIt.registerSingleton<PoemCsvParserI>(
          PoemCsvParser(getIt.get<RootBundleProviderI>()));
    });

    test('importing a poem', () async {
      // mock loadPoemCsv and return custom string
      when(getIt.get<RootBundleProviderI>().loadPoemCsv()).thenAnswer(
        (_) async =>
            "Title|Author|Poem\r\nTest title|Test author|Test content\\nTest content\\nTest content",
      );

      // get poems using mocked RootBundleProvider
      List<Poem> poems = await getIt.get<PoemCsvParserI>().parse();

      expect(poems.length, greaterThan(0));
      expect(poems[0].poem.split('\n').length, equals(3));
    });

    test('importing a poem with missing fields', () {
      // mock loadPoemCsv and return custom string
      when(getIt.get<RootBundleProviderI>().loadPoemCsv()).thenAnswer(
        (_) async => Future<String>.value(
            "Title|Poem\r\nTest title|Test content\\nTest content\\n"),
      );

      expect(() async => await getIt.get<PoemCsvParserI>().parse(),
          throwsA(isA<TypeError>()));
    });
  });
}
