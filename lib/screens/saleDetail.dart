import 'package:andina_protos/blocs/cart/cart.dart';
import 'package:andina_protos/models/sale.dart';
import 'package:flutter/material.dart';
import 'package:andina_protos/widgets/common/image_decode.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class SaleDetail extends StatefulWidget {
  final Sale sale;
  final bool purchase;
  const SaleDetail({Key key, this.sale, this.purchase}) : super(key: key);

  @override
  _SaleDetailState createState() => _SaleDetailState();
}

class _SaleDetailState extends State<SaleDetail> {
  final _pageController =
      PageController(initialPage: 2, viewportFraction: 1 / 2);
  int quantity = 0;
  @override
  Widget build(BuildContext context) {
    CartBloc _cartBloc = BlocProvider.of<CartBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sale.name),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Text(
                  "Productos",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                )),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              height: 230,
              child: PageView.builder(
                itemCount: widget.sale.salePackings.length,
                controller: _pageController,
                itemBuilder: (BuildContext context, i) {
                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(child: ImageDecode(img: widget.sale.salePackings[i].packing.product.img, width: 150)),
                        Column(
                          children: <Widget>[
                            Text(
                              widget.sale.salePackings[i].packing.product.name,
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                                'Cantidad: ${widget.sale.salePackings[i].quantity.toString()}')
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            Text('\$${widget.sale.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500)),
            SizedBox(height: 30),
            _quantitySelect(),
            SizedBox(height: 60),
            _butonSelectSale(_cartBloc),
          ],
        ),
      ),
    );
  }


  Widget _returnImg(String assetImg){
    if(assetImg != null){
       return Image.asset('assets/products/'+assetImg+'.png');
    }
    else{
      return Image.asset('assets/final.png');
    }
  }
  Widget _quantitySelect() {
    if (widget.purchase) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              child: InkWell(
            onTap: () {
              if (quantity == 0) {
                return;
              }
              setState(() {
                quantity -= 1;
              });
            },
            child: Icon(
              Icons.remove,
            ),
          )),
          Container(
              child: Text(
                quantity.toString(),
                style: TextStyle(fontSize: 17.0),
              ),
              padding: const EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 5.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black))),
          Container(
            child: InkWell(
              onTap: () {
                setState(() {
                  quantity += 1;
                });
              },
              child: Icon(
                Icons.add,
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _butonSelectSale(CartBloc _cartBloc) {
    if (widget.purchase) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: ButtonTheme(
          minWidth: double.infinity,
          height: 55.0,
          child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: Colors.green,
              child: Text(
                'Agregar a mi pedido \$${_returnTotal()}' ,
                style: TextStyle(fontSize: 20.0, fontFamily: 'arial'),
              ),
              onPressed: () {
                if (quantity == 0) {
                  return;
                }
                _cartBloc.dispatch(
                    AddItem(quantity: quantity, unitSale: widget.sale));
                Navigator.of(context).pop();
              }),
        ),
      );
    } else {
      return Container();
    }
  }

  String _returnTotal(){
    return (widget.sale.price * quantity).toStringAsFixed(2);
  }
}
