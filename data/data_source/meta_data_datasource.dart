import 'package:napta/modules/farm/data/models/farm_meta_data.dart';
import 'package:napta/core/data_source/remote_data.dart';
import 'package:napta/core/data_source/app_pref.dart';
import 'package:napta/core/resources/constants.dart';

class FarmMetaDataDataSource {
  ApiClientHelper apiClientHelper;
  FarmMetaDataDataSource({required this.apiClientHelper});

  Future create({required FarmMetaDataModel model}) {
    return apiClientHelper.post(
        endPoint: "FarmMetaData/Inventory/InsertProduct",
        data: model.toJson(),
        headers: {
          "Authorization": "Bearer ${CacheHelper.getUserData()!.token}",
        });
  }

  Future update({required FarmMetaDataModel model}) {
    return apiClientHelper.put(
        endPoint: "FarmMetaData/Inventory/UpdateProduct/${model.id}",
        data: model.toJson(),
        headers: {
          "Authorization": "Bearer ${CacheHelper.getUserData()!.token}",
        });
  }

  Future delete({required int id}) {
    return apiClientHelper.put(
        endPoint: "FarmMetaData/Inventory/DeactivateProduct/$id",
        headers: {
          "Authorization": "Bearer ${CacheHelper.getUserData()!.token}",
        });
  }

  Future getByFarmId({required int farmId, required int pageNumber}) {
    return apiClientHelper.get(
        endPoint: "FarmMetaData/Inventory/GetProductsByFarm",
        queryParameters: {
          "farmId": farmId,
          "pageSize": AppConstants.PAGE_SIZE,
          "pageIndex": pageNumber
        },
        headers: {
          "Authorization": "Bearer ${CacheHelper.getUserData()!.token}",
        });
  }

  Future getByUserId({required String userId}) {
    return apiClientHelper.get(
        endPoint: "FarmMetaData/Inventory/GetProductsByUser",
        queryParameters: {
          "pageSize": 10000,
          "pageIndex": 1,
          "UserId": userId
        },
        headers: {
          "Authorization": "Bearer ${CacheHelper.getUserData()!.token}",
        });
  }
}
