import 'package:flutter/material.dart';

class Picture extends StatelessWidget {
  final DecorationImage image;
  Picture({this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170.0,
      height: 170.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(image: image),
    );
  }
}
