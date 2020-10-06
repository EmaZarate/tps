import 'package:andina_protos/models/customer.dart';
import 'package:andina_protos/models/order.dart';
import 'package:equatable/equatable.dart';

class Branch extends Equatable {
  final int id;
  final String name;
  final String address;
  final String city;
  final String province;
  final Customer customer;
  final List<Order> orders;

  Branch(
      {this.id,
      this.name,
      this.address,
      this.city,
      this.province,
      this.customer,
      this.orders})
      : super([id, name, address, city, province, customer, orders]);

  factory Branch.fromJson(Map<String, dynamic> json) {
    var orderGeneric = json['orders'] as List;
    List<Order> orders = List<Order>();
    if (orderGeneric != null) {
      orders = orderGeneric.map((o) => Order.fromJson(o)).toList();
    }

    return Branch(
      id: json['branchID'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      province: json['province'],
      customer:
          json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      orders: orders,
    );
  }

  Branch copyWith({int id, String name, String address, String city,
      String province, Customer customer, List<Order> orders}) {
    return Branch(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address ?? this.address,
        city: city ?? this.city,
        province: province ?? this.province,
        customer: customer ?? this.customer,
        orders: orders ?? this.orders);
  }


  toJson() {
    return {
      'branchID': id,
      'name': name,
      'address': address,
      'city': city,
      'province': province,
      'orders': orders
    };
  }
}
