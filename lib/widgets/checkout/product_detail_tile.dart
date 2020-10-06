import 'package:andina_protos/widgets/common/image_decode.dart';
import 'package:andina_protos/blocs/cart/cart.dart';
import 'package:andina_protos/models/item_order.dart';
import 'package:andina_protos/models/product.dart';
import 'package:andina_protos/models/sale.dart';
import 'package:andina_protos/widgets/products/quantity_select.dart';
import 'package:flutter/material.dart';

class ProductDetailTile extends StatelessWidget {
  final ProductProd product;
  final Sale sale;
  final ItemOrder item;
  final CartBloc cartBloc;

  const ProductDetailTile({this.product, this.sale, this.item, this.cartBloc, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        child: ListTile(
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      child: Text(
                        item.unitSale.getPackingName(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade700,
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Total \$${item.subtotal.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: QuantitySelect(
                        unitPrice: item.unitSale.getPrice(),
                        displayTotal: false,
                        quantity: item.quantity,
                        emitChangeQuantity: _quantityChanged,
                      ),
                    ),
                  ],
                )
              ],
            ),
            // trailing: Icon(Icons.delete),

            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  item.unitSale.getProductName(),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0),
                ),
                InkWell(
                  onTap: () {
                    cartBloc.dispatch(RemoveItem(
                      unitSale: item.unitSale
                    ));
                  },
                  child: Container(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.grey.shade600,
                      )),
                ),
              ],
            ),
            leading: ImageDecode(img: _returnImg(), width: 60.0,)),
      ),
    );
  }

  void _quantityChanged(int quantity, BuildContext context) {
    cartBloc
        .dispatch(UpdateQuantity(unitSale: item.unitSale, quantity: quantity));
  }

  _returnImg() {
    if (product != null) {
      return product.img;
    } else if(sale != null) { 
      return sale.image;
    }
  }
}
