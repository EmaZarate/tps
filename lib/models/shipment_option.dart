import 'package:equatable/equatable.dart';

class ShipmentOption extends Equatable {
  final int id;
  final String name;
  final bool applyDiscount;
  final int percent;

  ShipmentOption({this.id, this.name, this.applyDiscount, this.percent})
      : super([id, name, applyDiscount, percent]);

  factory ShipmentOption.fromJson(Map<String, dynamic> json) {
    return ShipmentOption(
        id: json['shipmentOptionID'],
        name: json['name'],
        applyDiscount: json['applyDiscount'],
        percent: json['percent']);
  }

  ShipmentOption copyWith(
      int id, String name, bool applyDiscount, int percent) {
    return ShipmentOption(
        id: id ?? this.id,
        name: name ?? this.name,
        applyDiscount: applyDiscount ?? this.applyDiscount,
        percent: percent ?? this.percent);
  }

  toJson() {
    return {
      'shipmentOptionID': id,
      'name': name,
      'applyDiscount': applyDiscount,
      'percent': percent
    };
  }
}
