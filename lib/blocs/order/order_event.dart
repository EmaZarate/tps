import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class OrderEvent extends Equatable {
  OrderEvent([List props = const []]) : super(props);
}

class FetchOrders extends OrderEvent {}