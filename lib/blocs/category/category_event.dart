import 'package:andina_protos/models/category.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CategoryEvent extends Equatable {
  CategoryEvent([List props = const []]) : super(props);
}

class FetchCategories extends CategoryEvent {}

class AddedFilter extends CategoryEvent {
  final Category category;

  AddedFilter(this.category) : super([category]);
}

class RemovedFilter extends CategoryEvent {
  final Category category;

  RemovedFilter(this.category) : super([category]);
}

class RefreshCategories extends CategoryEvent {}
