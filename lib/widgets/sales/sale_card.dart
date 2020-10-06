import 'package:andina_protos/widgets/common/image_decode.dart';
import 'dart:async';
import 'package:andina_protos/models/sale.dart';
import 'package:andina_protos/screens/saleDetail.dart';
import 'package:flutter/material.dart';

class SaleCard extends StatefulWidget {
  final Sale sale;
  final bool purchase;
  const SaleCard({Key key, this.sale, this.purchase}) : super(key: key);

  @override
  _SaleCardState createState() => _SaleCardState();
}

class _SaleCardState extends State<SaleCard> {
  StreamSubscription unitPriceSubscription;

  @override
  void dispose() {
    unitPriceSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
       Container(
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
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Card(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(child: ImageDecode(img: widget.sale.image, width: 170.0)),
                      Container(
                        height: 40.0,
                        child: Text(
                            widget.sale.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0),
                          ),
                      ),
                      SizedBox(height: 5.0,),
                      Container(
                        child: Text(_getProductsInSale(), overflow: TextOverflow.ellipsis, maxLines: 2,),
                        height: 30.0,
                        ),
                      SizedBox(height: 8.0,),
                      Text(
                        widget.sale.price.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        )              
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context){
                          return SaleDetail(sale: widget.sale, purchase: widget.purchase);
                      }
                    );
                  },
                ),
              ),
          ),
       );
  }

  String _getProductsInSale(){
    String products = '';
    widget.sale.salePackings.forEach((salePacking) => {
      products = products + salePacking.packing.product.name + ', '
    });
    products = products.substring(0, products.length - 2);
    return products + '.';
    
  }

}
