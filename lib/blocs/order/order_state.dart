import 'package:andina_protos/models/order.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class OrderState extends Equatable {
  OrderState([List props = const []]) : super(props);
}

class OrderEmpty extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<Order> orders;

  OrderLoaded({this.orders}): super([orders]);
}