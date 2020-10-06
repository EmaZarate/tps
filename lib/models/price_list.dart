import 'package:equatable/equatable.dart';

class PriceList extends Equatable {
  final int id;
  final String code;
  final double price;

  PriceList({this.id, this.code, this.price}) : super([id, code, price]);

  factory PriceList.fromJson(Map<String, dynamic> json) {
    return PriceList(id: json['priceListID'], code: json['code'], price: json['price']);
  }

  PriceList copyWith(int id, String code, double price) {
    return PriceList(
        id: id ?? this.id, code: code ?? this.code, price: price ?? this.price);
  }

  toJson() {
    return {
      'id': id,
      'code': code,
      'price': price,
    };
  }
}
