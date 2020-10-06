import 'package:andina_protos/blocs/order_detail/order_detail.dart';
import 'package:andina_protos/repositories/order.repository.dart';
import 'package:andina_protos/screens/saleDetail.dart';
import 'package:andina_protos/blocs/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:andina_protos/models/packing.dart';
import 'package:andina_protos/widgets/common/image_decode.dart';
import 'package:andina_protos/models/sale.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetail extends StatefulWidget {
  final OrderRepository orderRepository;
  final int id;
  OrderDetail({Key key, this.orderRepository, this.id}) : assert(orderRepository != null), super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  
  OrderDetailBloc _orderDetailBloc;

  @override
  void initState() {
    _orderDetailBloc = OrderDetailBloc(orderRepository: widget.orderRepository);
    _orderDetailBloc.dispatch(FetchOrder(orderId: widget.id));
    super.initState();
  }

  @override
  void dispose() {
    _orderDetailBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text('Orden N°: ${widget.id}'),
       ),
       body: BlocBuilder(
        bloc: _orderDetailBloc,
        builder: (_, OrderDetailState state) {
          if(state is OrderDetailLoading){
            return Center(child: CircularProgressIndicator());
          }
          if(state is OrderDetailLoaded){
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Color.fromARGB(30, 0, 0, 0),
                          offset: Offset(0.0, 2.0),
                          spreadRadius: 0,
                          blurRadius: 10
                        )
                      ]
                    ),
                    child: Card(
                      child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${state.order.stateOrder.name}',
                              style: TextStyle(color: Colors.green, fontSize: 15, fontWeight: FontWeight.w600)
                            ),
                            SizedBox(height: 20.0,),
                            Text('Opciones de Envio: ${state.order.shipmentOption.name}'),
                            SizedBox(height: 10.0,),
                            Text('Dirección: ${state.order.branch.name} - ${state.order.branch.address}'),
                            SizedBox(height: 10.0,),
                            Text('Forma de pago: ${state.order.paymentOption.name}'),
                            SizedBox(height: 20.0,),
                            Center(child:Text('Productos', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18))),
                            Container(
                              margin: EdgeInsets.only(top: 25.0, bottom: 25.0),
                              height: 230.0,
                              child: ListView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: state.order.itemOrders.length,
                                itemBuilder: (BuildContext context,int index) {
                                if(state.order.itemOrders[index].unitSale.getPackingName() != '' && state.order.itemOrders[index].unitSale.getPackingName() != null){
                                  return _returnItemOrder(state, index, false);
                                }
                                else{
                                  return GestureDetector(
                                    child: _returnItemOrder(state, index, true),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context){
                                          return SaleDetail(sale: (state.order.itemOrders[index].unitSale as Sale), purchase: false,);
                                        }
                                      );
                                    },
                                  );
                                }
                                },
                              ),
                            ),          
                            _returnTotal(state),
                          ],
                        ),
                      )
                    ),
                  ),
                  _returnButtonRepete(state)
                ],
              ),
            );
          }
        }
      ) 
    );
  }
  
  Widget _returnItemOrder(OrderDetailLoaded state, int index, bool isSale){

    String name;
    String price;
    String image;
    if(isSale){
      name = (state.order.itemOrders[index].unitSale as Sale).name;
      price = 'Precio: ${(state.order.itemOrders[index].unitSale as Sale).price.toStringAsFixed(2)}\$';
      image = (state.order.itemOrders[index].unitSale as Sale).image;
    }
    else{
      name = (state.order.itemOrders[index].unitSale as Packing).product.name;
      price = 'Pkg: ${(state.order.itemOrders[index].unitSale as Packing).price.toStringAsFixed(2)}\$';
      image = (state.order.itemOrders[index].unitSale as Packing).product.img;
    }

     return Column(
      textDirection: TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ImageDecode(img:image, width: 150.0,),
        ),
        Text(
          name,
          style: TextStyle(color: isSale ? Colors.orange : Colors.grey)),
        Text(
          'Cantidad pedida: ${(state.order.itemOrders[index]).quantity}',
          style: TextStyle(color: Colors.grey)),
        Text(
          price,
          style: TextStyle(color: Colors.grey))
      ],
    );
  }

  Widget _returnTotal(OrderDetailLoaded state){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Total (con IVA):",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.0)),
            Text(
              "\$${state.order.total.toStringAsFixed(2)}",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.0))
          ],
        ),
        SizedBox(height: 10.0,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Total pagado:",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.0)
            ),
            Text(
              "\$${_calculateTotal(state)}",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.0)
            ),
          ],
        ),
      ],
    );
  }

  String _calculateTotal(OrderDetailLoaded state){
    return (state.order.total * state.order.percentPaymentOption * state.order.percentShipmentOption /10000).toStringAsFixed(2);
  }

  Widget _returnButtonRepete(OrderDetailLoaded state){
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ButtonTheme(
          minWidth: double.infinity * 0.5,
          height: 55.0,
          child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: Colors.grey,
              child: Text(
                'Repetir Pedido',
                style: TextStyle(fontSize: 20.0, fontFamily: 'arial'),
              ),
              onPressed: () {  
                CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
                cartBloc.dispatch(SetOrder(order: state.order));
                Navigator.pushNamed(context, '/checkout');
              }),
        ),
      ),
    );
  }
}