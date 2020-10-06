import 'package:flutter/material.dart';
import 'dart:convert';

class ImageDecode extends StatelessWidget {

  final String img;
  final double width;

  const ImageDecode({Key key, this.img, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: img != null ?  MemoryImage(base64.decode(_returnBase64Image(img))) : new ExactAssetImage('assets/final.png'),
          fit: BoxFit.contain,
        ),
      )
    );
  }

  String _returnBase64Image(String imgBase){
    return imgBase.split(",")[1];
  }
}