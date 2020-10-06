import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ProductEvent extends Equatable {
  ProductEvent([List props = const []]) : super(props);
}

class FetchProducts extends ProductEvent {

  final List<int> categoriesFilter;
  final String searchText;
  final int page;
  
  FetchProducts(this.categoriesFilter, this.searchText, this.page) : super([categoriesFilter, searchText, page]);
  
}