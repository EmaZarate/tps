import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final bool isSelected;

  Category({this.id, this.name, this.isSelected = false})
      : super([id, name, isSelected]);

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['categoryID'], name: json['name']);
  }

  Category copyWith({int id, String name, bool isSelected}) {
    return Category(
        id: id ?? this.id,
        name: name ?? this.name,
        isSelected: isSelected ?? this.isSelected);
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'isSelected': isSelected,
    };
  }
}
