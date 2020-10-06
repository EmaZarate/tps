import 'package:andina_protos/models/change_password.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PasswordEvent extends Equatable {
  PasswordEvent([List props = const []]) : super(props);
}

class ChangePasswordButtonPressed extends PasswordEvent {
  final ChangePassword changePassword;

  ChangePasswordButtonPressed({@required this.changePassword})
      : super([changePassword]);
}
