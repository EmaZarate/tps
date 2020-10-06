import 'package:andina_protos/blocs/cart/cart.dart';
import 'package:andina_protos/blocs/profile/profile.dart';
import 'package:andina_protos/models/order.dart';
import 'package:andina_protos/widgets/alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
import 'package:url_launcher/url_launcher.dart';

class GenerateOrder extends StatefulWidget {
  GenerateOrder({Key key}) : super(key: key);
  _GenerateOrderState createState() => _GenerateOrderState();
}

class _GenerateOrderState extends State<GenerateOrder> {
  var mp = MP(DotEnv().env['clientId'], DotEnv().env['clientSecret']);
  var mercadoPagoNotification = DotEnv().env['mercadoPagoNotification'];
  var mercadoPagoBackurlSuccess = DotEnv().env['mercadoPagoBackurlSuccess'];
  var mercadoPagobackurlPending = DotEnv().env['mercadoPagobackurlPending'];
  var mercadoPagoBackurlFailure = DotEnv().env['mercadoPagoBackurlFailure'];
  var itemsMaped;
  ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    CartBloc _cartBloc = BlocProvider.of<CartBloc>(context);

    return BlocBuilder(
      bloc: _cartBloc,
      builder: (BuildContext context, CartState state) {
        if (state is CartFinished) {
          _launchMercadoPago(state.orderID, _cartBloc);
        }
        if (state is CartEditing || state is CartFinished) {
          return Container(
            padding: const EdgeInsets.only(top: 50.0, left: 20.0, bottom: 50.0),
            child: RaisedButton(
              onPressed: () => _generateOrder(state, _cartBloc),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Generar pedido',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  Icon(
                    Icons.arrow_right,
                    size: 30.0,
                  )
                ],
              ),
              color: Theme.of(context).primaryColor,
              elevation: 3.0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            ),
          );
        } else {
          return Center(
            child: Text('Ocurrio un error inesperado'),
          );
        }
      },
    );
  }

  void _launchMercadoPago(int id, CartBloc cartBloc) async {
    var preference = {
      "items": [...this.itemsMaped],
      "notification_url":
          "$mercadoPagoNotification",
      "external_reference": "$id",
      "back_urls": {
        "success":
            "$mercadoPagoBackurlSuccess",
        "pending":
            "$mercadoPagobackurlPending",
        "failure":
            "$mercadoPagoBackurlFailure"
      },
    };

    var result = await mp.createPreference(preference);
    var url = result["response"]["init_point"];
    await launch(url);
    cartBloc.dispatch(InitializeCart());
    Navigator.pushNamed(context, '/dashboard');
  }

  void _generateOrder(CartState state, CartBloc cartBloc) async {
    List<String> messages =  new List<String>();
    int minimumLimit = (_profileBloc.currentState as ProfileLoaded).customer.minimumLimit;
    this.itemsMaped = (state as CartEditing).order.itemOrders.map((item) {
      return {
        "title": item.unitSale.getProductName(),
        "quantity": item.quantity,
        "currency_id": "ARS",
        "unit_price": item.unitSale.getPrice()
      };
    }).toList();

    this.itemsMaped = this.itemsMaped.where((item) => item["quantity"] != 0).toList();
    
    if(this.itemsMaped.length == 0){
       messages.add('Debe agregar como mínimo un producto');
    }
    else if(isTheRightMinimumLimit(state, minimumLimit)){
      messages.add('La compra debe ser mayor a \$${minimumLimit}');
    }
    else {
      messages.addAll(returnMessagesErrorsForm((state as CartEditing).order));
    }

    if(messages.isEmpty){
       cartBloc.dispatch(FinishOrder());
    }
    else{
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return Alert(title: 'Error',messages: messages);
          });
    }
  }
  
  bool isTheRightMinimumLimit(CartState state, int minimumLimit){
    return ((state as CartEditing).order.total < minimumLimit.toDouble());
  }

  List<String> returnMessagesErrorsForm(Order order) {
    List<String> messagesErrorForm =  new List<String>();
    if (order.shipmentOption.id == null) messagesErrorForm.add('Ingrese una opción de envío');
    if (order.paymentOption.id == null)  messagesErrorForm.add('Ingrese una opción de pago');
    if (order.branch.id == null)  messagesErrorForm.add('Ingrese una sucursal');
    return messagesErrorForm;
  }
}
