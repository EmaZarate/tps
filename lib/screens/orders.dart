import 'package:andina_protos/blocs/order/order.dart';
import 'package:andina_protos/repositories/customer.repository.dart';
import 'package:andina_protos/widgets/orders/order_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersScreen extends StatefulWidget {
  final CustomerRepository customerRepository;

  const OrdersScreen({Key key, this.customerRepository}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  CustomerRepository get _customerRepository => widget.customerRepository;

  OrderBloc _orderBloc;

  @override
  void initState() {
    _orderBloc = OrderBloc(customerRepository: _customerRepository);
    _orderBloc.dispatch(FetchOrders());
    super.initState();
  }

  @override
  void dispose() {
    _orderBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mis pedidos"),
        ),
        body: BlocProvider(
          builder: (BuildContext context) => _orderBloc,
          child: BlocBuilder(
            bloc: _orderBloc,
            builder: (BuildContext context, OrderState state) {
              if (state is OrderLoading || state is OrderEmpty) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is OrderLoaded) {
                return ListView.builder(
                  itemCount: state.orders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        OrderTile(
                          order: state.orders[index],
                          state: 1,
                        ),
                        _divider(),
                      ],
                    );
                  },
                );
              }

              return Center(
                child: Text('Ocurrio un error inesperado'),
              );
            },
          ),
        ));
  }

  _divider() {
    return Container(
      padding: const EdgeInsets.only(left: 70.0, right: 70.0),
      child: Divider(
        color: Colors.black,
      ),
    );
  }
}
