import 'package:andina_protos/blocs/authentication/authentication_event.dart';
import 'package:andina_protos/blocs/authentication/authentication_state.dart';
import 'package:andina_protos/repositories/customer.repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final CustomerRepository customerRepository;

  AuthenticationBloc({@required this.customerRepository})
    :assert(customerRepository != null);

  @override
  AuthenticationState get initialState =>  AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
        if(event is AppStarted) {
      final bool hasToken = await customerRepository.hasValidToken();

      if(hasToken) {
        yield AuthenticationAuthenticated();
      }
      else{
        yield AuthenticationUnauthenticated();
      }
    }

    if(event is LoggedIn) {
      yield AuthenticationLoading();

      await customerRepository.persistUser(event.customer);
      yield AuthenticationAuthenticated();
    }

    if(event is LoggedOut) {
      yield AuthenticationLoading();
      await customerRepository.deleteUser();
      await customerRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}