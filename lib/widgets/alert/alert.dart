import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  
  final String title;
  final List<String> messages;

  const Alert({Key key, this.title, this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Text(title),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: messages.map((String message){
          return Text(message);
        }).toList(),
        mainAxisSize: MainAxisSize.min
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
