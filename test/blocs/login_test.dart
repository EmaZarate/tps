import 'package:andina_protos/blocs/authentication/authentication.dart';
import 'package:andina_protos/blocs/authentication/authentication_bloc.dart';
import 'package:andina_protos/blocs/login/login.dart';
import 'package:andina_protos/models/auth.dart';
import 'package:andina_protos/models/customer.dart';
import 'package:andina_protos/repositories/customer.repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}

class MockCustomerRepository extends Mock implements CustomerRepository {}

void main() {
  group('LoginBloc', () {
    LoginBloc loginBloc;
    MockAuthenticationBloc mockAuthenticationBloc;
    MockCustomerRepository mockCustomerRepository;
    setUp(() {
      mockAuthenticationBloc = MockAuthenticationBloc();
      mockCustomerRepository = MockCustomerRepository();
      loginBloc = LoginBloc(
          customerRepository: mockCustomerRepository,
          authenticationBloc: mockAuthenticationBloc);
    });

    test('initial state is correct', () {
      expect(LoginInitial(), loginBloc.initialState);
    });

    test('dispose does not emit new states', () {
      expectLater(
        loginBloc.state,
        emitsInOrder([]),
      );
      loginBloc.dispose();
    });

    test('emits token on success', () {
      final expectedResponse = [
        LoginInitial(),
        LoginLoading(),
        LoginInitial(),
      ];

      when(mockCustomerRepository.authenticate(
        username: 'valid.username',
        password: 'valid.password',
      )).thenAnswer((_) => Future.value(Auth(id: "id")));

      when(mockCustomerRepository.getMe(id: "id"))
          .thenAnswer((_) => Future.value(Customer()));

      expectLater(
        loginBloc.state,
        emitsInOrder(expectedResponse),
      ).then((_) {
        verify(mockAuthenticationBloc.dispatch(LoggedIn(customer: Customer())))
            .called(1);
      });

      loginBloc.dispatch(LoginButtonPressed(
        username: 'valid.username',
        password: 'valid.password',
      ));
    });
  });
}
