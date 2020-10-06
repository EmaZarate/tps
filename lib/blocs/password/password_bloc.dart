import 'package:andina_protos/blocs/password/password_event.dart';
import 'package:andina_protos/blocs/password/password_state.dart';
import 'package:andina_protos/repositories/customer.repository.dart';
import 'package:bloc/bloc.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final CustomerRepository customerRepository;

  PasswordBloc({this.customerRepository}) : assert(customerRepository != null);

  @override
  PasswordState get initialState => PasswordUnchanged();

  @override
  Stream<PasswordState> mapEventToState(
    PasswordEvent event,
  ) async* {
    if (event is ChangePasswordButtonPressed) {
      yield PasswordChanging();
      if (event.changePassword.newPassword !=
          event.changePassword.newPasswordConfirmed) {
        yield PasswordError(error: 'Las contraseñas no coinciden.');
      } else {
        try {
          await customerRepository.changePassword(event.changePassword);
          yield PasswordChanged();
          await Future.delayed(Duration(seconds: 3));
          yield PasswordUnchanged();
        } catch (_) {
          yield PasswordError(error:'Error: Verifique que la contraseña sea correcta y que la nueva sea válida');
          
        }
      }
    }
  }
}
