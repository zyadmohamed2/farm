import 'dart:developer';

import 'package:napta/modules/lookups/data/models/category_model.dart';

abstract class ProductionDateState {}

class ProductionDateUpdatedSuccessState extends ProductionDateState {
  Map<int, CategoryModel> selected;
  Map<int, CategoryModel> data;
  Map<int, CategoryModel> cultivationMethod;
  int methodType;
  ProductionDateUpdatedSuccessState(
      {required this.data,
      required this.selected,
      required this.cultivationMethod,
      required this.methodType});
}
