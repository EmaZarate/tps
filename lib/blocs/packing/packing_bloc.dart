import 'package:andina_protos/blocs/packing/packing_event.dart';
import 'package:andina_protos/blocs/packing/packing_state.dart';
import 'package:andina_protos/models/item_order.dart';
import 'package:andina_protos/models/packing.dart';
import 'package:bloc/bloc.dart';

class PackingBloc extends Bloc<PackingEvent, PackingState> {
  @override
  PackingState get initialState => UnselectedPacking();

  @override
  Stream<PackingState> mapEventToState(
    PackingEvent event,
  ) async* {
    if (event is SelectPacking) {
      Packing packing =
          event.packings.firstWhere((packing) => packing.id == event.packingId);
      ItemOrder item =
          ItemOrder(unitSale: packing.copyWith(product: event.product), quantity: 0);
      
      yield SelectedPacking(item: item);
    }

    if (event is SelectQuantity) {
      if (currentState is SelectedPacking) {
        double subtotal = 0.0;
        final ItemOrder currentItem = (currentState as SelectedPacking).item;
        if (currentItem.unitSale != null) {
          subtotal = event.quantity * currentItem.unitSale.getPrice();
        }

        yield SelectedPacking(
            item: currentItem.copyWith(
                quantity: event.quantity, subtotal: subtotal));
      }
    }

    if(event is CleanSelection) {
      yield UnselectedPacking();
    }
  }
}
