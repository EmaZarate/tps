import 'package:andina_protos/models/unit_sale.dart';
import 'package:equatable/equatable.dart';

class ItemOrder extends Equatable {
  final UnitSale unitSale;
  final int quantity;
  final double subtotal;

  ItemOrder({this.unitSale, this.quantity, this.subtotal})
      : super([unitSale, quantity, subtotal]);

  factory ItemOrder.fromJson(Map<String, dynamic> json) {
    return ItemOrder(
        quantity: json['quantity'],
        subtotal: json['subtotal'],
        unitSale: json['packing_Navigation'] != null
            ? UnitSale.fromJson(json['packing_Navigation'])
            : UnitSale.fromJson(json['sale_Navigation']));
  }

  ItemOrder copyWith({UnitSale unitSale, int quantity, double subtotal}) {
    return ItemOrder(
        unitSale: unitSale ?? this.unitSale,
        quantity: quantity ?? this.quantity,
        subtotal: subtotal ?? this.subtotal);
  }

  toJson() {
    return unitSale.toJsonMutation(quantity);
  }

  toMap() {
    return unitSale.toMap(quantity);
  }
}
