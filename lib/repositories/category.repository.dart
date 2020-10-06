import 'package:andina_protos/api/api.client.dart';
import 'package:andina_protos/config/cache_item.model.dart';
import 'package:andina_protos/models/category.dart';
import 'package:meta/meta.dart';

class CategoryRepository {
  CacheListItem<Category> _cachedCategories = new CacheListItem<Category>(listCached: []);

  final ApiClient apiClient;

  CategoryRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<List<Category>> getCategories() async {
    if (!_cachedCategories.canReturnCached()) {
      _cachedCategories = _cachedCategories.copyWith(
          listCached: await this.apiClient.getCategories(),
          millisecondsSinceEpochWhenCached:
              DateTime.now().millisecondsSinceEpoch);
    }

    return Future.value(_cachedCategories.listCached);
  }
}
