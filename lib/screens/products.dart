import 'dart:async';
import 'package:andina_protos/models/product.dart';

import 'package:andina_protos/blocs/filtered_products/filtered_products.dart';
import 'package:andina_protos/blocs/product/product.dart';
import 'package:andina_protos/blocs/sale/sale.dart';
import 'package:andina_protos/blocs/sale/sale_bloc.dart';
import 'package:andina_protos/repositories/category.repository.dart';
import 'package:andina_protos/repositories/checkout.repository.dart';
import 'package:andina_protos/repositories/customer.repository.dart';
import 'package:andina_protos/repositories/sales.repository.dart';
import 'package:andina_protos/widgets/products/product_edit_manager.dart';
import 'package:andina_protos/widgets/products/total.dart';

import 'package:andina_protos/repositories/products.repository.dart';
import 'package:andina_protos/widgets/products/filter_chips.dart';
import 'package:andina_protos/widgets/common/search_bar.dart';
import 'package:andina_protos/widgets/sales/sale_card.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';

class ProductsScreen extends StatefulWidget {
  final ProductsRepository productRepository;
  final CategoryRepository categoryRepository;
  final CheckoutRepository checkoutRepository;
  final CustomerRepository customerRepository;
  final SalesRepository salesRepository;

  ProductsScreen(
      {Key key,
      @required this.productRepository,
      @required this.categoryRepository,
      @required this.checkoutRepository,
      @required this.customerRepository,
      @required this.salesRepository})
      : assert(productRepository != null),
        assert(categoryRepository != null),
        assert(checkoutRepository != null),
        assert(salesRepository != null),
        super(key: key);

  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  ScrollController _scrollController = new ScrollController(initialScrollOffset: 500, keepScrollOffset: true);

  ProductBloc _productBloc;
  SaleBloc _saleBloc;
  
  FilteredProductsBloc _filteredProductsBloc;
  Completer<void> _refreshCategoriesCompleter;

  final _salesPageController =
      PageController(initialPage: 2, viewportFraction: 1 / 2);

  @override
  void initState() {
    _productBloc = ProductBloc(productsRepository: widget.productRepository);
    _saleBloc = SaleBloc(salesRepository: widget.salesRepository);
    _saleBloc.dispatch(FetchSales());
    _productBloc.dispatch(FetchProducts([], "",1));
    _filteredProductsBloc = FilteredProductsBloc(productBloc: _productBloc);
    _scrollController.addListener(() {
       if(_productBloc.currentState is ProductLoaded && _scrollController.position.pixels == _scrollController.position.maxScrollExtent){
          _filteredProductsBloc.dispatch(LoadNewPage());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _productBloc.dispose();
    _filteredProductsBloc.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      actions: <Widget>[
        Total(),
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.pushNamed(context, '/checkout');
          },
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            BlocBuilder(
              bloc: _saleBloc,
              builder: (_, SaleState state) {
                if (state is SaleLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is SaleLoaded) {
                  return Container(
                    margin: EdgeInsets.only(top: 22.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Promociones',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 25.0),
                            ),
                          ],
                        ),
                        Container(
                          width: mediaQuery.size.width,
                          height: 340.0,
                          child: PageView.builder(
                            pageSnapping: false,
                            controller: _salesPageController,
                            itemCount: state.sales.length,
                            itemBuilder:
                                (BuildContext context, int index) {
                              return SaleCard(
                                sale: state.sales[index],
                                purchase: true,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            Text('Productos',
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 25.0)),
            Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.1,
              child: SearchBar(
                callback: _searchBarFilter,
                hintText: "¿Que producto buscas?",
              ),
            ),
            SizedBox(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.03,
            ),
            Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.1,
              child: FilterChips(
                filteredProductsBloc: _filteredProductsBloc,
                categoryRepository: widget.categoryRepository,
              ),
            ),
            BlocBuilder(
            bloc: _filteredProductsBloc,
              builder: (_, FilteredProductsState state) {
                if (state is FilteredProductsLoading) {
                return Center(child: CircularProgressIndicator());
                }
                else if (state is FilteredProductsLoaded || state is FilteredProductsLoadingPage) {
                List<ProductProd> products;
                (state is FilteredProductsLoaded) ? products = state.products : products = (state as FilteredProductsLoadingPage).products;
                return Stack(
                  children:<Widget>[
                    Container(
                        height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                        0.75,
                        margin: EdgeInsets.only(bottom: 50.0),
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                          return ProductEditManager(
                            product: products[index],
                            returnFlushbar: _returnFlushbar,
                          );
                        },
                        ),
                    ),
                    _returnLoadingPage(state, mediaQuery)
                  ]
                );                
                } 
              }
            )
          ],
        ),
      )
    );
  }

  _searchBarFilter(String searchText) {
    _filteredProductsBloc.dispatch(UpdateSearchBar(searchText));
  }

  Widget _returnLoadingPage(FilteredProductsState state, MediaQueryData mediaQuery ){
     if(state is FilteredProductsLoadingPage){
       return Center(
          child: Container(
            height: mediaQuery.size.height / 1.39,
            child: Align(
            alignment: Alignment.bottomCenter,
            child: CircularProgressIndicator(),
            ),
          ),
       );
    } else{
      return Container();
    }
  }

  _returnFlushbar(BuildContext context) {
    return Flushbar(
      title: 'Producto añadido',
      icon: Icon(Icons.check_circle_outline,
          size: 28.0, color: Colors.green[300]),
      message: 'El producto se añadio correctamente al carrito',
      leftBarIndicatorColor: Colors.green[300],
      duration: Duration(seconds: 5),
    )..show(context);
  }
  
}
