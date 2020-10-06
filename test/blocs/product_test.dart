import 'package:andina_protos/blocs/product/product.dart';
import 'package:andina_protos/models/product.dart';
import 'package:andina_protos/repositories/products.repository.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockProductRepository extends Mock implements ProductsRepository {}

void main() {
  group('ProductBloc', () {
    ProductBloc productBloc;
    MockProductRepository mockProductRepository;

    setUp(() {
      mockProductRepository = MockProductRepository();

      when(mockProductRepository.getProducts())
          .thenAnswer((_) => Future.value(List<ProductProd>()));
      productBloc = ProductBloc(productsRepository: mockProductRepository);
    });

    test('initial state is CheckoutUninitialized', () {
      expect(productBloc.initialState, ProductEmpty());
    });
    test('dispose does not emit new states', () {
      expectLater(
        productBloc.state,
        emitsInOrder([ProductEmpty()]),
      );
      productBloc.dispose();
    });

    test('should get products in response to a FetchProducts event', () {
      final expected = [
        ProductEmpty(),
        ProductLoading(),
        ProductLoaded(products: List<ProductProd>()),
      ];

      expectLater(
        productBloc.state,
        emitsInOrder(expected),
      );

      productBloc.dispatch(FetchProducts());
    });
  });
}
