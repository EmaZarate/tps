import 'dart:async';
import 'package:andina_protos/blocs/filtered_products/filtered_products_event.dart';
import 'package:andina_protos/blocs/filtered_products/filtered_products_state.dart';
import 'package:andina_protos/blocs/product/product.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:andina_protos/models/product.dart';

class FilteredProductsBloc
    extends Bloc<FilteredProductsEvent, FilteredProductsState> {
  final ProductBloc productBloc;
  StreamSubscription productSubscription;

  FilteredProductsBloc({@required this.productBloc}) {
    productSubscription = productBloc.state.listen((state) {
      if (state is ProductLoaded) {
        dispatch(UpdateProducts(
            (productBloc.currentState as ProductLoaded).products));
      }
    });
  }

  @override
  FilteredProductsState get initialState {
    return productBloc.currentState is ProductLoaded
        ? FilteredProductsLoaded(
            (productBloc.currentState as ProductLoaded).products, List<int>(), "", 1)
        : FilteredProductsLoading(List<int>(), "", 1);
  }

  @override
  Stream<FilteredProductsState> mapEventToState(
    FilteredProductsEvent event,
  ) async* {
    if (event is UpdateFilter) {
      yield* _mapUpdateFilterToState(event);
    } else if (event is UpdateProducts) {
      yield* _mapProductsUpdatedToState(event);
    } else if (event is UpdateSearchBar) {
      yield* _mapUpdateSearchBarToState(event);
    } else if(event is LoadNewPage){
      yield* _mapUpdatePageToState();
    }
  }

  Stream<FilteredProductsState> _mapUpdateFilterToState(
      UpdateFilter event) async* {
    if (productBloc.currentState is ProductLoaded) {
      yield FilteredProductsLoading(event.categoriesFilter, (currentState as FilteredProductsLoaded).searchText, 1);
      _mapProductsToFilteredProducts(event.categoriesFilter, (currentState as FilteredProductsLoaded).searchText, 1);
    }
  }

  Stream<FilteredProductsState> _mapProductsUpdatedToState(UpdateProducts event) async* {
    int page;
    List<int> categoriesFilter;
    String searchText;
    List<ProductProd> products; 
    if(currentState is FilteredProductsLoadingPage){
       categoriesFilter = (currentState as FilteredProductsLoadingPage).categoriesFilter;
       searchText = (currentState as FilteredProductsLoadingPage).searchText;
       page = (currentState as FilteredProductsLoadingPage).page;
       products = (currentState as FilteredProductsLoadingPage).products;
       products.addAll(event.products);
    }
    else if(currentState is FilteredProductsLoaded){
      categoriesFilter = (currentState as FilteredProductsLoaded).categoriesFilter;
      searchText = (currentState as FilteredProductsLoaded).searchText;
      page = (currentState as FilteredProductsLoaded).page; 
      products = event.products;
    }
    else if(currentState is FilteredProductsLoading){
      categoriesFilter = (currentState as FilteredProductsLoading).categoriesFilter;
      searchText = (currentState as FilteredProductsLoading).searchText;
      page = (currentState as FilteredProductsLoading).page;
      products = event.products;
    }
    yield FilteredProductsLoaded(products, categoriesFilter, searchText, page);
  }

  Stream<FilteredProductsState> _mapUpdateSearchBarToState(
      UpdateSearchBar event) async* {
    if (productBloc.currentState is ProductLoaded) {
      yield FilteredProductsLoading((currentState as FilteredProductsLoaded).categoriesFilter, event.searchText, 1);
      _mapProductsToFilteredProducts((currentState as FilteredProductsLoaded).categoriesFilter, event.searchText, 1);
    }
  }

  Stream<FilteredProductsState> _mapUpdatePageToState() async* {
    if (productBloc.currentState is ProductLoaded) {
      yield FilteredProductsLoadingPage((currentState as FilteredProductsLoaded).categoriesFilter, (currentState as FilteredProductsLoaded).searchText, (currentState as FilteredProductsLoaded).page + 1, (currentState as FilteredProductsLoaded).products);
      _mapProductsToFilteredProducts((currentState as FilteredProductsLoaded).categoriesFilter, (currentState as FilteredProductsLoaded).searchText, (currentState as FilteredProductsLoaded).page + 1);
    }
  }

  void _mapProductsToFilteredProducts(List<int> categoriesFilter, String searchText, int page) {
    productBloc.dispatch(FetchProducts(categoriesFilter, searchText, page));
  }

  @override
  void dispose() {
    productSubscription.cancel();
    super.dispose();
  }
}
