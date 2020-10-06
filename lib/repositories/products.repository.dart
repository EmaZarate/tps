import 'package:andina_protos/api/api.client.dart';
import 'package:andina_protos/models/product.dart';
import 'package:meta/meta.dart';


class ProductsRepository {
  final ApiClient apiClient;

  ProductsRepository({@required this.apiClient})
    : assert(apiClient != null);


  Future<List<ProductProd>> getProducts(List<int> categoriesFilter, String seachText, int page) async {
    var resp =await this.apiClient.getProducts(categoriesFilter, seachText, page);
    return resp;
  }
}