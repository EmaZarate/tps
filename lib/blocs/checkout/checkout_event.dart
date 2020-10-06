import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CheckoutEvent extends Equatable {
  CheckoutEvent([List props = const []]) : super(props);
}

class LoadOptions extends CheckoutEvent {}

class RefreshOptions extends CheckoutEvent {}