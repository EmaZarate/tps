import 'package:andina_protos/models/branch.dart';
import 'package:andina_protos/models/payment_option.dart';
import 'package:andina_protos/models/shipment_option.dart';
import 'package:andina_protos/models/unit_sale.dart';
import 'package:andina_protos/models/order.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CartEvent extends Equatable {
  CartEvent([List props = const []]) : super(props);
}

class InitializeCart extends CartEvent {}

class AddItem extends CartEvent {
  final UnitSale unitSale;
  final int quantity;

  AddItem({this.unitSale, this.quantity}) : super([unitSale, quantity]);
}

class RemoveItem extends CartEvent {
  final UnitSale unitSale;

  RemoveItem({this.unitSale}) : super([unitSale]);
}

class UpdateQuantity extends CartEvent {
  final UnitSale unitSale;
  final int quantity;

  UpdateQuantity({this.unitSale, this.quantity}) : super([unitSale, quantity]);
}

class ClearCart extends CartEvent {}

class SelectShipmentOption extends CartEvent {
  final ShipmentOption shipmentOption;

  SelectShipmentOption({this.shipmentOption}) : super([shipmentOption]);
}

class SelectPaymentOption extends CartEvent {
  final PaymentOption paymentOption;

  SelectPaymentOption({this.paymentOption}) : super([paymentOption]);
}

class SelectBranchOption extends CartEvent {
  final Branch branchOption;

  SelectBranchOption({this.branchOption}) : super([branchOption]);
}

class SeachOrder extends CartEvent {
  final int orderId;

  SeachOrder({this.orderId});
}

class SetOrder extends CartEvent {
  final Order order;

  SetOrder({this.order});
}

class FinishOrder extends CartEvent {}

class FinishedOrder extends CartEvent {
  final int orderId;

  FinishedOrder({this.orderId});
}
