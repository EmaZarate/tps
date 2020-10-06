import 'package:andina_protos/models/packing.dart';
import 'package:andina_protos/models/sale.dart';

abstract class UnitSale {
final int id;
UnitSale(this.id);
  factory UnitSale.fromJson(Map<String, dynamic> json) {
    final isSale = json['productID'] == null;
    if(isSale){
      return Sale.fromJson(json);
    }
   else{
      return Packing.fromJson(json);
    }
  }

  double getPrice();
  String getProductName();
  String getPackingName();

  dynamic toJsonMutation(int quantity);
  Map<String,dynamic> toMap(quantity);
}