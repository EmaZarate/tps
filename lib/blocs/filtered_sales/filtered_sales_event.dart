import 'package:andina_protos/models/sale.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FilteredSalesEvent extends Equatable {
  FilteredSalesEvent([List props = const []]) : super(props);
}

class UpdateFilter extends FilteredSalesEvent{
  //final List<int> categoriesFilter;

  //UpdateFilter(this.categoriesFilter) : super([categoriesFilter]);

  // @override
  // String toString() => 'Update filter {filter: $categoriesFilter';
}

class UpdateSales extends FilteredSalesEvent {
  final List<Sale> sales;

  UpdateSales(this.sales): super([sales]);
}

class UpdateSearchBar extends FilteredSalesEvent {
  final String searchText;

  UpdateSearchBar(this.searchText) : super([searchText]);
}
