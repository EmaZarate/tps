import 'package:andina_protos/models/branch.dart';
import 'package:andina_protos/models/item_order.dart';
import 'package:andina_protos/models/payment_option.dart';
import 'package:andina_protos/models/shipment_option.dart';
import 'package:andina_protos/models/state_order.dart';
import 'package:equatable/equatable.dart';

class Order extends Equatable {
  final int id;
  final double total;
  final PaymentOption paymentOption;
  final ShipmentOption shipmentOption;
  final StateOrder stateOrder;
  final List<ItemOrder> itemOrders;
  final Branch branch;
  final int percentPaymentOption;
  final int percentShipmentOption;

  Order(
      {this.id,
      this.total,
      this.paymentOption,
      this.shipmentOption,
      this.stateOrder,
      this.itemOrders,
      this.branch,
      this.percentPaymentOption,
      this.percentShipmentOption
      })
      : super([
          id,
          total,
          paymentOption,
          shipmentOption,
          stateOrder,
          itemOrders,
          branch
        ]);

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemOrderListGeneric = json['itemOrders'] as List;
    List<ItemOrder> itemOrderList;
    if (itemOrderListGeneric != null) {
      itemOrderList =
          itemOrderListGeneric.map((io) => ItemOrder.fromJson(io)).toList();
    }

    return Order(
        id: json['orderID'],
        total: json['total'],
        paymentOption: json['paymentOption_Navigation'] != null
            ? PaymentOption.fromJson(json['paymentOption_Navigation'])
            : null,
        shipmentOption: json['shipmentOption_Navigation'] != null
            ? ShipmentOption.fromJson(json['shipmentOption_Navigation'])
            : null,
        stateOrder: json['orderState'] != null
            ? StateOrder.fromJson(json['orderState'])
            : null,
        percentPaymentOption: json['percentPaymentOption'],
        percentShipmentOption: json['percentShipmentOption'],
        itemOrders: itemOrderList,
        branch:
            json['branch_Navigation'] != null ? Branch.fromJson(json['branch_Navigation']) : null);
  }

  Order copyWith(
      {int id,
      double total,
      PaymentOption paymentOption,
      ShipmentOption shipmentOption,
      StateOrder stateOrder,
      List<ItemOrder> itemOrders,
      Branch branch}) {
    return Order(
        id: id ?? this.id,
        total: total ?? this.total,
        paymentOption: paymentOption ?? this.paymentOption,
        shipmentOption: shipmentOption ?? this.shipmentOption,
        stateOrder: stateOrder ?? this.stateOrder,
        itemOrders: itemOrders ?? this.itemOrders,
        branch: branch ?? this.branch);
  }

  toJson() {
    return {
      'orderID': id,
      'total': total,
      'paymentOption_Navigation': paymentOption,
      'shipmentOption_Navigation': shipmentOption,
      'orderState': stateOrder,
      'itemOrders': itemOrders,
      'branch_Navigation': branch,
      'percentShipmentOption': percentShipmentOption,
      'percentPaymentOption': percentPaymentOption
    };
  }
}
