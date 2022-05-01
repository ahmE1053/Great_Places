import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Screens/place_details_screen.dart';

class PlaceItemWidget extends StatelessWidget {
  final String title, id;
  final List<dynamic> imageFile;
  const PlaceItemWidget(
      {Key? key,
      required this.title,
      required this.imageFile,
      required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(id);
    final mediaQ = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, PlaceDetailsScreen.id,
            arguments: [id, 'all']);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Hero(
              tag: id,
              child: Image.file(
                File(imageFile[0]),
                width: mediaQ.size.width * 0.9,
                height: mediaQ.size.height,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
