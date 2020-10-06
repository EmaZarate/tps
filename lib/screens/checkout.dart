import 'dart:async';

import 'package:andina_protos/blocs/cart/cart.dart';
import 'package:andina_protos/blocs/checkout/checkout.dart';
import 'package:andina_protos/blocs/profile/profile.dart';
import 'package:andina_protos/repositories/checkout.repository.dart';
import 'package:andina_protos/repositories/customer.repository.dart';
import 'package:andina_protos/widgets/checkout/cart_detail.dart';
import 'package:andina_protos/widgets/checkout/cart_list.dart';
import 'package:andina_protos/widgets/checkout/clean_cart.dart';
import 'package:andina_protos/widgets/checkout/expansion_panel_checkout.dart';
import 'package:andina_protos/widgets/checkout/generate_order.dart';
import 'package:andina_protos/widgets/checkout/total.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../helpers/customer_helper.dart';

class Checkout extends StatefulWidget {
  final CustomerRepository customerRepository;
  final CheckoutRepository checkoutRepository;

  Checkout(
      {Key key,
      @required this.customerRepository,
      @required this.checkoutRepository})
      : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  ProfileBloc _profileBloc;
  CheckoutBloc _checkoutBloc;
  Completer<void> _refreshCompleter;
  CustomerHelper _customerHelper;
  @override
  void initState() {
    _customerHelper = new CustomerHelper();
    _refreshCompleter = Completer<void>();
    _checkoutBloc = CheckoutBloc(
        checkoutRepository: widget.checkoutRepository,
        customerRepository: widget.customerRepository);
    _checkoutBloc.dispatch(LoadOptions());
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();

  }

  @override
  void dispose() {
    _checkoutBloc.dispose();
    super.dispose();
  }

  _clearCart() {
    
    CartBloc _cartBloc = BlocProvider.of<CartBloc>(context);
    _cartBloc.dispatch(ClearCart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Resumen de tu pedido'),
        ),
        body: BlocListener(
          bloc: _checkoutBloc,
          listener: (BuildContext context, CheckoutState state) {
            if (state is CheckoutLoaded) {
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
            }
          },
          child: BlocBuilder(
            bloc: _checkoutBloc,
            builder: (BuildContext context, CheckoutState state) {
              if (state is CheckoutUninitialized || state is CheckoutLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is CheckoutLoaded) {
                return RefreshIndicator(
                  onRefresh: () {
                    _checkoutBloc.dispatch(RefreshOptions());
                    return _refreshCompleter.future;
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          CartList(),
                          CleanCart(_clearCart),
                          Divider(),
                          ExpansionPanelCheckout(
                              shipmentOptions: state.shipmentOptions,
                              paymentOptions: state.paymentOptions,
                              branches: state.branches),
                          Divider(),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
                            child: Text(
                              'Resumen',
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Theme.of(context).primaryColorDark,
                              ),
                            ),
                          ),
                          CartDetail(),
                          GenerateOrder(),
                          Container(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              'Día de reparto asignado: ' + _customerHelper.returnShipmentDay((_profileBloc.currentState as ProfileLoaded).customer.shipmentDay),
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black,
                                  fontSize: 16.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }

              return Center(
                child: Text('Ocurrio un error inesperado'),
              );
            },
          ),
        ));
  }
}
