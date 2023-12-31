import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:poetry_app/models/poem/poem.dart';
import 'package:poetry_app/pages/poem/poem.dart';
import 'package:poetry_app/services/interfaces/poem_repository_interface.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin {
  final TextEditingController _textEditingController = TextEditingController();
  final PoemRepositoryI _poemRepo = GetIt.I.get<PoemRepositoryI>();
  List<int> _poemIds = [];
  List<Poem> _loadedPoems = [];
  bool _noResults = false;
  final FocusNode _focusNode = FocusNode();
  bool _exactMatch = false;

  final Map<String, bool> _filters = {
    'Title': true,
    'Poem': false,
    'Author': false
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [_searchBar(), Expanded(child: _results())],
      ),
    );
  }

  Widget _searchBar() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (_) {
                      if (_textEditingController.text.trim() == '') {
                        return 'Please enter a search query';
                      }
                      if (!_filters.values.reduce(
                          (value, element) => value = value | element)) {
                        return 'Select at least one search category.';
                      }
                      return null;
                    },
                    onFieldSubmitted: (String? val) => _onSearch(),
                    controller: _textEditingController,
                    focusNode: _focusNode,
                    onTapOutside: (_) => _focusNode.unfocus(),
                    // expands: true,
                    decoration: InputDecoration(
                      suffixIcon: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: _onSearch,
                              icon: const Icon(Icons.search)),
                          IconButton(
                              onPressed: () => _onFilter(context),
                              icon: const Icon(Icons.filter_list)),
                        ],
                      ),
                      // contentPadding:
                      //     EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        // Regular border when the TextField is not focused
                        borderRadius: BorderRadius.circular(8.0),
                        // borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // Border when the TextField is focused
                        borderRadius: BorderRadius.circular(8.0),
                        // borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  _checkbox(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _onSearch() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _focusNode.unfocus();
        _poemIds = [];
        _loadedPoems = [];
      });
      List<int> ids = await _poemRepo.getByText(_textEditingController.text,
          title: _filters['Title']!,
          body: _filters['Poem']!,
          author: _filters['Author']!,
          exact: _exactMatch);
      setState(() {
        _noResults = ids.isEmpty;
        _poemIds = ids;
      });
    }
  }

  _onFilter(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
          initialValue: _filters.entries
              .where((element) => element.value == true)
              .map((e) => e.key)
              .toList(),
          onSelectionChanged: (values) => print(values),
          title: Text('Searching for'),
          items: _filters.keys.map((e) => MultiSelectItem(e, e)).toList(),
          listType: MultiSelectListType.CHIP,
          selectedColor: Theme.of(context).colorScheme.primary,
          // unselectedColor: Theme.of(context).colorScheme.,
          selectedItemsTextStyle:
              TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          onConfirm: (values) {
            setState(() {
              _filters.forEach((key, value) {
                _filters[key] = values.contains(key);
              });
            });
          },
        );
      },
    );
  }

  _loadPoems() async {
    List<Poem?> newPoems = await _poemRepo
        .findAllById(_poemIds.skip(_loadedPoems.length).take(2).toList());
    setState(() {
      _loadedPoems.addAll(newPoems.map((e) => e as Poem).toList());
    });
  }

  _results() {
    if (_noResults) {
      return Center(child: Text('No results...'));
    }

    return ListView.separated(
      itemCount: _loadedPoems.length +
          (_loadedPoems.length == _poemIds.length ? 0 : 1),
      itemBuilder: (context, index) {
        if (index == _loadedPoems.length) {
          _loadPoems();
          return Center(child: CircularProgressIndicator());
        }
        final poem = _loadedPoems[index];
        return ListTile(
          title: Text(poem.title),
          subtitle: Text(poem.author),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PoemView(poem: poem)),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  _checkbox() {
    return Row(
      children: [
        Checkbox(
          value: _exactMatch,
          onChanged: (value) {
            setState(() {
              _exactMatch = value!;
            });
          },
        ),
        Text('Word search')
      ],
    );
  }

  bool _keepAlive = true;
  @override
  bool get wantKeepAlive => _keepAlive;
}
