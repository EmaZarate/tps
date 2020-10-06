import 'package:andina_protos/models/customer.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super(props);
}

class AppStarted extends AuthenticationEvent {
  @override 
  String toString() => 'App Started';
}

class LoggedIn extends AuthenticationEvent {
  final Customer customer;

  LoggedIn({@required this.customer}): super([customer]);

  @override
  String toString() => 'Logged in {token: $customer}';
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'Logged out';
}