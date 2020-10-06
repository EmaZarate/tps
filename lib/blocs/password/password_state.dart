import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PasswordState extends Equatable {
  PasswordState([List props = const []]) : super(props);
}

class PasswordUnchanged extends PasswordState {}
class PasswordChanging extends PasswordState {}
class PasswordChanged extends PasswordState{}
class PasswordError extends PasswordState{
  final String error;
  PasswordError({this.error});
}