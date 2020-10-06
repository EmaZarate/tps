import 'package:andina_protos/models/category.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CategoryState extends Equatable {
  CategoryState([List props = const []]) : super(props);
}

class CategoryEmpty extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final bool forceChange;
  final List<Category> categories;

  CategoryLoaded({this.categories, this.forceChange = false}): super([categories]);

}