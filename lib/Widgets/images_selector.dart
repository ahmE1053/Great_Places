import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../Providers/places_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class ImagesSelector extends StatelessWidget {
  const ImagesSelector({Key? key}) : super(key: key);
  Future<bool> pickAnImage(ImageSource imageSource, context) async {
    final ImagePicker _picker = ImagePicker();
    final image =
        await _picker.pickImage(source: imageSource, imageQuality: 30);
    print(image);
    if (image == null) {
      return false;
    }
    final imageFile = File(image.path);
    final appDirectory = await getApplicationDocumentsDirectory();
    final finalPath = '${appDirectory.path}/${image.name}';
    final finalImage = await imageFile.copy(finalPath);
    Provider.of<ImagesProvider>(context, listen: false)
        .addImage(finalImage.path);
    return true;
  }

  // late AnimationController _animationController;
  // late Animation<TextStyle> _animation;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   _animationController =
  //       AnimationController(vsync: this, duration: Duration(milliseconds: 600));
  //   _animation = Tween<TextStyle>(
  //     begin: const TextStyle(
  //       fontSize: 0,
  //       color: Colors.white,
  //     ),
  //     end: const TextStyle(
  //       fontSize: 10,
  //       color: Colors.red,
  //     ),
  //   ).animate(
  //     CurvedAnimation(
  //       parent: _animationController,
  //       curve: Curves.fastOutSlowIn,
  //     ),
  //   );
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final mediaQ = MediaQuery.of(context);
    final ImagesData = Provider.of<ImagesProvider>(context);
    return Container(
      // width: 500,
      height: mediaQ.orientation == Orientation.portrait
          ? mediaQ.size.height * 0.2
          : mediaQ.size.height * .2,
      margin: const EdgeInsets.all(20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ImagesData.imagesList.length + 1,
        itemBuilder: (context, index) {
          return index == ImagesData.imagesList.length
              ? mediaQ.orientation == Orientation.portrait
                  ? Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: ImagesData.isImagesListEmpty
                                ? Colors.red.withOpacity(0.5)
                                : Colors.white,
                            border: Border.all(
                              color: ImagesData.isImagesListEmpty
                                  ? Colors.red.withOpacity(0.5)
                                  : Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          width: 150,
                          margin: EdgeInsets.only(
                              bottom: ImagesData.isImagesListEmpty ? 10 : 0),
                          height: mediaQ.orientation == Orientation.portrait
                              ? ImagesData.isImagesListEmpty
                                  ? mediaQ.size.height * 0.175
                                  : mediaQ.size.height * .19
                              : ImagesData.isImagesListEmpty
                                  ? mediaQ.size.height * .37
                                  : mediaQ.size.height * .41,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (await pickAnImage(
                                          ImageSource.gallery, context) ==
                                      false) {
                                    Alert(
                                        context: context,
                                        title: 'Error',
                                        desc: 'No image was selected',
                                        buttons: [
                                          DialogButton(
                                            child: const Text(
                                              'Ok',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            color: Colors.green,
                                          )
                                        ]).show();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 45, vertical: 25),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Icon(Icons.insert_drive_file_rounded,
                                      color: ImagesData.isImagesListEmpty
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (await pickAnImage(
                                          ImageSource.camera, context) ==
                                      false) {
                                    Alert(
                                        context: context,
                                        title: 'Error',
                                        desc: 'No photo was taken',
                                        buttons: [
                                          DialogButton(
                                            child: const Text(
                                              'Ok',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            color: Colors.green,
                                          )
                                        ]).show();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 45, vertical: 25),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Icon(Icons.camera,
                                      color: ImagesData.isImagesListEmpty
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.fastOutSlowIn,
                          style: TextStyle(
                              fontSize: ImagesData.isImagesListEmpty ? 15 : 0,
                              color: Colors.red),
                          child: const Text(
                            'Select a Picture',
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: ImagesData.isImagesListEmpty
                                ? Colors.red.withOpacity(0.5)
                                : Colors.white,
                            border: Border.all(
                              color: ImagesData.isImagesListEmpty
                                  ? Colors.red.withOpacity(0.5)
                                  : Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          width: mediaQ.size.width * 0.32,
                          margin: EdgeInsets.only(
                              bottom: ImagesData.isImagesListEmpty ? 10 : 0),
                          height: mediaQ.orientation == Orientation.portrait
                              ? ImagesData.isImagesListEmpty
                                  ? mediaQ.size.height * 0.175
                                  : mediaQ.size.height * .19
                              : ImagesData.isImagesListEmpty
                                  ? mediaQ.size.height * .37
                                  : mediaQ.size.height * .41,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (await pickAnImage(
                                          ImageSource.gallery, context) ==
                                      false) {
                                    Alert(
                                        context: context,
                                        title: 'Error',
                                        desc: 'No image was selected',
                                        buttons: [
                                          DialogButton(
                                            child: const Text(
                                              'Ok',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            color: Colors.green,
                                          )
                                        ]).show();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 45, vertical: 25),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Icon(Icons.insert_drive_file_rounded,
                                      color: ImagesData.isImagesListEmpty
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (await pickAnImage(
                                          ImageSource.camera, context) ==
                                      false) {
                                    Alert(
                                        context: context,
                                        title: 'Error',
                                        desc: 'No photo was taken',
                                        buttons: [
                                          DialogButton(
                                            child: const Text(
                                              'Ok',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            color: Colors.green,
                                          )
                                        ]).show();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 45, vertical: 25),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Icon(Icons.camera,
                                      color: ImagesData.isImagesListEmpty
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.fastOutSlowIn,
                          style: TextStyle(
                              fontSize: ImagesData.isImagesListEmpty ? 15 : 0,
                              color: Colors.red),
                          child: const Text(
                            'Select a Picture',
                          ),
                        ),
                      ],
                    )
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      File(ImagesData.imagesList[index]),
                      width: 150,
                      fit: BoxFit.fill,
                    ),
                  ),
                );
        },
      ),
    );
  }
}
