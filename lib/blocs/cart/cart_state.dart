import 'package:andina_protos/models/order.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CartState extends Equatable {
  CartState([List props = const []]) : super(props);
}

class CartUninitialized extends CartState {}

class CartEditing extends CartState {
  final Order order;

  CartEditing({@required this.order}): super([order]);
}

class CartFinished extends CartState {
  final int orderID;

  CartFinished({@required this.orderID}): super([orderID]);
}