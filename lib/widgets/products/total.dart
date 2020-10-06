import 'package:andina_protos/blocs/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Total extends StatefulWidget {
  Total({Key key}) : super(key: key);

  _TotalState createState() => _TotalState();
}

class _TotalState extends State<Total> {
  @override
  Widget build(BuildContext context) {
    CartBloc _cartBloc = BlocProvider.of<CartBloc>(context);
    return BlocBuilder(
      bloc: _cartBloc,
      builder: (BuildContext context, CartState state) {
        if (state is CartEditing) {
          return _buildTotalInCart(state.order.total);
        }

        else{
          return _buildTotalInCart(0.0);
        }
      },
    );
  }

  Widget _buildTotalInCart(double total) {
    return Container(
      child: Text('\$${total.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 18.0, letterSpacing: 0.4)),
      alignment: Alignment.center,
    );
  }
}
