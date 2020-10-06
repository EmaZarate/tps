import 'dart:async';

import 'package:andina_protos/blocs/filtered_sales/filtered_sales_event.dart';
import 'package:andina_protos/blocs/filtered_sales/filtered_sales_state.dart';
import 'package:andina_protos/blocs/sale/sale.dart';
import 'package:andina_protos/models/sale.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class FilteredSalesBloc extends Bloc<FilteredSalesEvent, FilteredSalesState> {
  final SaleBloc saleBloc;
  StreamSubscription productSubscription;

  FilteredSalesBloc({@required this.saleBloc}) {
    productSubscription = saleBloc.state.listen((state) {
      if (state is SaleLoaded) {
        dispatch(UpdateSales(
            (saleBloc.currentState as SaleLoaded).sales));
      }
    });
  }

  @override
  FilteredSalesState get initialState {
    return saleBloc.currentState is SaleLoaded
        ? FilteredSalesLoaded(
            (saleBloc.currentState as SaleLoaded).sales, "")
        : FilteredSalesLoading();
  }

  @override
  Stream<FilteredSalesState> mapEventToState(
    FilteredSalesEvent event,
  ) async* {
    if (event is UpdateFilter) {
      yield* _mapUpdateFilterToState(event);
    } else if (event is UpdateSales) {
      yield* _mapSalesUpdatedToState(event);
    } else if (event is UpdateSearchBar) {
      yield* _mapUpdateSearchBarToState(event);
    }
  }

  Stream<FilteredSalesState> _mapUpdateFilterToState(
      UpdateFilter event) async* {
    if (saleBloc.currentState is SaleLoaded) {
      yield FilteredSalesLoaded(
          _mapSalesToFilteredSales(
              (saleBloc.currentState as SaleLoaded).sales,

              (currentState as FilteredSalesLoaded).searchText),
          (currentState as FilteredSalesLoaded).searchText);
    }
  }

  Stream<FilteredSalesState> _mapSalesUpdatedToState(
      UpdateSales event) async* {


    final searchText = currentState is FilteredSalesLoaded
        ? (currentState as FilteredSalesLoaded).searchText
        : "";

    yield FilteredSalesLoaded(
        _mapSalesToFilteredSales(
            (saleBloc.currentState as SaleLoaded).sales,
            searchText),
        searchText);
  }

  Stream<FilteredSalesState> _mapUpdateSearchBarToState(
      UpdateSearchBar event) async* {
    if (saleBloc.currentState is SaleLoaded) {
      yield FilteredSalesLoaded(
          _mapSalesToFilteredSales(
              (saleBloc.currentState as SaleLoaded).sales,
              event.searchText
            ),
          event.searchText);
    }
  }

  List<Sale> _mapSalesToFilteredSales(List<Sale> sales, String searchText) {

    List<Sale> filteredSales;    
    filteredSales = sales;
    // if (categoriesFilter.isEmpty) {
    //   filteredProducts = products;
    // } else {
    //   filteredProducts = products
    //       .where((p) => categoriesFilter.contains(p.category.id))
    //       .toList();
    // }

    if(searchText.isEmpty) {
      return filteredSales;
    } else {
      return filteredSales.where((p) => p.name.toLowerCase().contains(searchText.toLowerCase())).toList();
    }
  }

  @override
  void dispose() {
    productSubscription.cancel();
    super.dispose();
  }
}
