import 'package:andina_protos/api/api.client.dart';
import 'package:andina_protos/config/cache_item.model.dart';
import 'package:andina_protos/models/order.dart';

import 'package:meta/meta.dart';

import 'package:andina_protos/models/payment_option.dart';
import 'package:andina_protos/models/shipment_option.dart';

class CheckoutRepository {
  final ApiClient apiClient;
  CacheListItem<ShipmentOption> shipmentOptionsCache = new CacheListItem<ShipmentOption>(listCached: []);
  CacheListItem<PaymentOption> paymentOptionsCache = new CacheListItem<PaymentOption>(listCached: []);

  CheckoutRepository({@required this.apiClient});

  Future<List<ShipmentOption>> getShipmentOptions([withoutCache = false]) async {
    if(!this.shipmentOptionsCache.canReturnCached() || withoutCache){
      shipmentOptionsCache = shipmentOptionsCache.copyWith(
        listCached: await this.apiClient.getShipmentOptions(),
        millisecondsSinceEpochWhenCached: DateTime.now().millisecondsSinceEpoch
      );
    }
    return Future.value(shipmentOptionsCache.listCached);
  }

  Future<List<PaymentOption>> getPaymentOptions([withoutCache = false]) async {
    if(!this.paymentOptionsCache.canReturnCached() || withoutCache){
      // final paymentOptions = 
      paymentOptionsCache = paymentOptionsCache.copyWith(
        listCached: await this.apiClient.getPaymentOptions(),
        millisecondsSinceEpochWhenCached: DateTime.now().millisecondsSinceEpoch
      );
    }
    return Future.value(paymentOptionsCache.listCached);
  }

  Future<int> finishOrder(Order order, String customerId) async {
    return await this.apiClient.finishOrder(order, customerId);
  }
}