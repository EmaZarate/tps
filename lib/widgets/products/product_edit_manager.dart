import 'dart:async';

import 'package:andina_protos/blocs/cart/cart.dart';
import 'package:andina_protos/blocs/packing/packing.dart';
import 'package:andina_protos/models/product.dart';
import 'package:andina_protos/widgets/products/product_edit_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProductEditManager extends StatefulWidget {
  final Function returnFlushbar;
  final ProductProd product;
  const ProductEditManager({Key key, this.returnFlushbar, this.product})
      : super(key: key);
  @override
  _ProductEditManagerState createState() => _ProductEditManagerState();
}

class _ProductEditManagerState extends State<ProductEditManager> {
  PackingBloc _packingBloc;
  double unitPrice;
  StreamSubscription unitPriceSubscription;

  @override
  void initState() {
    _packingBloc = PackingBloc();
    _packingBloc.dispatch(SelectPacking(packings: widget.product.packing, packingId: widget.product.packing[0].id, product: widget.product));
    unitPriceSubscription = _packingBloc.state.listen((state) {
      if (state is SelectedPacking) {
        setState(() {
          unitPrice = state.item.unitSale.getPrice();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _packingBloc.dispose();
    unitPriceSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CartBloc _cartBloc = BlocProvider.of<CartBloc>(context);
    return Slidable(
      delegate: SlidableStrechDelegate(),
      actions: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: IconSlideAction(
            onTap: () {
              _cartBloc.dispatch(AddItem(
                  quantity: (_packingBloc.currentState as SelectedPacking)
                      .item
                      .quantity,
                  unitSale: (_packingBloc.currentState as SelectedPacking)
                      .item
                      .unitSale));
              _packingBloc.dispatch(SelectPacking(packings: widget.product.packing, packingId: widget.product.packing[0].id, product: widget.product));
              widget.returnFlushbar(context);
            },
            caption: 'Añadir al carrito',
            color: Colors.green,
            icon: MdiIcons.cartPlus,
          ),
        ),
      ],
      actionExtentRatio: 0.25,
      child: ProductEditTile(
        product: widget.product,
        packingBloc: _packingBloc,
        unitPrice: unitPrice,
      ),
    );
  }
}
