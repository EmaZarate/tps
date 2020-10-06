import 'package:andina_protos/blocs/filtered_products/filtered_products.dart';
import 'package:andina_protos/models/category.dart';
import 'package:andina_protos/repositories/category.repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;
  final FilteredProductsBloc filteredProductsBloc;

  CategoryBloc(
      {@required this.categoryRepository, @required this.filteredProductsBloc})
      : assert(categoryRepository != null),
        assert(filteredProductsBloc != null);

  @override
  CategoryState get initialState => CategoryEmpty();

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if (event is FetchCategories) {
      yield CategoryLoading();
      final List<Category> categories =
          await categoryRepository.getCategories();
      yield CategoryLoaded(categories: categories);
    }

    if (event is AddedFilter) {
      yield (CategoryLoaded(
          categories: modifyList(true, event.category,
              (currentState as CategoryLoaded).categories)));

      if (filteredProductsBloc.currentState is FilteredProductsLoaded) {
        List<int> filtersCategories =
            (filteredProductsBloc.currentState as FilteredProductsLoaded)
                .categoriesFilter;
        filtersCategories.add(event.category.id);
        filteredProductsBloc.dispatch(UpdateFilter(filtersCategories));
      }
    }

    if (event is RemovedFilter) {
      yield (CategoryLoaded(
          categories: modifyList(false, event.category,
              (currentState as CategoryLoaded).categories)));

      if (filteredProductsBloc.currentState is FilteredProductsLoaded) {
        List<int> filtersCategories =
            (filteredProductsBloc.currentState as FilteredProductsLoaded)
                .categoriesFilter;
        filtersCategories.remove(event.category.id);
        filteredProductsBloc.dispatch(UpdateFilter(filtersCategories));
      }
    }

    if (event is RefreshCategories) {
      try {
        final List<Category> categories =
            await categoryRepository.getCategories();
        yield CategoryLoaded(
            categories: categories,
            forceChange: !(currentState as CategoryLoaded).forceChange);
      } catch (_) {
        yield currentState;
      }
    }
  }

  @visibleForTesting
  modifyList(bool val, Category category, List<Category> categories) {
    final indexToModify = categories.indexOf(category);
    if (indexToModify != -1) {
      final List<Category> newList = List.from(categories);
      newList[indexToModify] = category.copyWith(isSelected: val);
      return newList;
    }

    return categories;
  }
}
