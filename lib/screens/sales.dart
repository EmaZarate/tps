import 'package:andina_protos/blocs/filtered_sales/filtered_sales.dart';
import 'package:andina_protos/blocs/sale/sale.dart';
import 'package:andina_protos/repositories/sales.repository.dart';
import 'package:andina_protos/widgets/common/search_bar.dart';
import 'package:andina_protos/widgets/sales/sale_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesScreem extends StatefulWidget {
  final SalesRepository salesRepository;

  const SalesScreem({Key key, @required this.salesRepository})
      : assert(salesRepository != null),
        super(key: key);

  @override
  _SalesScreemState createState() => _SalesScreemState();
}

class _SalesScreemState extends State<SalesScreem> {
  SaleBloc _saleBloc;
  FilteredSalesBloc _filteredSalesBloc;

  @override
  void initState() {
    // TODO: implement initState
    _saleBloc = SaleBloc(salesRepository: widget.salesRepository);
    _saleBloc.dispatch(FetchSales());
    _filteredSalesBloc = FilteredSalesBloc(saleBloc: _saleBloc);
    super.initState();
  }

  @override
  void dispose() {
    _saleBloc.dispose();
    _filteredSalesBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Promociones'),
      ),
      body: BlocBuilder(
          bloc: _filteredSalesBloc,
          builder: (_, FilteredSalesState state) {

            if (state is FilteredSalesLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is FilteredSalesLoaded) {
              final sales = state.sales;
              return SingleChildScrollView(
              child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: (mediaQuery.size.height -
                                mediaQuery.padding.top) *
                            0.1,
                        child: SearchBar(
                          callback: _searchBarFilter,hintText:'¿Que promoción buscas?'
                        ),
                      ),
                      Container(
                        height: (mediaQuery.size.height -
                                mediaQuery.padding.top) *
                            0.70,
                        child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: sales.length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:<Widget>[
                                Container(
                                  width: 230,
                                  child: SaleCard(sale: sales[index], purchase: false,)
                                  ),
                                SizedBox(height: 3.0,),
                                Divider(),
                                ]
                              );
                          },
                        ),
                      )
                    ],
                  ),
              );
            }
          }),
    );
  }
    _searchBarFilter(String searchText) {
    _filteredSalesBloc.dispatch(UpdateSearchBar(searchText));
  }
}
