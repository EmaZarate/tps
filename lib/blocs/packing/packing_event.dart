import 'package:andina_protos/models/packing.dart';
import 'package:andina_protos/models/product.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PackingEvent extends Equatable {
  PackingEvent([List props = const []]) : super(props);
}

class SelectPacking extends PackingEvent {
  final int packingId;
  final List<Packing> packings;
  final ProductProd product;

  SelectPacking({@required this.packings, @required this.packingId, @required this.product}) : super([packings, packingId, product]);
}

class SelectQuantity extends PackingEvent {
  final int quantity;

  SelectQuantity({@required this.quantity}): super([quantity]);
}

class CleanSelection extends PackingEvent {}