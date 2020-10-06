import 'package:andina_protos/models/product.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FilteredProductsEvent extends Equatable {
  FilteredProductsEvent([List props = const []]) : super(props);
}

class UpdateFilter extends FilteredProductsEvent{
  final List<int> categoriesFilter;

  UpdateFilter(this.categoriesFilter) : super([categoriesFilter]);

  @override
  String toString() => 'Update filter {filter: $categoriesFilter';
}

class UpdateProducts extends FilteredProductsEvent {
  final List<ProductProd> products;

  UpdateProducts(this.products): super([products]);
}

class UpdateSearchBar extends FilteredProductsEvent {
  final String searchText;

  UpdateSearchBar(this.searchText) : super([searchText]);
}

class LoadNewPage extends FilteredProductsEvent {}

class SetLoading  extends FilteredProductsEvent {}