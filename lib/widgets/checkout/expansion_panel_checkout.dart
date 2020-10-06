import 'package:andina_protos/blocs/cart/cart.dart';
import 'package:andina_protos/models/payment_option.dart';
import 'package:andina_protos/models/shipment_option.dart';
import 'package:andina_protos/models/branch.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Item {
  bool isExpanded;
  final String header;
  final List<ItemRadio> items;
  final IconData iconpic;
  Function callback;
  Function getSelected;

  Item(
      {this.isExpanded,
      this.items,
      this.header,
      this.iconpic,
      this.callback,
      this.getSelected});
}

class ItemRadio {
  bool isSelected;
  int value;
  String title;
  int groupValue;

  ItemRadio({this.isSelected, this.value, this.title, this.groupValue});
}

class ExpansionPanelCheckout extends StatefulWidget {
  final List<ShipmentOption> shipmentOptions;
  final List<PaymentOption> paymentOptions;
  final List<Branch> branches;

  ExpansionPanelCheckout(
      {Key key,
      @required this.shipmentOptions,
      @required this.paymentOptions,
      @required this.branches})
      : super(key: key);

  _ExpansionPanelCheckoutState createState() => _ExpansionPanelCheckoutState();
}

class _ExpansionPanelCheckoutState extends State<ExpansionPanelCheckout> {
  List<ItemRadio> shipmentOptions;
  List<ItemRadio> paymentOptions;
  List<ItemRadio> branchOptions;

  _selectShipmentOption(CartBloc cartBloc, int id) {
    final ShipmentOption shipmentOption =
        widget.shipmentOptions.firstWhere((so) => so.id == id);
    cartBloc.dispatch(SelectShipmentOption(shipmentOption: shipmentOption));
  }

  _selectPaymentOption(CartBloc cartBloc, int id) {
    final PaymentOption paymentOption =
        widget.paymentOptions.firstWhere((po) => po.id == id);
    cartBloc.dispatch(SelectPaymentOption(paymentOption: paymentOption));
  }

  // _selectBranchOption(CartBloc cartBloc, int id) {
  //   final Branch branch = widget.branches.firstWhere((br) => br.id == id);
  //   cartBloc.dispatch(SelectBranchOption(branchOption: branch));
  // }

  _getShipmentSelected(CartEditing state) {
    return state.order.shipmentOption.id ?? 0;
  }

  _getPaymentSelected(CartEditing state) {
    return state.order.paymentOption.id ?? 0;
  }

  // _getBranchSelected(CartEditing state) {
  //   return state.order.branch.id ?? 0;
  // }

  @override
  void initState() {
    shipmentOptions = _mapShipmentOptionsToItemRadio(widget.shipmentOptions);
    paymentOptions = _mapPaymentOptionsToItemRadio(widget.paymentOptions);
    branchOptions = _mapBranchOptionsToItemRadio(widget.branches);
    items = [
      Item(
        header: 'Opciones de envío',
        isExpanded: false,
        items: shipmentOptions,
        iconpic: MdiIcons.truckFast,
        callback: _selectShipmentOption,
        getSelected: _getShipmentSelected,
      ),
      Item(
        header: 'Opciones de pago',
        isExpanded: false,
        items: paymentOptions,
        iconpic: MdiIcons.homeCurrencyUsd,
        callback: _selectPaymentOption,
        getSelected: _getPaymentSelected,
      ),
      // Item(
      //   header: 'Elegir Sucursal',
      //   isExpanded: false,
      //   items: branchOptions,
      //   iconpic: MdiIcons.home,
      //   callback: _selectBranchOption,
      //   getSelected: _getBranchSelected,
      // )
    ];
    CartBloc _cartBloc = BlocProvider.of<CartBloc>(context);
    _cartBloc.dispatch(SelectBranchOption(branchOption: widget.branches[0]));
    super.initState();
  }

  List<Item> items;

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    CartBloc _cartBloc = BlocProvider.of<CartBloc>(context);
    _cartBloc.dispatch(SelectBranchOption(branchOption: widget.branches[0]));
    return BlocBuilder(
      bloc: _cartBloc,
      builder: (BuildContext context, CartState state) {
        if (state is CartEditing) {
          return ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                items[index].isExpanded = !items[index].isExpanded;
              });
            },
            children: items.map((Item item) {
              return ExpansionPanel(
                  canTapOnHeader: true,
                  headerBuilder: (context, expanded) {
                    return ListTile(
                      leading: Icon(
                        item.iconpic,
                        color: Theme.of(context).primaryColor,
                        size: 40.0,
                      ),
                      title: Text(
                        item.header,
                        style: TextStyle(
                            fontSize: 21.0, color: Colors.grey.shade800),
                      ),
                    );
                  },
                  body: _constructBody(item, _cartBloc, state),
                  isExpanded: item.isExpanded);
            }).toList(),
          );
        }
        if(state is CartFinished){
          return Container();
        } else {
          return Center(
            child: Text('Ocurrio un error inesperado'),
          );
        }
      },
    );
  }

  Widget _constructBody(Item item, CartBloc _cartBloc, CartEditing state) {
    return Column(
        children: item.items.map((i) {
      return RadioListTile(
        groupValue: item.getSelected(state),
        title: Text(
          i.title,
          style: TextStyle(fontSize: 16.0),
        ),
        activeColor: Colors.blueAccent,
        value: i.value,
        onChanged: (val) {
          // setState(() {
          //   item.items.forEach((it) => it.groupValue = val);
          // });
          item.callback(_cartBloc, val);
        },
      );
    }).toList());
  }

  List<ItemRadio> _mapShipmentOptionsToItemRadio(
      List<ShipmentOption> shipmentOptions) {
    return shipmentOptions
        .map((so) => ItemRadio(
            groupValue: shipmentOptions[0].id,
            isSelected: false,
            title: so.name,
            value: so.id))
        .toList();
  }

  List<ItemRadio> _mapPaymentOptionsToItemRadio(
      List<PaymentOption> paymentOptions) {
    return paymentOptions
        .map((po) => ItemRadio(
            groupValue: paymentOptions[0].id,
            isSelected: false,
            title: po.name,
            value: po.id))
        .toList();
  }

  List<ItemRadio> _mapBranchOptionsToItemRadio(List<Branch> branchOptions) {
    return branchOptions
        .map((b) => ItemRadio(
            groupValue: branchOptions[0].id,
            isSelected: false,
            title: b.name,
            value: b.id))
        .toList();
  }
}
