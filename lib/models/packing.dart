import 'package:andina_protos/models/price_list.dart';
import 'package:andina_protos/models/product.dart';
import 'package:andina_protos/models/unit_sale.dart';
import 'package:equatable/equatable.dart';

class Packing extends UnitSale with EquatableMixinBase, EquatableMixin {
  final ProductProd product;
  final String name;
  final List<PriceList> priceLists;
  final double price;
  final int quantity;

  Packing({id,this.product, this.name, this.priceLists, this.price, this.quantity}) : super(id);

  @override
  List get props {
    return [id, product, name, priceLists, quantity];
  }

  factory Packing.fromJson(Map<String, dynamic> json) {
    var priceListsGeneric = json['priceLists'] as List;
    List<PriceList> priceLists = List<PriceList>();
    if (priceListsGeneric != null) {
      priceLists = priceListsGeneric.map((p) => PriceList.fromJson(p)).toList();
    }

    return Packing(
        id: json['packingID'],
        product: json['product'] != null
            ? ProductProd.fromJson(json['product'])
            : null,
        name: json['name'],
        price: json['price'],
        quantity: json['quantity'],
        priceLists: priceLists);
  }

  Packing copyWith(
      {int id, ProductProd product, String name, List<PriceList> priceLists}) {
    return Packing(
        id: id ?? this.id,
        product: product ?? this.product,
        name: name ?? this.name,
        priceLists: priceLists ?? this.priceLists,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity);
  }

  toJson() {
    return {
      'packingID': id,
      'product': product,
      'name': name,
      'priceList': priceLists,
      'price': price,
      'quantity': quantity
    };
  }

  @override
  double getPrice() {
    return this.price;
  }

  @override
  String getProductName() {
    return this.product.name;
  }

  @override
  String getPackingName() {
    return this.name;
  }

  @override
  toJsonMutation(quantity) {
    return {
    		'productID': this.product.id,
        'packingID': this.id,
        'quantity': quantity
    };
  }

  @override
  Map<String, dynamic> toMap(quantity) {
    return {
      'productID': this.product.id,
      'packingID': this.id,
      'quantity': quantity
    };
  }
}
