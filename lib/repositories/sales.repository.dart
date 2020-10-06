import 'package:andina_protos/api/api.client.dart';
import 'package:andina_protos/models/sale.dart';
import 'package:meta/meta.dart';


class SalesRepository {
  final ApiClient apiClient;

  SalesRepository({@required this.apiClient})
    : assert(apiClient != null);


  Future<List<Sale>> getSales() async {
    var resp =await this.apiClient.getSales();
    return resp;
  }
}