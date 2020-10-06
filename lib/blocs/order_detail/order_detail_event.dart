import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class OrderDetailEvent extends Equatable {
  OrderDetailEvent([List props = const[]]) : super(props);
}

class FetchOrder extends OrderDetailEvent {
  final int orderId;
  FetchOrder({this.orderId});
}