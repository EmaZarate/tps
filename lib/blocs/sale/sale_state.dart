import 'package:andina_protos/models/sale.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SaleState extends Equatable {
  SaleState([List props = const []]) : super(props);
}

class SaleEmpty extends SaleState {}

class SaleLoading extends SaleState {}

class SaleLoaded extends SaleState {
  final List<Sale> sales;

  SaleLoaded({this.sales}): super([sales]);

}