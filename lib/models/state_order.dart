import 'package:equatable/equatable.dart';

class StateOrder extends Equatable {
  final int id;
  final String name;

  StateOrder({this.id, this.name}) : super([id, name]);

  factory StateOrder.fromJson(Map<String,dynamic> json) {
    return StateOrder(
      id: json['orderStateID'],
      name: json['name']
    );
  }

  StateOrder copyWith(int id, String name) {
    return StateOrder(
      id: id ?? this.id,
      name: name ?? this.name
    );
  }

  toJson() {
    return {
      'orderStateID': id,
      'name': name
    };
  }
}