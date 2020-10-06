import 'package:andina_protos/blocs/cart/cart.dart';
import 'package:andina_protos/blocs/packing/packing.dart';
import 'package:andina_protos/models/packing.dart';
import 'package:andina_protos/models/product.dart';
import 'package:andina_protos/widgets/alert/alert.dart';
import 'package:andina_protos/widgets/products/quantity_select.dart';
import 'package:andina_protos/widgets/common/image_decode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProductEditTile extends StatelessWidget {
  final ProductProd product;
  final double unitPrice;
  final PackingBloc packingBloc;

  ProductEditTile({this.product, this.unitPrice, this.packingBloc, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartBloc _cartBloc = BlocProvider.of<CartBloc>(context);
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        child: BlocBuilder(
          bloc: packingBloc,
          builder: (BuildContext context, PackingState state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                    title: Text(
                      '${product.name}  ${product.packing[0].name}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0),
                    ),
                    leading: ImageDecode(img: product.img, width: 90.0),
                    contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 10.0),
                              margin: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                              child: _returnStock(),
                            ),
                            Container(
                              child: Text('UD: \$ ${_getUnitPrice()}',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold
                              ))
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              width: 100.0,
                              child: _buildQuantityWidget(state)
                              ),
                             Text('PKG: \$ ${product.packing[0].price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold
                              ))
                          ],
                        ),
                        
                      ],
                    )),
                   Container(
                     margin: const EdgeInsets.only(bottom: 5.0),       
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _showTotal(state),
                          RawMaterialButton(
                            shape: CircleBorder(),
                            fillColor: Colors.green,
                            elevation: 2.0,
                            padding: EdgeInsets.all(13.0),
                            child: Icon(MdiIcons.cartPlus, color: Colors.white),
                            onPressed: () {
                              _cartBloc.dispatch(AddItem(
                              quantity: (
                                packingBloc.currentState as SelectedPacking).item.quantity,
                                unitSale: (packingBloc.currentState as SelectedPacking).item.unitSale)
                              );
                              packingBloc.dispatch(SelectPacking(packings: product.packing, packingId: product.packing[0].id, product: product));
                            })
                            ],
                          ),
                  ),   
                Container(
                  child: Text('Compra mínima por bulto cerrado'),
                  margin: const EdgeInsets.only(left: 18.0, bottom: 15.0),
                  ),  
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuantityWidget(PackingState state) {
    int quantity = state is SelectedPacking ? state.item.quantity : 0;

    return QuantitySelect(
      unitPrice: unitPrice ?? 0.0,
      emitChangeQuantity: _emitSelectQuantity,
      quantity: quantity ?? 0,
    );
  }

  Widget _showTotal(PackingState state) {
      int quantity = state is SelectedPacking ? state.item.quantity : 0;
      return Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Text(
          'Subtotal: \$ ${_getSubtotal(unitPrice, quantity)}',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      );
  }

  String _getSubtotal(double price, int quantity){
    return price == null ? "" : (price * quantity).toStringAsFixed(2);
  }

  String _getUnitPrice(){
    return (product.packing[0].price / product.packing[0].quantity).toStringAsFixed(2);
  }

  _returnStock() {
    return Text(
      product.hasStock ? 'Disponible' : 'Agotado',
      style: TextStyle(
          color: product.hasStock ? Colors.green : Colors.red,
          fontSize: 14.0,
          fontWeight: FontWeight.bold),
    );
  }

  _emitPackingSelected(List<Packing> packings, int id) {
    packingBloc.dispatch(
        SelectPacking(packings: packings, packingId: id, product: product));
  }

  _emitSelectQuantity(int quantity, BuildContext context) {
    if (packingBloc.currentState is SelectedPacking) {
    packingBloc.dispatch(SelectQuantity(quantity: quantity));
    }
    else {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return Alert(title:'Error', messages: ['Antes de agregar un producto debe seleccionar un paquete']);
          });
    }
  }
}
