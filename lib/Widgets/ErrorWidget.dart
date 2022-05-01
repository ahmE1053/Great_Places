import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  final title;
  const ErrorWidget({
    required this.title,
    Key? key,
    required this.mediaq,
  }) : super(key: key);

  final MediaQueryData mediaq;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/1.png',
              height: mediaq.orientation == Orientation.portrait
                  ? mediaq.size.height * 0.5
                  : mediaq.size.height * 0.4,
              width: mediaq.orientation == Orientation.portrait
                  ? mediaq.size.width * 0.8
                  : mediaq.size.width * 0.3,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 30,
            ),
            FittedBox(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'LibreBodoni'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
