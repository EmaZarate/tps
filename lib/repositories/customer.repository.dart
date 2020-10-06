import 'package:andina_protos/api/api.client.dart';
import 'package:andina_protos/models/auth.dart';
import 'package:andina_protos/models/branch.dart';
import 'package:andina_protos/models/change_password.dart';
import 'package:andina_protos/models/customer.dart';
import 'package:andina_protos/models/order.dart';
import 'package:meta/meta.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CustomerRepository {
  final ApiClient apiClient;

  CustomerRepository({@required this.apiClient});

  Future<Auth> authenticate({
    @required String username,
    @required String password,
  }) async {
    final auth = await apiClient.loginCustomer(username, password);
    // await Future.delayed(Duration(seconds: 1));
    return auth;
  }

  Future<Customer> getMe({@required String id}) async {
    final Customer customer = await apiClient.getMe(id: id);

    return customer;
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    //Delete from keystore/keychain
    prefs.remove('auth_token');
    // await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_token', token);
    //write to keystore/keychain
    // await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? null;
    //read from keystore/keychain
    if (token != null) {
      return _isValidToken(token);
    }
    // await Future.delayed(Duration(seconds: 1));
    return false;
  }

  Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    //Delete from keystore/keychain
    prefs.remove('user');
    // await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistUser(Customer user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(user));
    //write to keystore/keychain
    // await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<Customer> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userEncoded = prefs.getString('user') ?? null;

    //read from keystore/keychain
    if (userEncoded != null) {
      return Customer.fromJson(jsonDecode(userEncoded));
    }
    // await Future.delayed(Duration(seconds: 1));
    return null;
  }

  Future<List<Branch>> getUserBranch() async {
    final userLoged = await this.getUser();
    return userLoged?.branches ?? null;
  }

  Future<List<Order>> getUserOrders() async {
    final userLoged = await this.getUser();
    List<Order> orders = List<Order>();
    //userLoged.branches.forEach((b) => orders.addAll(b.orders));
    orders = await apiClient.getOrders(userLoged.id);
    return orders;
  }

  Future addBranch(String customerId, Branch branch) async {
    await apiClient.addBranch(customerId, branch);
  }

  Future updateBranch(String customerId, Branch branch) async {
    await apiClient.updateBranch(customerId, branch);
  }

  Future removeBranch(String customerId, int branchId) async {
    await apiClient.removeBranch(customerId, branchId);
  }

  Future changePassword(ChangePassword changePassword) async {
    await apiClient.changePassword(changePassword);
  }

  _isValidToken(String token) {
    Map<String, dynamic> tokenDecoded = _parseJWT(token);
    final expirationTime = tokenDecoded["exp"];
    if((DateTime.now().millisecondsSinceEpoch / 1000) < expirationTime){
      return true;
    }
    
    return false;
  }

  _parseJWT(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }
}
