import 'dart:developer';
import 'package:napta/core/data_source/app_pref.dart';
import 'package:napta/core/data_source/remote_data.dart';
import 'package:napta/core/model/image_model.dart';
import 'package:napta/modules/farm/data/models/farm.dart';
import 'package:dio/dio.dart';

class FarmRemoteDataSource {
  ApiClientHelper apiClientHelper;
  FarmRemoteDataSource({required this.apiClientHelper});
  Future create({required FarmModel model}) async {
    var json = model.toJson();
    List uploadList = [];
    for (var imageFile in model.imagesForms) {
      var multipartFile = await MultipartFile.fromFile(imageFile.file!.path);
      uploadList.add(multipartFile);
    }
    json["ImageFiles"] = uploadList;
    final FormData formData = FormData.fromMap(json);
    // log(formData.files.toString());
    // log(formData.fields.toString());
    log("JsonJson $json");
    return apiClientHelper
        .post(endPoint: "Farm/InsertFarm", data: formData, headers: {
      "Authorization": "Bearer ${CacheHelper.getUserData()!.token}",
    });
  }

  Future update({required FarmModel model}) {
    return apiClientHelper.put(
        endPoint: "Farm/UpdateFarm/${model.id}",
        data: model.toJson(),
        headers: {
          "Authorization": "Bearer ${CacheHelper.getUserData()!.token}",
        });
  }

  Future delete({required int id}) {
    return apiClientHelper.put(
      endPoint: "Farm/DeleteFarm/$id",
    );
  }

  Future getByUserId({required String userId}) {
    return apiClientHelper.put(
      endPoint: "Farm/GetFarmByFarmerId",
      queryParameters: {"FarmerId": userId},
    );
  }

  Future insertImage(ImageModel model, int farmId) async {
    var json = {
      "FarmId": farmId,
      "UserId": CacheHelper.getUserData()!.user!.id
    };
    List uploadList = [];
    var Image = await MultipartFile.fromFile(model.file!.path);
    json["Image"] = Image;
    final FormData formData = FormData.fromMap(json);
    return await apiClientHelper
        .post(endPoint: "FarmImage/InsertFarmImage", data: formData, headers: {
      "Authorization": "Bearer ${CacheHelper.getUserData()!.token}",
    });
  }

  Future deleteImage(imageID) async {
    return await apiClientHelper
        .put(endPoint: "FarmImage/DeleteFarmImage/$imageID", headers: {
      "Authorization": "Bearer ${CacheHelper.getUserData()!.token}",
    });
  }
}
