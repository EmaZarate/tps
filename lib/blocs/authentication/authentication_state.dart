import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super(props);
}

class AuthenticationUninitialized extends AuthenticationState {
  @override
  String toString() => 'Authentication uninitialized';
}

class AuthenticationAuthenticated extends AuthenticationState {
  @override
  String toString() => 'Authentication authenticated';
}

class AuthenticationUnauthenticated extends AuthenticationState {
  @override
  String toString() => 'Authentication unauthenticated';
}

class AuthenticationLoading extends AuthenticationState {
  @override
  String toString() => 'Authentication loading';
}
