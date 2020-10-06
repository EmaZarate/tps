import 'package:andina_protos/blocs/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartDetail extends StatelessWidget {
  const CartDetail({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartBloc _cartBloc = BlocProvider.of<CartBloc>(context);

    return BlocBuilder(
      bloc: _cartBloc,
      builder: (BuildContext context, CartState state) {
        if (state is CartEditing) {
          return Column(
            children: <Widget>[
              _buildTotal(state),
              _buildDiscounts(state),
              _buildTotalWithDiscounts(state),
              Divider(
                color: Colors.black54,
                height: 2.0,
              ),
              _buildTotalToPay(state),
            ],
          );
        }
        if(state is CartFinished){
          return Container();
        }
        else{
          return Center(child: Text('Ocurrio un error inesperado'),);
        }
      },
    );
  }

  Container _buildTotalToPay(CartEditing state) {
    final double totalToPay = _calculateTotalToPay(state);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Total a pagar:',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          Text(
            '\$${totalToPay.toStringAsFixed(2)}',
            style: TextStyle(
                fontSize: 19.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          )
        ],
      ),
    );
  }

  double _calculateTotalToPay(CartEditing state) {
    final double shipmentCost = _calculateDiscountCost(state);
    final double total = state.order.total + shipmentCost;
    return (total * (state.order.paymentOption.percent ?? 100.0) / 100) ?? total;
  }

  Container _buildTotalWithDiscounts(CartEditing state) {
    final double shipmentCost = _calculateDiscountCost(state);
    final double total = state.order.total + shipmentCost;
    total.toStringAsFixed(2);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Total del pedido:',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 15.0),
          )
        ],
      ),
    );
  }



  Container _buildDiscounts(CartEditing state) {
    final double shipmentCost = _calculateDiscountCost(state);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Descuento:',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
             '\$${shipmentCost.toStringAsFixed(2)}',
            style: TextStyle(
                fontSize: 15.0,
                color: shipmentCost <= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  double _calculateDiscountCost(CartEditing state) {
    return (state.order.total * (state.order.shipmentOption.percent ?? 100.0) / 100.0 - state.order.total);
  }

  Container _buildTotal(CartEditing state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Precio total:',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            '\$${state.order.total.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 15.0),
          )
        ],
      ),
    );
  }
}
