import 'package:andina_protos/models/packing.dart';
import 'package:andina_protos/models/unit_sale.dart';
import 'package:equatable/equatable.dart';

class SalePackings  with EquatableMixinBase, EquatableMixin {
  final int packingID;
  final int productID;
  final Packing packing;
  final int quantity;

  SalePackings({this.packingID, this.productID,this.packing, this.quantity});

  @override
  List get props {
    return [packingID, productID, packing,quantity];
  }

  factory SalePackings.fromJson(Map<String, dynamic> json) {

    return SalePackings(packingID: json['packingID'],productID : json['productID'],packing: json['packing'] != null
            ? Packing.fromJson(json['packing'])
            : null, quantity: json['quantity']);
  }

  SalePackings copyWith(int packingID, int productID, Packing packing,int quantity) {
    return SalePackings(
        packingID: packingID ?? this.packingID,
        productID: productID ?? this.productID,
        packing: packing ?? this.packing,
        quantity: quantity ?? this.quantity);
  }

  toJson() {
    return {
      'packingID': packingID,
      'productID': productID,
      'packing': packing,
      'quantity': quantity
    };
  }

  // @override
  // double getPrice() {
  //   double totalPrice = 0.0;

  //   this.products.forEach((packing) => totalPrice += packing.getPrice());

  //   // Left apply discount policy
  //   return totalPrice;
  // }

  // @override
  // String getProductName() {
  //   return this.name;
  // }

  // @override
  // String getPackingName() {
  //   return this.name;
  // }

  // @override
  // toJsonMutation(int quantity) {
  //   // TODO: implement toJsonMutation
  //   return null;
  // }

  // @override
  // Map<String,dynamic > toMap(quantity) {
  //   // TODO: implement toMap
  //   return null;
  // }
}
