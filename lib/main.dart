import 'package:flutter/material.dart';
import 'package:great_places/Screens/main_navigation_screen.dart';
import 'package:provider/provider.dart';
import './Providers/places_provider.dart';
import 'Screens/place_details_screen.dart';
import 'Screens/places_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PlacesProvider()),
        ChangeNotifierProvider(create: (context) => ImagesProvider()),
      ],
      child: MaterialApp(
        initialRoute: MainNavigationScreen.id,
        routes: {
          PlacesOverviewScreen.id: (context) => PlacesOverviewScreen(),
          PlaceDetailsScreen.id: (context) => PlaceDetailsScreen(),
          MainNavigationScreen.id: (context) => MainNavigationScreen(),
        },
      ),
    );
  }
}
