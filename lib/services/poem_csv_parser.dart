import 'package:csv/csv.dart';
import 'package:poetry_app/services/interfaces/poem_csv_parser_interface.dart';
import 'package:poetry_app/services/interfaces/root_bundle_provider_interface.dart';

import '../models/poem/poem.dart';

class PoemCsvParser implements PoemCsvParserI {
  late final RootBundleProviderI _rootBundleProvider;
  PoemCsvParser(this._rootBundleProvider);

  @override
  Future<List<Poem>> parse() async {
    final String csv = await _rootBundleProvider.loadPoemCsv();
    List<List<dynamic>> poemList =
        const CsvToListConverter(fieldDelimiter: '|').convert(csv);
    Map<String, int> fieldsMap =
        poemList.removeAt(0).asMap().map((key, value) => MapEntry(value, key));

    return poemList
        .map(
          (e) => Poem(
            title: e[fieldsMap['Title']!],
            author: e[fieldsMap['Author']!],
            poem: e[fieldsMap['Poem']!]
                .toString()
                .replaceAll(RegExp(r'\\n'), '\n'),
          ),
        )
        .toList();
  }
}
