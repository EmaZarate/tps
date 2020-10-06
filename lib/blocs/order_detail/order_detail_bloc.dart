import 'package:andina_protos/blocs/order_detail/order_detail_event.dart';
import 'package:andina_protos/blocs/order_detail/order_detail_state.dart';
import 'package:andina_protos/models/order.dart';
import 'package:andina_protos/repositories/order.repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState>{

  final OrderRepository orderRepository;

  OrderDetailBloc({@required this.orderRepository}): assert(orderRepository != null);

  @override
  OrderDetailState get initialState => OrderDetailEmpty();

  @override
  Stream<OrderDetailState> mapEventToState(OrderDetailEvent event) async*{
     if(event is FetchOrder){
      yield OrderDetailLoading();
      Order order = await orderRepository.getOrder(event.orderId);
      yield OrderDetailLoaded(order:order);
     }
  }
}