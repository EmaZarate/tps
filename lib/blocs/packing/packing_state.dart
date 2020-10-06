import 'package:andina_protos/models/item_order.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PackingState extends Equatable {
  PackingState([List props = const []]) : super(props);
}

class UnselectedPacking extends PackingState {}

class SelectedPacking extends PackingState {
  final ItemOrder item;

  SelectedPacking({@required this.item}): super([item]);
}