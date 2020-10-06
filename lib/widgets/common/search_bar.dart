import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final Function callback;
  final String hintText;

  const SearchBar({this.callback, this.hintText});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0,),
      child: Row(
        
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width / 1.7,
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(),
                ),
              )),
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 35.0,
            onPressed: () {
              widget.callback(_searchController.text);
              //Dismiss keyboard
              FocusScope.of(context).requestFocus(new FocusNode());
            },
          )
        ],
      ),
    );
  }
}
