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
          return _buildTotalWidget(state.order.total);
        }
        else{
          return _buildTotalWidget(0.0);
        }
      },
    );
  }

  Widget _buildTotalWidget(double total) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
      child: Text(
        'Total: \$${total.toStringAsFixed(2)}',
        style: TextStyle(color: Colors.black, fontSize: 20.0),
      ),
    );
  }
}
