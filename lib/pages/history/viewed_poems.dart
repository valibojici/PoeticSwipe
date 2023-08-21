import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:poetry_app/models/poem/poem.dart';
import 'package:poetry_app/pages/poem/poem.dart';
import 'package:poetry_app/services/interfaces/poem_repository_interface.dart';

class ViewedPoems extends StatefulWidget {
  const ViewedPoems({super.key});

  @override
  State<ViewedPoems> createState() => _ViewedPoemsState();
}

class _ViewedPoemsState extends State<ViewedPoems> {
  final PoemRepositoryI _poemRepo = GetIt.I.get<PoemRepositoryI>();
  Future<List<int>> _viewedPoemsIds = Future.value([]);
  final List<Poem> _loadedPoems = [];

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    setState(() {
      _viewedPoemsIds =
          _poemRepo.getLastViewed(from: DateTime(now.year, now.month, now.day));
    });
  }

  void _loadPoems(ids) async {
    final List<Poem> newPoems =
        (await _poemRepo.findAllById(ids)).map((e) => e as Poem).toList();

    setState(() {
      _loadedPoems.addAll(newPoems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Today's viewed poems")),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          }
          return _buildList(snapshot.data ?? []);
        },
        future: _viewedPoemsIds,
      ),
    );
  }

  Widget _buildList(List<int> ids) {
    if (ids.isEmpty) {
      return const Center(child: Text('No poems marked as read today'));
    }
    return ListView.separated(
      itemBuilder: (context, index) {
        if (index == _loadedPoems.length) {
          // fetch more poems
          _loadPoems(ids.skip(_loadedPoems.length).take(10).toList());
          return const Center(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ));
        }
        Poem poem = _loadedPoems[index];

        return ListTile(
          title: Text(poem.title),
          subtitle: Text(poem.author),
          trailing:
              Text('Viewed at: ${DateFormat.Hm().format(poem.lastAccess)}'),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PoemView(poem: poem)),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount:
          _loadedPoems.length + (_loadedPoems.length == ids.length ? 0 : 1),
    );
  }
}
