import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'images_selector.dart';
import '../Providers/places_provider.dart';
import '../helpers/db_helper.dart';

class AddPlace extends StatefulWidget {
  const AddPlace({Key? key}) : super(key: key);

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  TextDirection getDirection(String v) {
    final string = v.trim();
    if (string.isEmpty) return TextDirection.ltr;
    final firstUnit = string.codeUnitAt(0);
    if (firstUnit > 0x0600 && firstUnit < 0x06FF ||
        firstUnit > 0x0750 && firstUnit < 0x077F ||
        firstUnit > 0x07C0 && firstUnit < 0x07EA ||
        firstUnit > 0x0840 && firstUnit < 0x085B ||
        firstUnit > 0x08A0 && firstUnit < 0x08B4 ||
        firstUnit > 0x08E3 && firstUnit < 0x08FF ||
        firstUnit > 0xFB50 && firstUnit < 0xFBB1 ||
        firstUnit > 0xFBD3 && firstUnit < 0xFD3D ||
        firstUnit > 0xFD50 && firstUnit < 0xFD8F ||
        firstUnit > 0xFD92 && firstUnit < 0xFDC7 ||
        firstUnit > 0xFDF0 && firstUnit < 0xFDFC ||
        firstUnit > 0xFE70 && firstUnit < 0xFE74 ||
        firstUnit > 0xFE76 && firstUnit < 0xFEFC ||
        firstUnit > 0x10800 && firstUnit < 0x10805 ||
        firstUnit > 0x1B000 && firstUnit < 0x1B0FF ||
        firstUnit > 0x1D165 && firstUnit < 0x1D169 ||
        firstUnit > 0x1D16D && firstUnit < 0x1D172 ||
        firstUnit > 0x1D17B && firstUnit < 0x1D182 ||
        firstUnit > 0x1D185 && firstUnit < 0x1D18B ||
        firstUnit > 0x1D1AA && firstUnit < 0x1D1AD ||
        firstUnit > 0x1D242 && firstUnit < 0x1D244) {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }

  final ValueNotifier<TextDirection> _textDirName =
      ValueNotifier(TextDirection.ltr);
  final ValueNotifier<TextDirection> _textDirAddress =
      ValueNotifier(TextDirection.ltr);
  final _formKey = GlobalKey<FormState>();
  final _addressText = TextEditingController();
  final _nameText = TextEditingController();
  final _descriptionText = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final mediaQ = MediaQuery.of(context);
    final PlacesData = Provider.of<PlacesProvider>(context);
    final ImagesData = Provider.of<ImagesProvider>(context);
    print(mediaQ.textScaleFactor);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 0 + mediaQ.viewInsets.bottom),
        child: SingleChildScrollView(
          child: SizedBox(
            height: mediaQ.orientation == Orientation.portrait
                ? mediaQ.textScaleFactor >= 1.2
                    ? mediaQ.size.height * 0.8
                    : mediaQ.size.height * 0.6
                : mediaQ.size.height * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const ImagesSelector(),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: Form(
                            key: _formKey,
                            child: mediaQ.orientation == Orientation.portrait
                                ? Column(
                                    children: [
                                      Expanded(
                                        child: ValueListenableBuilder<
                                            TextDirection>(
                                          valueListenable: _textDirName,
                                          builder: (context, value, child) =>
                                              Align(
                                            alignment: Alignment.centerLeft,
                                            child: SizedBox(
                                              width: mediaQ.size.width * 0.5,
                                              child: TextFormField(
                                                controller: _nameText,
                                                textDirection: value,
                                                textInputAction:
                                                    TextInputAction.next,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter some value';
                                                  }
                                                },
                                                onChanged: (input) {
                                                  if (input.trim().length < 2) {
                                                    final dir =
                                                        getDirection(input);
                                                    if (dir != value) {
                                                      _textDirName.value = dir;
                                                    }
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  errorStyle:
                                                      TextStyle(height: 0.5),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  label: const Text('Name'),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.red),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    borderSide:
                                                        const BorderSide(
                                                            width: 2,
                                                            color:
                                                                Colors.green),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.red),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: ValueListenableBuilder<
                                            TextDirection>(
                                          valueListenable: _textDirAddress,
                                          builder: (context, value, child) =>
                                              TextFormField(
                                            textDirection: value,
                                            onChanged: (value) {
                                              if (value.trim().length < 2) {
                                                final dir = getDirection(value);
                                                if (dir != value) {
                                                  _textDirAddress.value = dir;
                                                }
                                              }
                                            },
                                            controller: _addressText,
                                            maxLines: 2,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(14),
                                              errorStyle:
                                                  TextStyle(height: 0.5),
                                              filled: true,
                                              fillColor: Colors.white,
                                              label: const Text('Address'),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                  color: Colors.green,
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Colors.red),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: const BorderSide(
                                                    width: 2,
                                                    color: Colors.green),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Colors.red),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter some value';
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: ValueListenableBuilder<
                                            TextDirection>(
                                          valueListenable: _textDirAddress,
                                          builder: (context, value, child) =>
                                              TextFormField(
                                            textDirection: value,
                                            onChanged: (value) {
                                              if (value.trim().length < 2) {
                                                final dir = getDirection(value);
                                                if (dir != value) {
                                                  _textDirAddress.value = dir;
                                                }
                                              }
                                            },
                                            controller: _descriptionText,
                                            maxLines: 5,
                                            cursorColor: Colors.green,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              label: const Text(
                                                  'Describe the place'),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                  color: Colors.green,
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Colors.red),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: const BorderSide(
                                                    width: 2,
                                                    color: Colors.green),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Colors.red),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter some value';
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: ValueListenableBuilder<
                                                  TextDirection>(
                                                valueListenable: _textDirName,
                                                builder:
                                                    (context, value, child) =>
                                                        Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: SizedBox(
                                                    width:
                                                        mediaQ.size.width * 0.5,
                                                    child: TextFormField(
                                                      controller: _nameText,
                                                      textDirection: value,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Please enter some value';
                                                        }
                                                      },
                                                      onChanged: (input) {
                                                        if (input
                                                                .trim()
                                                                .length <
                                                            2) {
                                                          final dir =
                                                              getDirection(
                                                                  input);
                                                          if (dir != value) {
                                                            _textDirName.value =
                                                                dir;
                                                          }
                                                        }
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        label:
                                                            const Text('Name'),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 2,
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                        focusedErrorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: ValueListenableBuilder<
                                                  TextDirection>(
                                                valueListenable:
                                                    _textDirAddress,
                                                builder:
                                                    (context, value, child) =>
                                                        TextFormField(
                                                  textDirection: value,
                                                  onChanged: (value) {
                                                    if (value.trim().length <
                                                        2) {
                                                      final dir =
                                                          getDirection(value);
                                                      if (dir != value) {
                                                        _textDirAddress.value =
                                                            dir;
                                                      }
                                                    }
                                                  },
                                                  controller: _addressText,
                                                  maxLines: 2,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    label:
                                                        const Text('Address'),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      borderSide: BorderSide(
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.red),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 2,
                                                              color:
                                                                  Colors.green),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.red),
                                                    ),
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Please enter some value';
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: mediaQ.size.width * 0.05,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: ValueListenableBuilder<
                                            TextDirection>(
                                          valueListenable: _textDirAddress,
                                          builder: (context, value, child) =>
                                              TextFormField(
                                            textDirection: value,
                                            onChanged: (value) {
                                              if (value.trim().length < 2) {
                                                final dir = getDirection(value);
                                                if (dir != value) {
                                                  _textDirAddress.value = dir;
                                                }
                                              }
                                            },
                                            controller: _descriptionText,
                                            maxLines: 5,
                                            cursorColor: Colors.green,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              label: const Text(
                                                  'Describe the place'),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                  color: Colors.green,
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Colors.red),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: const BorderSide(
                                                    width: 2,
                                                    color: Colors.green),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Colors.red),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter some value';
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (ImagesData.imagesList.isEmpty) {
                      ImagesData.switchisImagesListEmpty(true);
                      return;
                    }
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });

                    await PlacesData.addItem(
                      Places(
                        description: _descriptionText.value.text,
                        image: ImagesData.imagesList,
                        name: _nameText.value.text,
                        id: DateTime.now().toString(),
                        address: _addressText.value.text,
                      ),
                    );
                    PlacesData.fetchPlaces();
                    ImagesData.clear();
                    Navigator.pop(context);
                    isLoading = false;
                  },
                  child: isLoading
                      ? const SpinKitHourGlass(color: Colors.green)
                      : Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.only(bottom: 20, top: 20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            color: Colors.green.withOpacity(0.8),
                          ),
                          child: const Text(
                            'Add',
                            style: TextStyle(fontSize: 30, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
