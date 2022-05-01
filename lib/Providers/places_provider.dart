import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';

class Places {
  String id, address, name, description;
  List<dynamic> image;
  int isFavorite;
  // double latitude, longitude;
  Places({
    required this.id,
    required this.name,
    required this.description,
    // required this.latitude,
    // required this.longitude,
    required this.image,
    required this.address,
    this.isFavorite = 0,
  });
}

class ImagesProvider with ChangeNotifier {
  bool isImagesListEmpty = false;
  List<String> imagesList = [];
  void addImage(String path) {
    imagesList.add(path);
    if (isImagesListEmpty) {
      isImagesListEmpty = false;
    }
    notifyListeners();
  }

  void clear() {
    imagesList.clear();
    isImagesListEmpty = false;
  }

  void switchisImagesListEmpty(bool trueOrFalse) {
    isImagesListEmpty = trueOrFalse;
    notifyListeners();
  }
}

class PlacesProvider with ChangeNotifier {
  List<Places> _items = [];
  List<Places> _favoriteItems = [];
  List<Places> get items => _items;
  List<Places> get favoriteItems => _favoriteItems;

  Future<void> addItem(Places place) async {
    Map<String, dynamic> place_map = {
      'id': place.id,
      'title': place.name,
      'image': json.encode(place.image),
      'description': place.description,
      'address': place.address,
      'favorite': place.isFavorite,
    };
    await DBHelper.insert(place_map);
    _items.add(place);
    notifyListeners();
  }

  Places findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> changeIsFavorite(Places place) async {
    if (place.isFavorite == 0) {
      await DBHelper.changeFavorite(1, place.id).then((value) {
        place.isFavorite = 1;
        _favoriteItems.add(place);
      });
    } else {
      await DBHelper.changeFavorite(0, place.id).then((value) {
        place.isFavorite = 0;
        _favoriteItems.remove(place);
      });
    }
    notifyListeners();
  }

  Future<void> fetchPlaces() async {
    final dataList = await DBHelper.getData();
    try {
      _items = dataList
          .map(
            (e) => Places(
              description: e['description'],
              id: e['id'],
              name: e['title'],
              image: json.decode(e['image']),
              address: e['address'],
              isFavorite: e['favorite'],
            ),
          )
          .toList();
    } catch (error) {
      print(error);
    }
    fetchFavoritePlaces();
    // notifyListeners();
  }

  Future<void> fetchFavoritePlaces() async {
    print('d');
    var dataList = await DBHelper.getData();
    dataList = dataList.where((element) => element['favorite'] == 1).toList();
    try {
      _favoriteItems = dataList.map((e) {
        return Places(
          description: e['description'],
          id: e['id'],
          name: e['title'],
          image: json.decode(e['image']),
          address: e['address'],
          isFavorite: e['favorite'],
        );
      }).toList();
      print('done');
    } catch (error) {
      print('Favorite: $error');
    }
    // notifyListeners();
  }

  void deleteItem(Places place) {
    _items.remove(place);
    notifyListeners();
  }
}
