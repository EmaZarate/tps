import 'package:andina_protos/models/order.dart';
import 'package:andina_protos/repositories/customer.repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CustomerRepository customerRepository;

  OrderBloc({@required this.customerRepository});

  @override
  OrderState get initialState => OrderEmpty();

  @override
  Stream<OrderState> mapEventToState(
    OrderEvent event,
  ) async* {
    if(event is FetchOrders) {
      yield OrderLoading();
      final List<Order> orders = await customerRepository.getUserOrders();

      yield OrderLoaded(orders: orders);
    }
  }
}