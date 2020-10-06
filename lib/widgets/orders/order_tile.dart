import 'package:andina_protos/blocs/cart/cart.dart';
import 'package:andina_protos/models/order.dart';
import 'package:andina_protos/models/state_order.dart';
import 'package:andina_protos/widgets/alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OrderTile extends StatelessWidget {

  final int state;
  final Order order;
  const OrderTile({this.order, this.state, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 5.0),
      isThreeLine: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Orden N°: ${order.id}"), _returnState(order.stateOrder)],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Total (con IVA): \$${order.total.toStringAsFixed(2)}"),
              Text("Total pagado: \$${(order.total * order.percentPaymentOption * order.percentShipmentOption /10000).toStringAsFixed(2)}"),
            ],
          ),
          Row(
            children: <Widget>[
              IconButton(
                tooltip: 'Repetir pedido',
                icon: Icon(MdiIcons.restore, color: Colors.teal[700]), 
                onPressed: () {
                  CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
                  cartBloc.dispatch(SeachOrder(orderId: order.id));
                  Navigator.pushNamed(context, '/checkout');
                },)
              , 
              IconButton(
                tooltip: 'Ver detalle',
                icon: Icon(MdiIcons.fileDocumentBoxOutline, color: Colors.teal[700],),
                onPressed: () => Navigator.pushNamed(context, '/orderDetail', arguments: order.id)
                ),
                
              ],
          )
        ],
      ),
    );
  }

  void detailOrder(Order order, BuildContext context){

    List<String> items = new List<String>();
    for (var i = 0; i < order.itemOrders.length; i++) {
      items.add(order.itemOrders[i].unitSale.getProductName());
    } 

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {   
        return Alert(title: "Detalle",messages:items);
      });
  }

  _returnState(StateOrder stateOrder){
    if(stateOrder.id == 1){
      return Text(stateOrder.name, style: TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold
        ),);
    }
    if(state == 1) {
      return Text(stateOrder.name, style: TextStyle(
        color:Colors.green,
        fontWeight: FontWeight.bold
      ));
    }

    return Text(stateOrder.name, style: TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold
    ));
  }
}
