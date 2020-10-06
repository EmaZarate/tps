
import 'package:andina_protos/models/price_list.dart';
import 'package:andina_protos/models/sale_packings.dart';
import 'package:andina_protos/models/unit_sale.dart';
import 'package:equatable/equatable.dart';

class Sale extends UnitSale with EquatableMixinBase, EquatableMixin {
  final double price;
  final List<SalePackings> salePackings;
  final List<PriceList> priceLists;
  final String name;
  final String image;

  Sale({id,this.price,this.salePackings,this.priceLists, this.name, this.image}): super(id);

  @override
  List get props {
    return [id,salePackings, priceLists, name, image];
  }

  factory Sale.fromJson(Map<String, dynamic> json) {
    var salePackingListGeneric = json['packings'] as List;
    List<SalePackings> salePackingsList;
    if (salePackingListGeneric != null) {
      salePackingsList = salePackingListGeneric.map((p) => SalePackings.fromJson(p)).toList();
    }

    var priceListsGeneric = json['priceLists'] as List;
    List<PriceList> priceLists = List<PriceList>();
    if (priceListsGeneric != null) {
      priceLists = priceListsGeneric.map((p) => PriceList.fromJson(p)).toList();
    }

    return Sale(id: json['saleID'],price: json['price'], salePackings: salePackingsList, priceLists: priceLists, name:json['name'], image:json['image']);
  }

  Sale copyWith(int id, int price, List<SalePackings> salePackings,List<PriceList> priceLists, String name, String image) {
    return Sale(
        id: id ?? this.id,
        price: price ?? this.price,
        salePackings: salePackings ?? this.salePackings,
        priceLists: priceLists ?? this.priceLists,
        name: name ?? this.name,
        image: image ?? this.image);
  }

  toJson() {
    return {
      'id': id,
      'salePackings': salePackings,
      'priceLists': priceLists,
      'name': name,
      'price': price,
      'image': image
    };
  }

  @override
  String getPackingName() {
    return '';
  }

  @override
  double getPrice() {
    return this.price;
  }

  @override
  String getProductName() {
    return this.name;
  }

  @override
  toJsonMutation(int quantity) {
    return null;
  }

  @override
  Map<String, dynamic> toMap(quantity) {
    return {
      'saleID': this.id,
      'quantity': quantity
    };
  }
}
