import 'package:equatable/equatable.dart';

class ChangePassword extends Equatable {
  final String oldPassword;
  final String newPassword;
  final String newPasswordConfirmed;

  ChangePassword(
      {this.newPassword, this.oldPassword, this.newPasswordConfirmed})
      : super([newPassword, oldPassword, newPasswordConfirmed]);

  toJson() {
    return {'currentPassword': oldPassword, 'newPassword': newPassword};
  }

  ChangePassword copyWith({String oldPassword, String newPassword, String newPasswordConfirmed}) {
    return ChangePassword(
        oldPassword: oldPassword ?? this.oldPassword,
        newPassword: newPassword ?? this.newPassword,
        newPasswordConfirmed: newPasswordConfirmed ?? this.newPasswordConfirmed);
  }
}
