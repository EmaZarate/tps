import 'package:flutter/material.dart';

class MenuOption extends StatelessWidget {
  final String title;
  final IconData icon;

  MenuOption({this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  // Theme.of(context).primaryColorLight,
                  // Colors.orange[100],
                  // Colors.orange[200],
                  // Colors.orange[300]
                  Colors.orange.withOpacity(0.5),
                  Colors.orange.withOpacity(0.7),
                  Colors.orange.withOpacity(0.9)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.5, 0.7, 0.9])),
        width: 150.0,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                size: 100.0,
                // color: Colors.black45,
                // color: Theme.of(context).primaryColor
                color: Colors.black54,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  title,
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
