import 'package:andina_protos/blocs/product/product_event.dart';
import 'package:andina_protos/blocs/product/product_state.dart';
import 'package:andina_protos/models/product.dart';
import 'package:andina_protos/repositories/products.repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductsRepository productsRepository;

  ProductBloc({@required this.productsRepository}): assert(productsRepository != null);

  @override
  ProductState get initialState => ProductEmpty();

  @override
  Stream<ProductState> mapEventToState(
    ProductEvent event,
  ) async* {
    if(event is FetchProducts) {
      yield ProductLoading();
      List<ProductProd> productList = await productsRepository.getProducts(event.categoriesFilter, event.searchText, event.page);
      yield ProductLoaded(products: productList);
    }
  }
}