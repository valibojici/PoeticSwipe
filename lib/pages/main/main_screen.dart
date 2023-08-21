import 'package:flutter/material.dart';
import 'package:poetry_app/pages/favorites/favorites.dart';
import 'package:poetry_app/pages/home/home.dart';
import 'package:poetry_app/pages/main/custom_drawer.dart';
import 'package:poetry_app/pages/search/search.dart';
import 'package:poetry_app/pages/settings/settings.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late final List<Widget> _pages;
  final PageController _pageController = PageController();

  @override
  void initState() {
    setState(() {
      _pages = [
        const Home(),
        const Search(),
        const Favorites(),
      ];
    });
    super.initState();
  }

  void onPageChange(int index) {
    if (index == _currentIndex) return;
    _pageController.jumpToPage(index);
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [_settingsButton(context)],
      ),
      drawer: CustomDrawer(),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChange,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
        onTap: onPageChange,
      ),
    );
  }

  Widget _settingsButton(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (c) => const Settings(),
        ),
      ),
      icon: const Icon(Icons.settings),
    );
  }
}
