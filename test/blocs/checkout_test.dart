import 'package:andina_protos/blocs/checkout/checkout.dart';
import 'package:andina_protos/models/branch.dart';
import 'package:andina_protos/models/payment_option.dart';
import 'package:andina_protos/models/shipment_option.dart';
import 'package:andina_protos/repositories/checkout.repository.dart';
import 'package:andina_protos/repositories/customer.repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockCustomerRepository extends Mock implements CustomerRepository {}

class MockCheckoutRepository extends Mock implements CheckoutRepository {}

void main() {
  group('CheckoutBloc', () {
    CheckoutBloc checkoutBloc;
    MockCustomerRepository mockCustomerRepository;
    MockCheckoutRepository mockCheckoutRepository;

    setUp(() {
      mockCustomerRepository = MockCustomerRepository();
      mockCheckoutRepository = MockCheckoutRepository();

      when(mockCheckoutRepository.getPaymentOptions())
          .thenAnswer((_) => Future.value(List<PaymentOption>()));
      when(mockCheckoutRepository.getShipmentOptions())
          .thenAnswer((_) => Future.value(List<ShipmentOption>()));
      when(mockCustomerRepository.getUserBranch())
          .thenAnswer((_) => Future.value(List<Branch>()));
          
      checkoutBloc = CheckoutBloc(
          customerRepository: mockCustomerRepository,
          checkoutRepository: mockCheckoutRepository);
    });

    test('initial state is CheckoutUninitialized', () {
      expect(checkoutBloc.initialState, CheckoutUninitialized());
    });
    test('dispose does not emit new states', () {
      expectLater(
        checkoutBloc.state,
        emitsInOrder([CheckoutUninitialized()]),
      );
      checkoutBloc.dispose();
    });

    test(
        'should get shipmentOptions, paymentOptions and branches in response to LoadOptions Event',
        () {


      final expected = [
        CheckoutUninitialized(),
        CheckoutLoading(),
        CheckoutLoaded(
            branches: List<Branch>(),
            paymentOptions: List<PaymentOption>(),
            shipmentOptions: List<ShipmentOption>()),
      ];

      expectLater(checkoutBloc.state, emitsInOrder(expected));

      checkoutBloc.dispatch(LoadOptions());     
    });
  });
}
