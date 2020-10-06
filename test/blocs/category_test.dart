import 'package:andina_protos/blocs/category/category.dart';
import 'package:andina_protos/blocs/filtered_products/filtered_products.dart';
import 'package:andina_protos/models/category.dart';
import 'package:andina_protos/repositories/category.repository.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockFilteredProductsBloc extends Mock implements FilteredProductsBloc {}

class MockCategoryRepository extends Mock implements CategoryRepository {}

List<Category> categories;

void main() {
  group('CategoryBloc', () {
    CategoryBloc categoryBloc;
    MockCategoryRepository mockCategoryRepository;
    MockFilteredProductsBloc mockFilteredProductsBloc;
    setUp(() {
      categories = [
        Category(id: 1, isSelected: false, name: "C1"),
        Category(id: 2, isSelected: true, name: "C2"),
        Category(id: 3, isSelected: false, name: "C3"),
      ];

      mockCategoryRepository = MockCategoryRepository();
      mockFilteredProductsBloc = MockFilteredProductsBloc();

      when(mockCategoryRepository.getCategories())
          .thenAnswer((_) => Future.value(categories));

      categoryBloc = CategoryBloc(
          categoryRepository: mockCategoryRepository,
          filteredProductsBloc: mockFilteredProductsBloc);
    });

    test('initial state is CategoryEmpty', () {
      expect(categoryBloc.initialState, CategoryEmpty());
    });

    test('dispose does not emit new states', () {
      expectLater(
        categoryBloc.state,
        emitsInOrder([CategoryEmpty()]),
      );
      categoryBloc.dispose();
    });

    test('should load categories when event is FetchCategories', () {
      final expected = [
        CategoryEmpty(),
        CategoryLoading(),
        CategoryLoaded(categories: categories)
      ];

      expectLater(
        categoryBloc.state,
        emitsInOrder(expected),
      );

      categoryBloc.dispatch(FetchCategories());
    });

    test(
        'should mark isSelected=true when event is AddedFilter and filteredProductsBloc state != FilteredProductsLoaded',
        () {
      categoryBloc.dispatch(FetchCategories());
      final List<Category> categoriesModified =
          categoryBloc.modifyList(true, categories[0], categories);

      categoryBloc.dispatch(AddedFilter(categories[0]));
      final expected = [
        CategoryEmpty(),
        CategoryLoading(),
        CategoryLoaded(categories: categories),
        CategoryLoaded(categories: categoriesModified)
      ];

      expectLater(
        categoryBloc.state,
        emitsInOrder(expected),
      ).then((_) => verifyNever(mockFilteredProductsBloc.dispatch(any)));
    });

    test(
        'should mark isSelected=false when event is RemoveFilter and filteredProductsBloc state != FilteredProductsLoaded',
        () {
      categoryBloc.dispatch(FetchCategories());
      final List<Category> categoriesModified =
          categoryBloc.modifyList(false, categories[1], categories);

      categoryBloc.dispatch(RemovedFilter(categories[1]));
      final expected = [
        CategoryEmpty(),
        CategoryLoading(),
        CategoryLoaded(categories: categories),
        CategoryLoaded(categories: categoriesModified)
      ];

      expectLater(
        categoryBloc.state,
        emitsInOrder(expected),
      ).then((_) => verifyNever(mockFilteredProductsBloc.dispatch(any)));
    });

    test(
        'should mark isSelected=true when event is AddedFilter and filteredProductsBloc state == FilteredProductsLoaded',
        () {
      categoryBloc.dispatch(FetchCategories());
      final List<Category> categoriesModified =
          categoryBloc.modifyList(true, categories[0], categories);
      when(mockFilteredProductsBloc.currentState)
          .thenReturn(FilteredProductsLoaded([], [], ''));

      categoryBloc.dispatch(AddedFilter(categories[0]));
      final expected = [
        CategoryEmpty(),
        CategoryLoading(),
        CategoryLoaded(categories: categories),
        CategoryLoaded(categories: categoriesModified)
      ];

      expectLater(
        categoryBloc.state,
        emitsInOrder(expected),
      ).then((_) => verify(mockFilteredProductsBloc.dispatch(any)).called(1));
    });

    test(
        'should mark isSelected=false when event is RemoveFilter and filteredProductsBloc state != FilteredProductsLoaded',
        () {
      categoryBloc.dispatch(FetchCategories());
      final List<Category> categoriesModified =
          categoryBloc.modifyList(false, categories[1], categories);
      when(mockFilteredProductsBloc.currentState)
          .thenReturn(FilteredProductsLoaded([], [], ''));

      categoryBloc.dispatch(RemovedFilter(categories[1]));
      final expected = [
        CategoryEmpty(),
        CategoryLoading(),
        CategoryLoaded(categories: categories),
        CategoryLoaded(categories: categoriesModified)
      ];

      expectLater(
        categoryBloc.state,
        emitsInOrder(expected),
      ).then((_) => verify(mockFilteredProductsBloc.dispatch(any)).called(1));
    });

    tearDown(() {
      categoryBloc.dispose();
    });
  });
}
