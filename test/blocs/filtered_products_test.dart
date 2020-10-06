import 'package:andina_protos/blocs/filtered_products/filtered_products.dart';
import 'package:andina_protos/blocs/product/product.dart';
import 'package:andina_protos/models/category.dart';
import 'package:andina_protos/models/packing.dart';
import 'package:andina_protos/models/product.dart';
import 'package:andina_protos/repositories/products.repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockProductBloc extends Mock implements ProductBloc {}

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  List<ProductProd> initialList = [
    ProductProd(
      name: 'test',
      category: Category(name: 'C1', id: 1),
      hasStock: true,
      img: 'img',
      packing: [Packing()],
    ),
    ProductProd(
      name: 'testfilter2',
      category: Category(name: 'C2', id: 2),
      hasStock: true,
      img: 'img',
      packing: [Packing()],
    ),
    ProductProd(
      name: 'testfilter3',
      category: Category(name: 'C2', id: 2),
      hasStock: true,
      img: 'img',
      packing: [Packing()],
    ),
    ProductProd(
      name: 'test4',
      category: Category(name: 'C3', id: 3),
      hasStock: true,
      img: 'img',
      packing: [Packing()],
    )
  ];

  group('FilteredProductsBloc connection with ProductsBloc', () {
    FilteredProductsBloc filteredProductsBloc;
    MockProductsRepository mockProductsRepository;
    ProductBloc productBloc;

    setUp(() {
      mockProductsRepository = MockProductsRepository();
      productBloc = ProductBloc(productsRepository: mockProductsRepository);
      filteredProductsBloc = FilteredProductsBloc(productBloc: productBloc);

      when(mockProductsRepository.getProducts())
          .thenAnswer((_) => Future.value(List<ProductProd>()));
    });

    test(
        'dispatches FilteredProductsLoaded when ProductsBloc.state emits ProductLoaded',
        () {
      final expect = [
        FilteredProductsLoading(),
        FilteredProductsLoaded(List<ProductProd>(), List<int>(), ''),
      ];

      expectLater(filteredProductsBloc.state, emitsInOrder(expect));

      productBloc.dispatch(FetchProducts());
    });
  });

  group('FilteredProductsBloc', () {
    FilteredProductsBloc filteredProductsBloc;
    MockProductBloc mockProductBloc;

    setUp(() {
      mockProductBloc = MockProductBloc();

      when(mockProductBloc.state)
          .thenAnswer((_) => Stream<ProductState>.empty());

      when(mockProductBloc.currentState)
          .thenReturn(ProductLoaded(products: initialList));

      filteredProductsBloc = FilteredProductsBloc(productBloc: mockProductBloc);
    });

    test('should update categories filter when UpdateFilter is dispatched', () {
      final expect = [
        FilteredProductsLoaded(initialList, List<int>(), ''),
        FilteredProductsLoaded(initialList, [1, 2, 3], ''),
      ];

      expectLater(filteredProductsBloc.state, emitsInOrder(expect));

      filteredProductsBloc.dispatch(UpdateFilter([1, 2, 3]));
    });

    test(
        'should update products list when UpdateFilter with one filter is dispatched',
        () {
      final expect = [
        FilteredProductsLoaded(initialList, List<int>(), ''),
        FilteredProductsLoaded([initialList[0]], [1], ''),
      ];

      expectLater(filteredProductsBloc.state, emitsInOrder(expect));

      filteredProductsBloc.dispatch(UpdateFilter([1]));
    });

    test(
        'should update products list when UpdateFilter with more than one filter is dispatched',
        () {
      final expect = [
        FilteredProductsLoaded(initialList, List<int>(), ''),
        FilteredProductsLoaded(
            [initialList[0], initialList[1], initialList[2]], [1, 2], ''),
      ];

      expectLater(filteredProductsBloc.state, emitsInOrder(expect));

      filteredProductsBloc.dispatch(UpdateFilter([1, 2]));
    });

    test('should update products list when UpdateSearchBar is dispatched', () {
      final expect = [
        FilteredProductsLoaded(initialList, List<int>(), ''),
        FilteredProductsLoaded(
            [initialList[1], initialList[2]], List<int>(), 'testfilter'),
      ];

      expectLater(filteredProductsBloc.state, emitsInOrder(expect));

      filteredProductsBloc.dispatch(UpdateSearchBar('testfilter'));
    });

    test('should update products list with filter and searchbar when both events UpdateFilter and UpdateSearchBar are dispatched', () {
      final expect = [
        FilteredProductsLoaded(initialList, List<int>(), ''),
       FilteredProductsLoaded(
            [initialList[0], initialList[1], initialList[2]], [1, 2], ''),
        FilteredProductsLoaded(
            [initialList[1], initialList[2]], [1, 2], 'testfilter'),
      ];

      expectLater(filteredProductsBloc.state, emitsInOrder(expect));

      filteredProductsBloc.dispatch(UpdateFilter([1, 2]));
      filteredProductsBloc.dispatch(UpdateSearchBar('testfilter'));
    });
  });
}
