import 'package:flutter/material.dart';

class CleanCart extends StatelessWidget {
  final Function clearCart;

  const CleanCart(
    this.clearCart, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 5.0),
      alignment: Alignment.topRight,
      child: FlatButton(
        child: Text(
          'Vaciar carrito',
          style: TextStyle(
              color: Color.fromARGB(255, 220, 0, 0),
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
              fontSize: 14.0),
        ),
        onPressed: () {
          clearCart();
        },
      ),
    );
  }
}
