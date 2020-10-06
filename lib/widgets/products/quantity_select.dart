import 'package:flutter/material.dart';

class QuantitySelect extends StatelessWidget {
  final double unitPrice;
  final int quantity;
  final bool displayTotal;
  final Function emitChangeQuantity;

  QuantitySelect(
      {@required this.unitPrice,
      @required this.emitChangeQuantity,
      this.quantity,
      this.displayTotal = true,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
            child: InkWell(
          onTap: () {
            if (quantity == 0) {
              emitChangeQuantity(0, context);
              return;
            }
            var newQuantity = quantity - 1;
            emitChangeQuantity(newQuantity, context);
          },
          child: Icon(
            Icons.remove,
          ),
        )),
        Container(
            child: Text(
              quantity.toString(),
              style: TextStyle(fontSize: 17.0),
            ),
            padding: const EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 5.0),
            decoration: BoxDecoration(
                color: Colors.white, border: Border.all(color: Colors.black))),
        Container(
          child: InkWell(
            onTap: () {
              var newQuantity = quantity + 1;
              emitChangeQuantity(newQuantity, context);
            },
            child: Icon(
              Icons.add,
            ),
          ),
        )
      ],
    );
  }
}
