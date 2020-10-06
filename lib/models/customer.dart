import 'package:andina_protos/models/branch.dart';
import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String id;
  final String username;
  final String email;
  final List<Branch> branches;
  final String businessName;
  final String img;
  final int shipmentDay;
  final int minimumLimit;

  Customer({this.id, this.username, this.email, this.branches, this.businessName, this.img, this.shipmentDay, this.minimumLimit})
      : super([id, username, branches, businessName, img, shipmentDay, minimumLimit]);

  factory Customer.fromJson(Map<String, dynamic> json) {
    var branchListGeneric = json['branches'] as List;
    List<Branch> branchList = List<Branch>();
    if (branchListGeneric != null) {
      branchList = branchListGeneric.map((p) => Branch.fromJson(p)).toList();
    }
    return Customer(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        branches: branchList,
        businessName: json['businessName'],
        img: json['image'],
        shipmentDay: json['shipmentDay'],
        minimumLimit: json['minimumLimit']);
  }

  Customer copyWith(String id, String username, List<Branch> branches,
      String businessName, String img, int shipmentDay, int minimumLimit) {
    return Customer(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        branches: branches ?? this.branches,
        businessName: businessName ?? this.businessName,
        img: img ?? this.img,
        shipmentDay: shipmentDay ?? this.shipmentDay,
        minimumLimit: minimumLimit ?? this.minimumLimit);
  }

  toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'branches': branches,
      'businessName': businessName,
      'image': img,
      'shipmentDay': shipmentDay,
      'minimumLimit': minimumLimit
    };
  }
}
