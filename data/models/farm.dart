import 'package:napta/modules/lookups/data/models/category_model.dart';
import 'package:napta/core/data_source/app_pref.dart';
import 'package:napta/core/functions/extensions.dart';
import 'package:napta/core/model/image_model.dart';
import 'package:dio/dio.dart';

class FarmModel {
  int? farmMetaDataCount;
  int? id;
  String? name;
  int? governmentId;
  int? centerId;
  int? villageId;
  String? addressDetails;
  double? latitude;
  double? longitude;
  String? userId;
  bool? isDeleted;
  Map<String, dynamic>? farmImages;
  List<ImageModel> imagesForms = [];

  FarmModel(
      {this.id,
      this.name,
      this.governmentId,
      this.centerId,
      this.villageId,
      this.addressDetails,
      this.latitude,
      this.longitude,
      this.userId,
      this.isDeleted,
      this.farmImages,
      required this.imagesForms,
      this.farmMetaDataCount});

  FarmModel clone() {
    return FarmModel(
      id: id,
      name: name,
      governmentId: governmentId,
      centerId: centerId,
      addressDetails: addressDetails,
      longitude: longitude,
      villageId: villageId,
      latitude: latitude,
      userId: userId,
      isDeleted: isDeleted,
      farmImages: farmImages,
      imagesForms: imagesForms,
      farmMetaDataCount: farmMetaDataCount,
    );
  }

  FarmModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    farmMetaDataCount = json['farmMetaDataCount'];
    name = json['name'];
    governmentId = json['governmentId'];
    centerId = json['centerId'];
    villageId = json['villageId'];
    addressDetails = json['addressDetails'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    userId = json['userId'];
    isDeleted = json['isDeleted'];
    farmImages = json['farmImages'];
  }

  FormData toJsonFormData() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['governmentId'] = governmentId;
    data['centerId'] = centerId;
    data['villageId'] = villageId;
    data['addressDetails'] = addressDetails;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['userId'] = CacheHelper.getUserData()!.user!.id;
    data['isDeleted'] = isDeleted;
    final FormData formData = FormData.fromMap(data);
    return formData;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['GovernmentId'] = governmentId;
    data['CenterId'] = centerId;
    data['VillageId'] = villageId;
    data['AddressDetails'] = addressDetails;
    data['Latitude'] = double.parse(latitude?.toStringAsFixed(7) ?? "0");
    data['Longitude'] = double.parse(longitude?.toStringAsFixed(7) ?? "0");
    data['UserId'] = CacheHelper.getUserData()!.user!.id;
    data['IsDeleted'] = isDeleted;
    data['ImageFiles'] = farmImages;
    return data;
  }

  Map<String, dynamic> toJsonWithId() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['governmentId'] = governmentId;
    data['centerId'] = centerId;
    data['villageId'] = villageId;
    data['addressDetails'] = addressDetails;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['userId'] = userId;
    data['isDeleted'] = isDeleted;
    if (farmImages != null) {
      data['farmImages'] = farmImages;
    }
    return data;
  }
}

extension FarmToCategory on List<FarmModel> {
  Map<int, CategoryModel> toCategories() {
    Map<int, CategoryModel> list = {};
    forEach((element) {
      list[element.id.notNull()] =
          CategoryModel(id: element.id, name: element.name);
    });
    return list;
  }
}
