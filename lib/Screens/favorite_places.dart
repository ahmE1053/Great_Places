import 'package:flutter/material.dart';
import 'package:great_places/Providers/places_provider.dart';
import 'package:provider/provider.dart';
import '../Widgets/ErrorWidget.dart' as error;

import '../Widgets/place_item.dart';

class FavoritePlacesScreen extends StatelessWidget {
  static const id = 'FavoritePlaces';
  const FavoritePlacesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('dd');
    final FavoritesData = Provider.of<PlacesProvider>(context);
    final mediaQ = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          // margin: EdgeInsets.all(40),
          child: FavoritesData.favoriteItems.isEmpty
              ? error.ErrorWidget(
                  title: 'لم يتم اختيار اي اماكن مفضلة',
                  mediaq: mediaQ,
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          mediaQ.orientation == Orientation.portrait ? 1 : 3),
                  itemCount: FavoritesData.favoriteItems.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: index == FavoritesData.favoriteItems.length - 1
                          ? mediaQ.orientation == Orientation.portrait
                              ? const EdgeInsets.all(40)
                              : const EdgeInsets.only(
                                  top: 40, left: 40, right: 40)
                          : const EdgeInsets.only(top: 40, left: 40, right: 40),
                      child: PlaceItemWidget(
                        id: FavoritesData.favoriteItems[index].id,
                        title: FavoritesData.favoriteItems[index].name,
                        imageFile: FavoritesData.favoriteItems[index].image,
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
