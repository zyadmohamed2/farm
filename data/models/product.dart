import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:napta/core/data_source/app_pref.dart';
import 'package:napta/core/model/image_model.dart';
import 'package:napta/core/resources/constants.dart';

class MarketProductModel {
  int? id;
  String? userName;
  String? userImage;
  double? price;
  String? productionDate;
  double? discount;
  int? quantity;
  int? unitId;
  String? unitName;
  String? userId;
  int? quantityMetaData;
  int? cycleNumber;
  int? capacity;
  String? description;
  String? properties;
  int? farmMetaDataId;
  int? numberOfDays;
  String? expirationDate;
  String? status;
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
  Map<String, dynamic>? farmMarketImages;
  List<ImageModel> imagesForms = [];

  MarketProductModel(
      {this.id,
      this.price,
      this.productionDate,
      this.discount,
      this.quantity,
      this.unitId,
      this.unitName,
      this.quantityMetaData,
      this.cycleNumber,
      this.capacity,
      this.farmMetaDataId,
      this.categoryId,
      this.categoryName,
      this.subCategoryId,
      this.subCategoryName,
      this.productId,
      this.productName,
      this.codeId,
      this.codeName,
      this.farmId,
      this.userImage,
      this.userName,
      this.isDeleted,
      this.userId,
      this.description,
      this.properties,
      this.numberOfDays,
      this.status,
      this.expirationDate});

  MarketProductModel clone() {
    return MarketProductModel(
        id: id,
        cycleNumber: cycleNumber,
        capacity: capacity,
        quantity: quantity,
        quantityMetaData: quantityMetaData,
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
        price: price,
        farmMetaDataId: farmMetaDataId,
        discount: discount,
        userName: userName,
        userId: userId,
        userImage: userImage,
        numberOfDays: numberOfDays,
        expirationDate: expirationDate,
        status: status,
        properties: properties,
        description: description);
  }

  MarketProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    userName = json['userName'];
    userImage = json['userImage'];
    productionDate = json['productionDate'];
    discount = double.parse(json['discount'].toString());
    quantity = json['quantity'];
    unitId = json['unitId'];
    unitName = json['unitName'];
    quantityMetaData = json['quantityMetaData'];
    cycleNumber = json['cycleNumber'];
    capacity = json['capacity'];
    farmMetaDataId = json['farmMetaDataId'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    userId = json['userId'];
    subCategoryId = json['subCategoryId'];
    subCategoryName = json['subCategoryName'];
    description = json['description'];
    properties = json['properties'];
    productId = json['productId'];
    productName = json['productName'];
    codeId = json['codeId'];
    codeName = json['codeName'];
    farmId = json['farmId'];
    isDeleted = json['isDeleted'];
    userName = json['userName'];
    userImage = json['userImage'];
    id = json['id'];
    price = json['price'];
    productionDate = json['productionDate'];
    discount = double.parse(json['discount'].toString());
    quantity = json['quantity'];
    properties = json['properties'];
    description = json['description'];
    numberOfDays = json['numberOfDays'];
    status = json['status'];
    expirationDate = json['expirationDate'];
    unitId = json['unitId'];
    unitName = json['unitName'];
    cycleNumber = json['cycleNumber'];
    capacity = json['capacity'];
    farmMetaDataId = json['farmMetaDataId'];
    userId = json['userId'];
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
    farmMarketImages = json['farmMarketImages'];
    farmMarketImages = json['farmMarketImages'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['productionDate'] =
        DateFormat(AppConstants.DATE_FORMATE).format(DateTime.now());
    data['discount'] = 0;
    data['quantity'] = quantity;
    data['numberOfDays'] = numberOfDays;
    data['properties'] = properties;
    data['description'] = description;
    data['productUnitId'] = unitId;
    data['farmId'] = farmId;
    data['userId'] = CacheHelper.getUserData()?.user?.id;
    data['farmMetaDataId'] = farmMetaDataId;
    data['isDeleted'] = false;
    return data;
  }

  Map<String, dynamic> toJsonWithId() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['price'] = price;
    data['productionDate'] = productionDate;
    data['discount'] = discount;
    data['quantity'] = quantity;
    data['unitId'] = unitId;
    data['unitName'] = unitName;
    data['quantityMetaData'] = quantityMetaData;
    data['cycleNumber'] = cycleNumber;
    data['capacity'] = capacity;
    data['farmMetaDataId'] = farmMetaDataId;
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
    data['status'] = status;
    data['expirationDate'] = expirationDate;
    data['numberOfDays'] = numberOfDays;
    return data;
  }
}
