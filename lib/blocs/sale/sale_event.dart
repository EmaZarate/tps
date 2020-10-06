import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SaleEvent extends Equatable {
  SaleEvent([List props = const []]) : super(props);
}

class FetchSales extends SaleEvent {
  
}