import 'package:equatable/equatable.dart';

class PaymentOption extends Equatable {
  final int id;
  final String name;
  final int percent;

  PaymentOption({this.id, this.name, this.percent})
      : super([id, name, percent]);

  factory PaymentOption.fromJson(Map<String, dynamic> json) {
    return PaymentOption(
      id: json['paymentOptionID'],
      name: json['name'],
      percent: json['percent'],
    );
  }

  PaymentOption copyWith(int id, String name, int percent) {
    return PaymentOption(
        id: id ?? this.id,
        name: name ?? this.name,
        percent: percent ?? this.percent);
  }

  toJson() {
    return {
      'paymentOptionID': id,
      'name': name,
      'percent': percent,
    };
  }
}
