import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Icon(
              MdiIcons.whatsapp,
              color: Colors.black45,
            ),
          ),
          InkWell(
            onTap: () => launch('https://wa.me/5493412460673'),
            child: Container(
              padding: const EdgeInsets.only(top: 5.0),
              alignment: Alignment.center,
              child: Text(
                'Contactanos',
                style: TextStyle(color: Colors.black45),
              ),
            ),
          )
        ],
      ),
    );
  }
}
