import 'package:andina_protos/blocs/cart/cart.dart';
import 'package:andina_protos/models/branch.dart';
import 'package:andina_protos/models/item_order.dart';
import 'package:andina_protos/models/order.dart';
import 'package:andina_protos/models/packing.dart';
import 'package:andina_protos/models/payment_option.dart';
import 'package:andina_protos/models/price_list.dart';
import 'package:andina_protos/models/product.dart';
import 'package:andina_protos/models/shipment_option.dart';
import 'package:andina_protos/repositories/checkout.repository.dart';
import 'package:andina_protos/repositories/customer.repository.dart';
import 'package:andina_protos/repositories/order.repository.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockCheckoutRepository extends Mock implements CheckoutRepository {}

class MockCustomerRepository extends Mock implements CustomerRepository {}

class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  group('CartBloc', () {
    CartBloc cartBloc;
          MockOrderRepository mockOrderRepository;
    setUp(() {
      MockCheckoutRepository mockCheckoutRepository = MockCheckoutRepository();
      MockCustomerRepository mockCustomerRepository = MockCustomerRepository();
mockOrderRepository = MockOrderRepository();



      cartBloc = CartBloc(
        checkoutRepository: mockCheckoutRepository,
        customerRepository: mockCustomerRepository,
        orderRepository: mockOrderRepository,
      );
    });
    test('initial state is CartUninitialized', () {
      expect(cartBloc.initialState, CartUninitialized());
    });

    test('dispose does not emit new states', () {
      expectLater(
        cartBloc.state,
        emitsInOrder([CartUninitialized()]),
      );
      cartBloc.dispose();
    });

    test(
        'should emit [CartEditing] whit empty order when event is [InitializeCart]',
        () {
      Order emptyOrder = Order(
          branch: Branch(),
          itemOrders: List<ItemOrder>(),
          paymentOption: PaymentOption(),
          shipmentOption: ShipmentOption(),
          total: 0.0);
      final expected = [CartUninitialized(), CartEditing(order: emptyOrder)];

      expectLater(cartBloc.state, emitsInOrder(expected));

      cartBloc.dispatch(InitializeCart());
    });

    test('should add item to cart in response to an AddItem event', () {
      int quantity = 1;
      Packing packing = Packing(
          name: "TEST",
          price: 1,
          priceLists: [PriceList(code: "C", price: 1)],
          product: ProductProd());

      ItemOrder item =
          ItemOrder(quantity: quantity, unitSale: packing, subtotal: 1.0);
      Order emptyOrder = Order(
          branch: Branch(),
          itemOrders: List<ItemOrder>(),
          paymentOption: PaymentOption(),
          shipmentOption: ShipmentOption(),
          total: 0.0);
      final expected = [
        CartUninitialized(),
        CartEditing(order: emptyOrder),
        CartEditing(order: emptyOrder.copyWith(itemOrders: [item], total: 1.0))
      ];

      expectLater(cartBloc.state, emitsInOrder(expected));

      cartBloc.dispatch(InitializeCart());
      cartBloc.dispatch(AddItem(unitSale: packing, quantity: quantity));
    });

    test(
        'should update quantity of item in cart in response to an UpdateQuantity event',
        () {
      int quantity = 1;
      Packing packing = Packing(
          name: "TEST",
          price: 1,
          priceLists: [PriceList(code: "C", price: 1)],
          product: ProductProd());

      ItemOrder item =
          ItemOrder(quantity: quantity, unitSale: packing, subtotal: 1.0);

      Order emptyOrder = Order(
          branch: Branch(),
          itemOrders: List<ItemOrder>(),
          paymentOption: PaymentOption(),
          shipmentOption: ShipmentOption(),
          total: 0.0);

      final expected = [
        CartUninitialized(),
        CartEditing(order: emptyOrder),
        CartEditing(order: emptyOrder.copyWith(itemOrders: [item], total: 1.0)),
        CartEditing(
            order: emptyOrder.copyWith(
                itemOrders: [item.copyWith(quantity: 2, subtotal: 2.0)],
                total: 2.0)),
      ];

      expectLater(cartBloc.state, emitsInOrder(expected));

      cartBloc.dispatch(InitializeCart());
      cartBloc.dispatch(AddItem(unitSale: packing, quantity: quantity));
      cartBloc.dispatch(UpdateQuantity(quantity: 2, unitSale: item.unitSale));
    });

    test(
        'should not update quantity of item if it is not in cart in response to an UpdateQuantity event',
        () {
      int quantity = 1;
      Packing packing = Packing(
          name: "TEST",
          price: 1,
          priceLists: [PriceList(code: "C", price: 1)],
          product: ProductProd());
      Packing packing2 = Packing(
          name: "TEST2",
          price: 2,
          priceLists: [PriceList(code: "C2", price: 2)],
          product: ProductProd());

      ItemOrder item =
          ItemOrder(quantity: quantity, unitSale: packing, subtotal: 1.0);
      ItemOrder item2 =
          ItemOrder(quantity: quantity, unitSale: packing2, subtotal: 1.0);

      Order emptyOrder = Order(
          branch: Branch(),
          itemOrders: List<ItemOrder>(),
          paymentOption: PaymentOption(),
          shipmentOption: ShipmentOption(),
          total: 0.0);

      final expected = [
        CartUninitialized(),
        CartEditing(order: emptyOrder),
        CartEditing(order: emptyOrder.copyWith(itemOrders: [item], total: 1.0)),
      ];

      expectLater(cartBloc.state, emitsInOrder(expected));

      cartBloc.dispatch(InitializeCart());
      cartBloc.dispatch(AddItem(unitSale: packing, quantity: quantity));
      cartBloc.dispatch(UpdateQuantity(quantity: 2, unitSale: item2.unitSale));
    });

    test('should remove item in cart in response to a RemoveItem event', () {
      int quantity = 1;
      Packing packing = Packing(
          price: 1,
          name: "TEST",
          priceLists: [PriceList(code: "C", price: 1)],
          product: ProductProd());

      ItemOrder item =
          ItemOrder(quantity: quantity, unitSale: packing, subtotal: 1.0);

      Order emptyOrder = Order(
          branch: Branch(),
          itemOrders: List<ItemOrder>(),
          paymentOption: PaymentOption(),
          shipmentOption: ShipmentOption(),
          total: 0.0);

      final expected = [
        CartUninitialized(),
        CartEditing(order: emptyOrder),
        CartEditing(order: emptyOrder.copyWith(itemOrders: [item], total: 1.0)),
        CartEditing(order: emptyOrder),
      ];

      expectLater(cartBloc.state, emitsInOrder(expected));

      cartBloc.dispatch(InitializeCart());
      cartBloc.dispatch(AddItem(unitSale: packing, quantity: quantity));
      cartBloc.dispatch(RemoveItem(unitSale: packing));
    });

    test(
        'should not remove item if it is not in cart in response to a RemoveItem event',
        () {
      int quantity = 1;
      Packing packing = Packing(
          name: "TEST",
          price: 1,
          priceLists: [PriceList(code: "C", price: 1)],
          product: ProductProd());

      Packing packing2 = Packing(
          name: "TEST2",
          price: 2,
          priceLists: [PriceList(code: "C2", price: 2)],
          product: ProductProd());

      ItemOrder item =
          ItemOrder(quantity: quantity, unitSale: packing, subtotal: 1.0);

      Order emptyOrder = Order(
          branch: Branch(),
          itemOrders: List<ItemOrder>(),
          paymentOption: PaymentOption(),
          shipmentOption: ShipmentOption(),
          total: 0.0);

      final expected = [
        CartUninitialized(),
        CartEditing(order: emptyOrder),
        CartEditing(order: emptyOrder.copyWith(itemOrders: [item], total: 1.0)),
      ];

      expectLater(cartBloc.state, emitsInOrder(expected));

      cartBloc.dispatch(InitializeCart());
      cartBloc.dispatch(AddItem(unitSale: packing, quantity: quantity));
      cartBloc.dispatch(RemoveItem(unitSale: packing2));
    });

    // test('should clean itemOrders in response to a ClearCart event', () {
    //   int quantity = 1;
    //   Packing packing = Packing(
    //       name: "TEST",
    //       price: 1,
    //       priceLists: [PriceList(code: "C", price: 1)],
    //       product: ProductProd());

    //   Packing packing2 = Packing(
    //       name: "TEST2",
    //       price:2,
    //       priceLists: [PriceList(code: "C2", price: 2)],
    //       product: ProductProd());

    //   ItemOrder item =
    //       ItemOrder(quantity: quantity, unitSale: packing, subtotal: 1.0);
    //   ItemOrder item2 =
    //       ItemOrder(quantity: quantity, unitSale: packing2, subtotal: 2.0);

    //   Order emptyOrder = Order(
    //       branch: Branch(),
    //       itemOrders: List<ItemOrder>(),
    //       paymentOption: PaymentOption(),
    //       shipmentOption: ShipmentOption(),
    //       total: 0.0);

    //   final expected = [
    //     CartUninitialized(),
    //     CartEditing(order: emptyOrder),
    //     CartEditing(order: emptyOrder.copyWith(itemOrders: [item], total: 1.0)),
    //     CartEditing(
    //         order: emptyOrder.copyWith(itemOrders: [item, item2], total: 3.0)),
    //     CartEditing(order: emptyOrder.copyWith(itemOrders: [])),
    //   ];

    //   expectLater(cartBloc.state, emitsInOrder(expected));

    //   cartBloc.dispatch(InitializeCart());
    //   cartBloc.dispatch(AddItem(unitSale: packing, quantity: quantity));
    //   cartBloc.dispatch(AddItem(unitSale: packing2, quantity: quantity));
    //   cartBloc.dispatch(ClearCart());
    // });

    test(
        'should change paymentOption in response to a SelectPaymentOption event',
        () {
      Order emptyOrder = Order(
          branch: Branch(),
          itemOrders: List<ItemOrder>(),
          paymentOption: PaymentOption(),
          shipmentOption: ShipmentOption(),
          total: 0.0);
      PaymentOption paymentOption = PaymentOption(name: "TEST", percent: 90);
      final expected = [
        CartUninitialized(),
        CartEditing(order: emptyOrder),
        CartEditing(order: emptyOrder.copyWith(paymentOption: paymentOption))
      ];

      expectLater(cartBloc.state, emitsInOrder(expected));

      cartBloc.dispatch(InitializeCart());
      cartBloc.dispatch(SelectPaymentOption(paymentOption: paymentOption));
    });

    test(
        'should change shipmentOption in response to a SelectShipmentOption event',
        () {
      Order emptyOrder = Order(
          branch: Branch(),
          itemOrders: List<ItemOrder>(),
          paymentOption: PaymentOption(),
          shipmentOption: ShipmentOption(),
          total: 0.0);
      ShipmentOption shipmentOption = ShipmentOption(name: "TEST", percent: 90);
      final expected = [
        CartUninitialized(),
        CartEditing(order: emptyOrder),
        CartEditing(order: emptyOrder.copyWith(shipmentOption: shipmentOption))
      ];

      expectLater(cartBloc.state, emitsInOrder(expected));

      cartBloc.dispatch(InitializeCart());
      cartBloc.dispatch(SelectShipmentOption(shipmentOption: shipmentOption));
    });

    test('should change branch in response to a SelectBranchOption event', () {
      Order emptyOrder = Order(
          branch: Branch(),
          itemOrders: List<ItemOrder>(),
          paymentOption: PaymentOption(),
          shipmentOption: ShipmentOption(),
          total: 0.0);
      Branch branch = Branch(name: "TEST");
      final expected = [
        CartUninitialized(),
        CartEditing(order: emptyOrder),
        CartEditing(order: emptyOrder.copyWith(branch: branch))
      ];

      expectLater(cartBloc.state, emitsInOrder(expected));

      cartBloc.dispatch(InitializeCart());
      cartBloc.dispatch(SelectBranchOption(branchOption: branch));
    });

    test(
        'should replace existing order with the new order in the event SetOrder',
        () {
      
      int quantity = 1;
      Packing packing = Packing(
          name: "TEST",
          price:1,
          priceLists: [PriceList(code: "C", price: 1)],
          product: ProductProd());

      ItemOrder item =
          ItemOrder(quantity: quantity, unitSale: packing, subtotal: 1.0);

      int quantity2 = 2;
      Packing packing2 = Packing(
          name: "REPLACE",
          price:10,
          priceLists: [PriceList(code: "B", price: 10)],
          product: ProductProd());

      ItemOrder item2 =
          ItemOrder(quantity: quantity2, unitSale: packing2, subtotal: 20.0);

      Order replaceOrder = Order(
          branch: Branch(),
          itemOrders: [item2],
          paymentOption: PaymentOption(),
          shipmentOption: ShipmentOption(),
          total: 20.0);

      Order emptyOrder = Order(
          branch: Branch(),
          itemOrders: List<ItemOrder>(),
          paymentOption: PaymentOption(),
          shipmentOption: ShipmentOption(),
          total: 0.0);
      when(mockOrderRepository.getOrder(1)).thenAnswer((_) => Future.value(replaceOrder));

      final expected = [
        CartUninitialized(),
        CartEditing(order: emptyOrder),
        CartEditing(order: emptyOrder.copyWith(itemOrders: [item], total: 1.0)),
        CartEditing(order: replaceOrder)
      ];

      expectLater(cartBloc.state, emitsInOrder(expected));

      cartBloc.dispatch(InitializeCart());
      cartBloc.dispatch(AddItem(unitSale: packing, quantity: quantity));
      cartBloc.dispatch(SetOrder(orderId: 1));
    });
  });
}
