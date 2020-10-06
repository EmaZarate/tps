import 'package:andina_protos/models/category.dart';
import 'package:andina_protos/models/packing.dart';
import 'package:equatable/equatable.dart';

class Product {
  final String name;
  final int unitPrice;
  final List<String> types;
  final String typeSelected;
  final String img;
  final String assetsImageName;

  Product({this.name, this.unitPrice, this.types, this.typeSelected, this.img, this.assetsImageName});
}

class ProductProd extends Equatable {
  final int id;
  final String name;
  final String img;
  final String assetsImageName;
  final String sku;
  final bool hasStock;
  final Category category;
  final List<Packing> packing;

  ProductProd(
      {this.id,
      this.name,
      this.img,
      this.sku,
      this.assetsImageName,
      this.hasStock,
      this.category,
      this.packing})
      : super([id, name, img, sku, assetsImageName, hasStock, category, packing]);

  factory ProductProd.fromJson(Map<String, dynamic> json) {
    var packingListGeneric = json['packing'] as List ?? null;
    List<Packing> packingList;
    if (packingListGeneric != null) {
      packingList = packingListGeneric.map((p) => Packing.fromJson(p)).toList();
    }

    return ProductProd(
        id: json['productID'],
        name: json['name'],
        img: json['image'],
        sku: json['sKU'],
        assetsImageName: json['assetsImageName'],
        hasStock: json['hasStock'] as bool ?? true,
        category: json['category'] != null
            ? Category.fromJson(json['category'])
            : null,
        packing: packingList);
  }

  ProductProd copyWith(int id, String name, String img, String sku, bool hasStock,
      Category category, List<Packing> packing) {
    return ProductProd(
        id: id ?? this.id,
        name: name ?? this.name,
        img: img ?? this.img,
        sku: sku ?? this.sku,
        assetsImageName: assetsImageName ?? this.assetsImageName,
        hasStock: hasStock ?? this.hasStock,
        category: category ?? this.category,
        packing: packing ?? this.packing);
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'img': img,
      'assetsImageName': assetsImageName,
      'sku': sku,
      'hasStock': hasStock,
      'category': category,
      'packing': packing
    };
  }
}
