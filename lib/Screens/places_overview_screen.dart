import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Providers/places_provider.dart';
import '../Widgets/add_place.dart';
import '../Widgets/place_item.dart';
import '../Widgets/ErrorWidget.dart' as error;

class PlacesOverviewScreen extends StatefulWidget {
  static const id = 'PlacesOverviewScreen';
  const PlacesOverviewScreen({Key? key}) : super(key: key);

  @override
  State<PlacesOverviewScreen> createState() => _PlacesOverviewScreenState();
}

class _PlacesOverviewScreenState extends State<PlacesOverviewScreen> {
  @override
  late Future fetchplaces;
  bool firstTime = true;
  void initState() {
    final PlacesData = Provider.of<PlacesProvider>(context, listen: false);
    fetchplaces = PlacesData.fetchPlaces();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PlacesData = Provider.of<PlacesProvider>(context);
    final mediaQ = MediaQuery.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return AddPlace();
            },
            isScrollControlled: true,
          ).then((_) {
            Provider.of<ImagesProvider>(context, listen: false).clear();
          });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder(
        future: fetchplaces,
        builder: (context, snapshot) {
          print('h');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitWave(
                color: Colors.green,
                size: 50,
              ),
            );
          } else {
            return SafeArea(
              child: PlacesData.items.isEmpty
                  ? error.ErrorWidget(
                      title:
                          'انت لسه محطتش اي مكان, ممكن تبدأ تحط من الزرار اللي تحت ع اليمين',
                      mediaq: mediaQ,
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              mediaQ.orientation == Orientation.portrait
                                  ? 1
                                  : 3),
                      itemCount: PlacesData.items.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: index == PlacesData.items.length - 1
                              ? mediaQ.orientation == Orientation.portrait
                                  ? const EdgeInsets.all(40)
                                  : const EdgeInsets.only(
                                      top: 40, left: 40, right: 40)
                              : const EdgeInsets.only(
                                  top: 40, left: 40, right: 40),
                          child: PlaceItemWidget(
                            id: PlacesData.items[index].id,
                            title: PlacesData.items[index].name,
                            imageFile: PlacesData.items[index].image,
                          ),
                        );
                      },
                    ),
            );
          }
        },
      ),
    );
  }
}
