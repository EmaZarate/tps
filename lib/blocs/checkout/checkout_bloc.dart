import 'package:andina_protos/models/branch.dart';
import 'package:andina_protos/models/payment_option.dart';
import 'package:andina_protos/models/shipment_option.dart';
import 'package:andina_protos/repositories/checkout.repository.dart';
import 'package:andina_protos/repositories/customer.repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'checkout_event.dart';
import 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutRepository checkoutRepository;
  final CustomerRepository customerRepository;

  CheckoutBloc(
      {@required this.checkoutRepository, @required this.customerRepository})
      : assert(checkoutRepository != null),
        assert(customerRepository != null);

  @override
  CheckoutState get initialState => CheckoutUninitialized();

  @override
  Stream<CheckoutState> mapEventToState(
    CheckoutEvent event,
  ) async* {
    if (event is LoadOptions) {
      yield CheckoutLoading();

      final List<Branch> branches = await customerRepository.getUserBranch();
      final List<ShipmentOption> shipmentOptions =
          await checkoutRepository.getShipmentOptions();
      final List<PaymentOption> paymentOptions =
          await checkoutRepository.getPaymentOptions();

      yield CheckoutLoaded(
          branches: branches,
          shipmentOptions: shipmentOptions,
          paymentOptions: paymentOptions);
    }

    if (event is RefreshOptions) {
      //At the moment this event does the same as LoadOptions but in the future, LoadOptions can do something else

      try {

        final List<Branch> branches = await customerRepository.getUserBranch();
        final List<ShipmentOption> shipmentOptions =
            await checkoutRepository.getShipmentOptions(true);
        final List<PaymentOption> paymentOptions =
            await checkoutRepository.getPaymentOptions(true);

        yield CheckoutLoaded(
           forceChange: !(currentState as CheckoutLoaded).forceChange,
            branches: branches,
            shipmentOptions: shipmentOptions,
            paymentOptions: paymentOptions);
      } catch (_) {
        yield currentState;
      }
    }
  }
}
