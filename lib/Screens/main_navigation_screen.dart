import 'package:flutter/material.dart';
import '../Screens/favorite_places.dart';
import '../Screens/places_overview_screen.dart';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);
  static const id = 'MainNavigatorScreen';
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late PageController _pageController;
  int _selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    _pageController = PageController();
    super.initState();
  }

  final _appBarKey = GlobalKey<ConvexAppBarState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        items: const [
          TabItem(
            icon: Icon(
              Icons.landscape_outlined,
              color: Colors.black,
            ),
            title: 'All',
            activeIcon: Icon(
              Icons.landscape,
              color: Colors.white,
            ),
          ),
          TabItem(
            icon: Icon(
              Icons.favorite_border,
              color: Colors.black,
            ),
            title: 'Favorites',
            activeIcon: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
          ),
        ],
        key: _appBarKey,
        style: TabStyle.flip,
        activeColor: Colors.black,
        color: Colors.white,
        backgroundColor: Colors.green,
        initialActiveIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            print(_selectedIndex);
            _pageController.animateToPage(_selectedIndex,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn);
          });
        },
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
            _appBarKey.currentState?.animateTo(index);
          });
        },
        children: const [
          PlacesOverviewScreen(),
          FavoritePlacesScreen(),
        ],
      ),
    );
  }
}
