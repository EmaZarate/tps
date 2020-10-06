import 'package:andina_protos/models/product.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FilteredProductsState extends Equatable {
  FilteredProductsState([List props = const []]) : super(props);
}

class FilteredProductsLoaded extends FilteredProductsState {
  final List<ProductProd> products;
  final List<int> categoriesFilter;
  final String searchText;
  final int page;

  FilteredProductsLoaded(this.products, this.categoriesFilter, this.searchText, this.page): super([products, categoriesFilter, searchText, page]);
}

class FilteredProductsLoading extends FilteredProductsState {
  final List<int> categoriesFilter;
  final String searchText;
  final int page;

  FilteredProductsLoading(this.categoriesFilter, this.searchText, this.page): super([categoriesFilter, searchText, page]);
}

class FilteredProductsLoadingPage extends FilteredProductsState {
  final List<ProductProd> products;
  final List<int> categoriesFilter;
  final String searchText;
  final int page;
  
  FilteredProductsLoadingPage(this.categoriesFilter, this.searchText, this.page, this.products): super([categoriesFilter, searchText, page, products]);
}