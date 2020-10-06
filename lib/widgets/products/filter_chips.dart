import 'dart:async';

import 'package:andina_protos/blocs/category/category.dart';
import 'package:andina_protos/blocs/filtered_products/filtered_products.dart';
import 'package:andina_protos/models/category.dart';
import 'package:andina_protos/repositories/category.repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OptionFilter {
  final String text;
  bool isSelected;

  OptionFilter({@required this.text, this.isSelected = false});
}

class FilterChips extends StatefulWidget {
  final Completer<void> refreshCategoriesCompleter;
  final CategoryRepository categoryRepository;
  final FilteredProductsBloc filteredProductsBloc;

  FilterChips({Key key, this.categoryRepository, this.filteredProductsBloc, this.refreshCategoriesCompleter})
      : super(key: key);

  _FilterChipsState createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> {
  CategoryBloc _categoryBloc;
  @override
  void initState() {
    _categoryBloc = CategoryBloc(
        categoryRepository: widget.categoryRepository,
        filteredProductsBloc: widget.filteredProductsBloc);
    _categoryBloc.dispatch(FetchCategories());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: _categoryBloc,
        listener: (BuildContext context, CategoryState state) {
          if(state is CategoryLoaded){
            widget.refreshCategoriesCompleter.complete();
          }
        },
          child: BlocBuilder(
          bloc: _categoryBloc,
          builder: (BuildContext context, CategoryState state) {
            if (state is CategoryLoaded) {
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 15),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Wrap(                
                    runSpacing: 5.0,
                    spacing: 15.0,
                    alignment: WrapAlignment.center,
                    children: List.generate(state.categories.length, (index) {
                      return _returnChip(state.categories[index]);
                    }),
                  )
                ],
              );
            }
            else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  _returnChip(Category option) {
    return FilterChip(
      padding: const EdgeInsets.all(5.0),
      label: Text(
        option.name,
        style: TextStyle(
            fontSize: 15.0, color: Theme.of(context).primaryColorDark),
      ),
      selectedColor: Theme.of(context).primaryColorLight,
      backgroundColor: Colors.white,
      elevation: 5.0,
      onSelected: (val) {
        setState(() {
          val
              ? _categoryBloc.dispatch(AddedFilter(option))
              : _categoryBloc.dispatch((RemovedFilter(option)));
        });
      },
      selected: option.isSelected,
    );
  }
}
