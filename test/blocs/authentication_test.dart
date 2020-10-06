import 'package:andina_protos/blocs/authentication/authentication.dart';
import 'package:andina_protos/models/customer.dart';
import 'package:andina_protos/repositories/customer.repository.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockCustomerRepository extends Mock implements CustomerRepository {}

void main() {
  group('AuthenticationBloc', () {
    AuthenticationBloc authenticationBloc;
    MockCustomerRepository mockCustomerRepository;

    setUp(() {
      mockCustomerRepository = MockCustomerRepository();

      when(mockCustomerRepository.hasValidToken())
          .thenAnswer((_) => Future.value(false));
      when(mockCustomerRepository.deleteUser())
          .thenAnswer((_) => Future.value(true));
      authenticationBloc =
          AuthenticationBloc(customerRepository: mockCustomerRepository);
    });

    test('initial state is AuthenticationUninitialized', () {
      expect(authenticationBloc.initialState, AuthenticationUninitialized());
    });
    test('dispose does not emit new states', () {
      expectLater(
        authenticationBloc.state,
        emitsInOrder([AuthenticationUninitialized()]),
      );
      authenticationBloc.dispose();
    });

    test('emits [uninitialized, unauthenticated] for invalid token', () {
      final expectedResponse = [
        AuthenticationUninitialized(),
        AuthenticationUnauthenticated()
      ];

      expectLater(
        authenticationBloc.state,
        emitsInOrder(expectedResponse),
      );

      authenticationBloc.dispatch(AppStarted());
    });

    test(
        'emits [uninitialized, loading, authenticated] when token is persisted',
        () {
      final expectedResponse = [
        AuthenticationUninitialized(),
        AuthenticationLoading(),
        AuthenticationAuthenticated(),
      ];

      when(mockCustomerRepository.persistUser(Customer(username: 'testuser')))
          .thenAnswer((_) => Future.value(true));

      expectLater(
        authenticationBloc.state,
        emitsInOrder(expectedResponse),
      );

      authenticationBloc.dispatch(LoggedIn(
        customer: Customer(username: 'testuser'),
      ));
    });

    test(
        'emits [uninitialized, loading, unauthenticated] when token is deleted',
        () {
      final expectedResponse = [
        AuthenticationUninitialized(),
        AuthenticationLoading(),
        AuthenticationUnauthenticated(),
      ];

      expectLater(
        authenticationBloc.state,
        emitsInOrder(expectedResponse),
      );

      authenticationBloc.dispatch(LoggedOut());
    });
  });
}
