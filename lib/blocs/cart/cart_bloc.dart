import 'package:andina_protos/models/branch.dart';
import 'package:andina_protos/models/customer.dart';
import 'package:andina_protos/models/item_order.dart';
import 'package:andina_protos/models/order.dart';
import 'package:andina_protos/models/payment_option.dart';
import 'package:andina_protos/models/shipment_option.dart';
import 'package:andina_protos/repositories/checkout.repository.dart';
import 'package:andina_protos/repositories/customer.repository.dart';
import 'package:andina_protos/repositories/order.repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CheckoutRepository checkoutRepository;
  final CustomerRepository customerRepository;
  final OrderRepository orderRepository;

  CartBloc(
      {@required this.checkoutRepository,
      this.customerRepository,
      this.orderRepository})
      : assert(checkoutRepository != null),
        assert(customerRepository != null),
        assert(orderRepository != null);

  @override
  CartState get initialState => CartUninitialized();

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is InitializeCart) {
      yield CartEditing(
          order: Order(
              itemOrders: List<ItemOrder>(),
              total: 0.00,
              shipmentOption: ShipmentOption(),
              paymentOption: PaymentOption(),
              branch: Branch()));
    }

    if (event is AddItem) {
      bool exist = false;
      double newTotal;
      List<ItemOrder> newList;
      if(event.quantity != null && event.quantity !=0){
        final ItemOrder newItem = ItemOrder(
          quantity: event.quantity,
          subtotal: event.unitSale.getPrice() * event.quantity,
          unitSale: event.unitSale);
      final List<ItemOrder> itemOrderList =
          List.from((currentState as CartEditing).order.itemOrders);

      itemOrderList.forEach((item) {
        if (item.unitSale.id == newItem.unitSale.id) {
          exist = true;
        }
      });

      if (exist) {
        newList = itemOrderList.map((item) {
          if (item.unitSale.id == newItem.unitSale.id) {
            final newSubtotal =
                (item.quantity + newItem.quantity) * item.unitSale.getPrice();
            return item = item.copyWith(
                quantity: item.quantity + newItem.quantity,
                subtotal: newSubtotal);
          } else {
            return item;
          }
        }).toList();
        newTotal = _calculateTotal(newList);
      }
      else{
        itemOrderList.add(newItem);
        newTotal = (currentState as CartEditing).order.total + newItem.subtotal;
      }

      yield (CartEditing(
          order: (currentState as CartEditing)
          .order
          .copyWith(itemOrders: exist ? newList : itemOrderList, total: newTotal)));
    }

    if (event is UpdateQuantity) {
      final double newSubtotal = event.unitSale.getPrice() * event.quantity;
      final List<ItemOrder> newList =
          (currentState as CartEditing).order.itemOrders.map((item) {
        if (item.unitSale == event.unitSale) {
          return item =
              item.copyWith(quantity: event.quantity, subtotal: newSubtotal);
        } else {
          return item;
        }
      }).toList();

      final double newTotal = _calculateTotal(newList);
      yield CartEditing(
          order: (currentState as CartEditing)
              .order
              .copyWith(itemOrders: newList, total: newTotal));
      }
    }

    if (event is RemoveItem) {
      final List<ItemOrder> newList =
          List.from((currentState as CartEditing).order.itemOrders);
      newList.removeWhere((item) => item.unitSale == event.unitSale);
      final double newTotal = _calculateTotal(newList);

      yield (CartEditing(
          order: (currentState as CartEditing)
              .order
              .copyWith(itemOrders: newList, total: newTotal)));
    }

    if (event is ClearCart) {
      final Order order = (currentState as CartEditing)
          .order
          .copyWith(itemOrders: List<ItemOrder>(), total: 0.00);
      yield (CartEditing(order: order));
    }

    if (event is SelectShipmentOption) {
      final Order order = (currentState as CartEditing)
          .order
          .copyWith(shipmentOption: event.shipmentOption);

      yield (CartEditing(order: order));
    }

    if (event is SelectPaymentOption) {
      final Order order = (currentState as CartEditing)
          .order
          .copyWith(paymentOption: event.paymentOption);

      yield (CartEditing(order: order));
    }

    if (event is SelectBranchOption) {
      final Order order = (currentState as CartEditing)
          .order
          .copyWith(branch: event.branchOption);
      yield CartEditing(order: order);
    }

    if (event is SeachOrder) {
      final Order order = await orderRepository.getOrder(event.orderId);

      yield CartEditing(order: order);
    }

    if (event is SetOrder) {

      yield CartEditing(order: event.order);
    }

    if (event is FinishOrder) {
      final Order order = (currentState as CartEditing).order;
      final Customer customerLogged = await customerRepository.getUser();
      var orderID =
          await checkoutRepository.finishOrder(order, customerLogged.id);
      yield CartFinished(orderID: orderID);
    }
  }

  double _calculateTotal(List<ItemOrder> items) {
    return items.fold(0.0, (prev, element) => prev + element.subtotal);
  }
}
