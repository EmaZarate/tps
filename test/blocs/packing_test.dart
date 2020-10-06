import 'package:andina_protos/blocs/packing/packing.dart';
import 'package:andina_protos/models/item_order.dart';
import 'package:andina_protos/models/packing.dart';
import 'package:andina_protos/models/price_list.dart';
import 'package:andina_protos/models/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  List<Packing> packings = [
    Packing(
      id: 1,
      name: 'P1',
      price: 10,
      priceLists: [
        PriceList(id: 1, price: 10),
      ],
      product: ProductProd(id: 1, name: 'P1'),
    ),
    Packing(
      id: 2,
      name: 'P2',
      price: 10,
      priceLists: [
        PriceList(id: 1, price: 10),
      ],
      product: ProductProd(id: 2, name: 'P2'),
    ),
    Packing(
      id: 3,
      price: 10,
      name: 'P3',
      priceLists: [
        PriceList(id: 1, price: 10),
      ],
      product: ProductProd(id: 1, name: 'P1'),
    ),
  ];
  group('PackingBloc', () {
    PackingBloc packingBloc;

    setUp(() {
      packingBloc = PackingBloc();
    });

    test('initial state is UnselectedPacking', () {
      expect(packingBloc.initialState, UnselectedPacking());
    });
    test('dispose does not emit new states', () {
      expectLater(
        packingBloc.state,
        emitsInOrder([UnselectedPacking()]),
      );
      packingBloc.dispose();
    });

    test('should return packing as itemOrder when SelectPacking is dispatched',
        () {
      final expected = [
        UnselectedPacking(),
        SelectedPacking(item: ItemOrder(unitSale: packings[0])),
      ];

      expectLater(
        packingBloc.state,
        emitsInOrder(expected),
      );

      packingBloc.dispatch(SelectPacking(
          packings: packings, product: packings[0].product, packingId: 1));
    });

    test(
        'should update quantity if the actual state is SelectedPacking and dispatch SelectQuantity event',
        () {
      final expected = [
        UnselectedPacking(),
        SelectedPacking(item: ItemOrder(unitSale: packings[0])),
        SelectedPacking(
          item: ItemOrder(unitSale: packings[0], quantity: 2, subtotal: 20.0),
        ),
      ];

      expectLater(
        packingBloc.state,
        emitsInOrder(expected),
      );

      packingBloc.dispatch(
        SelectPacking(
            packings: packings, product: packings[0].product, packingId: 1),
      );
      packingBloc.dispatch(SelectQuantity(quantity: 2));
    });

    test(
        'should not update quantity if the actual state is not SelectedPacking and dispatch SelectQuantity event',
        () {
      final expected = [
        UnselectedPacking(),
      ];

      expectLater(
        packingBloc.state,
        emitsInOrder(expected),
      );

      packingBloc.dispatch(SelectQuantity(quantity: 2));
    });

    test(
        'should unselect packing and quanitity if CleanSelection is dispatched',
        () {
      final expected = [
        UnselectedPacking(),
        SelectedPacking(item: ItemOrder(unitSale: packings[0])),
        SelectedPacking(
          item: ItemOrder(unitSale: packings[0], quantity: 2, subtotal: 20.0),
        ),
        UnselectedPacking(),
      ];

      expectLater(
        packingBloc.state,
        emitsInOrder(expected),
      );

      packingBloc.dispatch(
        SelectPacking(
            packings: packings, product: packings[0].product, packingId: 1),
      );
      packingBloc.dispatch(SelectQuantity(quantity: 2));
      packingBloc.dispatch(CleanSelection());
    });
  });
}
