import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:great_places/Providers/favorite_provider.dart';
import 'package:great_places/Providers/places_provider.dart';
import 'package:provider/provider.dart';

class PlaceDetailsScreen extends StatelessWidget {
  static const id = 'PlaceDetailsScreen';
  const PlaceDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQ = MediaQuery.of(context);
    final itemId = ModalRoute.of(context)!.settings.arguments as List<String>;
    final placesData = Provider.of<PlacesProvider>(context);
    final ItemData = placesData.findById(itemId[0]);
    print(itemId[0]);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.green,
              pinned: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    backgroundColor:
                        ItemData.isFavorite == 1 ? Colors.red : Colors.black38,
                    child: IconButton(
                      onPressed: () async {
                        await placesData.changeIsFavorite(ItemData);
                        print(ItemData.isFavorite);
                      },
                      icon: Icon(
                        ItemData.isFavorite == 1
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
              expandedHeight: mediaQ.orientation == Orientation.portrait
                  ? mediaQ.size.height * 0.4
                  : mediaQ.size.height * 0.5,
              flexibleSpace: FlexibleSpaceBar(
                background: CarouselSlider(
                  options: CarouselOptions(
                      height: mediaQ.orientation == Orientation.portrait
                          ? mediaQ.size.height * 0.4
                          : mediaQ.size.height * 0.5,
                      // enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      viewportFraction: 1,
                      padEnds: false),
                  items: ItemData.image
                      .map(
                        (e) => Stack(
                          children: [
                            SizedBox(
                              // margin: EdgeInsets.symmetric(horizontal: 10),
                              // width: mediaQ.size.width * 1,
                              child: Hero(
                                tag: itemId[0],
                                child: Image.file(
                                  File(e),
                                  height: double.infinity,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate(
              [
                Container(
                  margin: EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ItemData.name,
                        style: const TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'tapestry',
                            fontStyle: FontStyle.normal),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        'Located At',
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.normal),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        ItemData.address,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: 30,
                          fontFamily: 'LibreBodoni',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Divider(
                        color: Colors.black38,
                        thickness: 2,
                        height: 50,
                      ),
                      Text(
                        ItemData.description,
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black.withOpacity(0.7),
                            fontFamily: 'LibreBodoni',
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
