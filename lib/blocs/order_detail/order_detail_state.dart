import 'package:andina_protos/models/order.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable 
abstract class OrderDetailState extends Equatable{
  OrderDetailState([List props = const[]]) : super(props);
}

class OrderDetailEmpty extends OrderDetailState {}

class OrderDetailLoading extends OrderDetailState {}

class OrderDetailLoaded extends OrderDetailState {
  final Order order;

  OrderDetailLoaded({this.order}) : super([order]);
}