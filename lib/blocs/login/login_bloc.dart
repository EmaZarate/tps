import 'package:andina_protos/blocs/authentication/authentication.dart';
import 'package:andina_protos/models/auth.dart';
import 'package:andina_protos/models/customer.dart';
import 'package:andina_protos/repositories/customer.repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final CustomerRepository customerRepository;
  final AuthenticationBloc authenticationBloc;
  

  LoginBloc(
      {@required this.customerRepository, @required this.authenticationBloc})
      : assert(customerRepository != null),
        assert(authenticationBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final Auth authResult = await customerRepository.authenticate(
            username: event.username, password: event.password);
        if (authResult != null) {
          await customerRepository.persistToken(authResult.authToken);
          final Customer customer = await customerRepository.getMe(id: authResult.id);
          authenticationBloc.dispatch(LoggedIn(customer: customer));
          yield LoginInitial();
        }
      } catch (error) {
        if(error.source == "Cliente bloqueado"){
          yield LoginLocked(error: error.toString());
        }else{
          yield LoginFailure(error: error.toString());
        }
      }
    }
  }
}
