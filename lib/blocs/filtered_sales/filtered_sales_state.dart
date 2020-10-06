import 'package:andina_protos/models/sale.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FilteredSalesState extends Equatable {
  FilteredSalesState([List props = const []]) : super(props);
}

class FilteredSalesLoaded extends FilteredSalesState {
  final List<Sale> sales;
  //final List<int> categoriesFilter;
  final String searchText;

  FilteredSalesLoaded(this.sales, this.searchText): super([sales, searchText]);
}

class FilteredSalesLoading extends FilteredSalesState {}