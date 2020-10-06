import 'package:andina_protos/blocs/packing/packing.dart';
import 'package:andina_protos/models/packing.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TypeProduct extends StatelessWidget {
  final List<Packing> packings;
  final PackingBloc packingBloc;
  final Function emitPackingSelected;

  TypeProduct(
      {@required this.packingBloc,
      @required this.packings,
      @required this.emitPackingSelected,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (packingBloc.currentState is SelectedPacking) {
      return FlatButton(
        child: Text(
          (packingBloc.currentState as SelectedPacking)
              .item
              .unitSale
              .getPackingName(),
          style: TextStyle(fontSize: 11.0),
        ),
        onPressed: () => {},
      );
    }

    else {
      return Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(100.0),
        child: IconButton(
          icon: Icon(MdiIcons.dnsOutline),
          onPressed: () {
            _settingModalBottomSheet(context);
          },
          tooltip: 'Seleccionar el empaque..',
        ),
      );
    }
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0)),
            height: (60.0 * packings.length),
            child: ListView.builder(
              itemCount: packings.length,
              itemBuilder: (bc, index) {
                return ListTile(
                  leading: Icon(Icons.keyboard_arrow_right),
                  title: Text(packings[index].name),
                  onTap: () {
                    this.emitPackingSelected(packings, packings[index].id);
                    Navigator.pop(bc);
                  },
                );
              },
            ),
          );
        });
  }
}
