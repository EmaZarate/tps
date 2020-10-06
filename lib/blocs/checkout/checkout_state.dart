import 'package:andina_protos/models/branch.dart';
import 'package:andina_protos/models/payment_option.dart';
import 'package:andina_protos/models/shipment_option.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CheckoutState extends Equatable {
  CheckoutState([List props = const []]) : super(props);
}

class CheckoutUninitialized extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutLoaded extends CheckoutState {
  final bool forceChange;
  final List<Branch> branches;
  final List<ShipmentOption> shipmentOptions;
  final List<PaymentOption> paymentOptions;

  CheckoutLoaded(
      {this.branches,
      this.shipmentOptions,
      this.paymentOptions,
      this.forceChange = false})
      : super([branches, shipmentOptions, paymentOptions, forceChange]);
}
