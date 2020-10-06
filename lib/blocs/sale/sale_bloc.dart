
import 'package:andina_protos/blocs/sale/sale_event.dart';
import 'package:andina_protos/blocs/sale/sale_state.dart';
import 'package:andina_protos/models/sale.dart';
import 'package:andina_protos/repositories/sales.repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class SaleBloc extends Bloc<SaleEvent, SaleState> {
  final SalesRepository salesRepository;

  SaleBloc({@required this.salesRepository}): assert(salesRepository != null);

  @override
  SaleState get initialState => SaleEmpty();

  @override
  Stream<SaleState> mapEventToState(
    SaleEvent event,
  ) async* {
    if(event is FetchSales) {
      yield SaleLoading();
      List<Sale> saleList = await salesRepository.getSales();
      yield SaleLoaded(sales: saleList);
    }
  }
}