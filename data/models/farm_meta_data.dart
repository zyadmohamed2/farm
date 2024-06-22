import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:napta/core/functions/extensions.dart';
import 'package:napta/modules/lookups/data/models/category_model.dart';

class FarmMetaDataModel {
  int? id;
  int? cycleNumber;
  int? capacity;
  String? productionDate;
  int? unitId;
  String? unitName;
  int? categoryId;
  String? categoryName;
  int? subCategoryId;
  String? subCategoryName;
  int? productId;
  String? productName;
  int? codeId;
  String? codeName;
  int? farmId;
  bool? isDeleted;
  CategoryModel? cultivationMethod;
  int? cultivationMethodId;
  List<CycleDates>? cycleDates = [];
  List<SeasonalCrops>? seasonalCrops = [];

  FarmMetaDataModel(
      {this.id,
      this.cycleNumber,
      this.capacity,
      this.productionDate,
      this.unitId,
      this.unitName,
      this.categoryId,
      this.categoryName,
      this.subCategoryId,
      this.subCategoryName,
      this.productId,
      this.productName,
      this.codeId,
      this.codeName,
      this.farmId,
      this.isDeleted,
      this.cycleDates,
      this.cultivationMethodId,
      this.seasonalCrops});

  FarmMetaDataModel clone() {
    return FarmMetaDataModel(
        id: id,
        cycleNumber: cycleNumber,
        capacity: capacity,
        productionDate: productionDate,
        unitId: unitId,
        unitName: unitName,
        categoryId: categoryId,
        categoryName: categoryName,
        subCategoryId: subCategoryId,
        subCategoryName: subCategoryName,
        productId: productId,
        productName: productName,
        codeId: codeId,
        codeName: codeName,
        farmId: farmId,
        isDeleted: isDeleted,
        cycleDates: cycleDates,
        cultivationMethodId: cultivationMethodId,
        seasonalCrops: seasonalCrops);
  }

  FarmMetaDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cycleNumber = json['cycleNumber'];
    capacity = json['capacity'];
    unitId = json['unitId'];
    unitName = json['unitName'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    subCategoryId = json['subCategoryId'];
    subCategoryName = json['subCategoryName'];
    productId = json['productId'];
    productName = json['productName'];
    codeId = json['codeId'];
    codeName = json['codeName'];
    farmId = json['farmId'];
    isDeleted = json['isDeleted'];
    cultivationMethod = CategoryModel.fromJson(json["cultivationMethod"]);
    cultivationMethodId = cultivationMethod!.id;
    for (var item in json["seasonalCrops"]) {
      seasonalCrops!.add(SeasonalCrops(seasonId: item['id']));
    }
    for (var item in json["cycleDates"]) {
      cycleDates!.add(CycleDates(date: item['date']));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cycleNumber'] = cycleNumber;
    data['capacity'] = capacity;
    data['productionDate'] = "2023-10-21T15:24:02.799Z";
    data['productUnitId'] = unitId;
    data['categoryId'] = categoryId;
    data['subCategoryId'] = subCategoryId;
    data['productId'] = productId;
    data['codeId'] = codeId;
    data['farmId'] = farmId;
    data['isDeleted'] = isDeleted;
    data['cultivationMethodId'] = cultivationMethodId;
    data['isDeleted'] = isDeleted;
    data['cycleDates'] = cycleDates!.map((v) => v.toJson()).toList();
    data['seasonalCrops'] = seasonalCrops!.map((v) => v.toJson()).toList();

    return data;
  }

  Map<String, dynamic> toJsonWithId() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cycleNumber'] = cycleNumber;
    data['capacity'] = capacity;
    data['productionDate'] = DateFormat('dd/mm/yyyy')
        .parse(productionDate.notNull().toString())
        .toString()
        .substring(0, 10);
    data['unitId'] = unitId;
    data['unitName'] = unitName;
    data['categoryId'] = categoryId;
    data['categoryName'] = categoryName;
    data['subCategoryId'] = subCategoryId;
    data['subCategoryName'] = subCategoryName;
    data['productId'] = productId;
    data['productName'] = productName;
    data['codeId'] = codeId;
    data['codeName'] = codeName;
    data['farmId'] = farmId;
    data['isDeleted'] = isDeleted;
    return data;
  }
}

extension FarmMetaDataToCategory on List<FarmMetaDataModel> {
  Map<int, CategoryModel> toCategories() {
    Map<int, CategoryModel> list = {};
    forEach((element) {
      list[element.id.notNull()] =
          CategoryModel(id: element.id, name: element.codeName);
    });
    return list;
  }
}

class CycleDates {
  int? date;

  CycleDates({this.date});

  CycleDates.fromJson(Map<String, dynamic> json) {
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    return data;
  }
}

class SeasonalCrops {
  int? seasonId;

  SeasonalCrops({this.seasonId});

  SeasonalCrops.fromJson(Map<String, dynamic> json) {
    seasonId = json['seasonId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['seasonId'] = seasonId;
    return data;
  }
}
