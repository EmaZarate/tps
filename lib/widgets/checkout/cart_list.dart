import 'package:andina_protos/blocs/cart/cart.dart';
import 'package:andina_protos/models/packing.dart';
import 'package:andina_protos/models/sale.dart';
import 'package:andina_protos/widgets/checkout/product_detail_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartList extends StatefulWidget {
  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  CartBloc _cartBloc;

  @override
  void initState() {
    _cartBloc = BlocProvider.of<CartBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _cartBloc,
        builder: (BuildContext context, CartState state) {
          if (state is CartEditing) {
            return Container(
              height: MediaQuery.of(context).size.height / 2 - 40,
              child: state.order.itemOrders.length > 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: state.order.itemOrders.length,
                      itemBuilder: (context, index) {
                        if(state.order.itemOrders[index].unitSale.getPackingName() != '' && state.order.itemOrders[index].unitSale.getPackingName() != null){
                           return ProductDetailTile(
                            product: ((state.order.itemOrders[index].unitSale) as Packing).product,
                            item: state.order.itemOrders[index],
                            cartBloc: _cartBloc);
                        }
                        else{
                           return ProductDetailTile(
                            sale: (state.order.itemOrders[index].unitSale) as Sale,
                            item: state.order.itemOrders[index],
                            cartBloc: _cartBloc);
                        }                       
                      },
                    )
                  : Center(
                      child: Text('El carrito está vacío'),
                    ),
            );
          } else {
            //state is CartUninitialized
            return Container();
          }
        },
      );
  }
}
