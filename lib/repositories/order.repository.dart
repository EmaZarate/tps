import 'package:andina_protos/api/api.client.dart';
import 'package:andina_protos/models/order.dart';
import 'package:meta/meta.dart';


class OrderRepository {
  final ApiClient apiClient;

  OrderRepository({@required this.apiClient})
    : assert(apiClient != null);


  Future<Order> getOrder(int id) async {
    var resp = await this.apiClient.getOrder(id);
    return resp;
  }
}