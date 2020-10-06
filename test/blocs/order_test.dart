import 'package:andina_protos/blocs/order/order.dart';
import 'package:andina_protos/models/order.dart';
import 'package:andina_protos/repositories/customer.repository.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockCustomerRepository extends Mock implements CustomerRepository {}

void main() {
  group('OrderTest', () {
    OrderBloc orderBloc;
    MockCustomerRepository mockCustomerRepository;
    setUp(() {
      mockCustomerRepository = MockCustomerRepository();
      orderBloc = OrderBloc(customerRepository: mockCustomerRepository);
    });

    test('initial state is correct', () {
      expect(OrderEmpty(), orderBloc.initialState);
    });

    test('dispose does not emit new states', () {
      expectLater(
        orderBloc.state,
        emitsInOrder([]),
      );
      orderBloc.dispose();
    });

    test('should return orders of customer when FetchOrders is dispatched', () {
      final expected = [
        OrderEmpty(),
        OrderLoading(),
        OrderLoaded(orders: <Order>[])
      ];

      when(mockCustomerRepository.getUserOrders()).thenAnswer((_) => Future.value(<Order>[]));

      expectLater(orderBloc.state, emitsInOrder(expected));

      orderBloc.dispatch(FetchOrders());
    });

    
  });
}
