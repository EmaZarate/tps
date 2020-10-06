import 'dart:convert';
import 'package:flutter/material.dart';

class PictureProfile extends StatelessWidget {
  final String image;
  const PictureProfile({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      width: 150.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Colors.teal[200],
        border: Border.all(color: Colors.teal[700], width: 3.0),
        image: DecorationImage(
          image: MemoryImage(base64.decode(image)),
          fit: BoxFit.fill
        ),
      ),
    );
  }
}