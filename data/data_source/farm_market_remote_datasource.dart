import 'package:napta/core/model/image_model.dart';
import 'package:napta/modules/farm/data/models/product.dart';
import 'package:napta/core/data_source/remote_data.dart';
import 'package:napta/core/data_source/app_pref.dart';
import 'package:napta/core/resources/constants.dart';
import 'package:dio/dio.dart';

class MarketProductsRemoteDataSource {
  ApiClientHelper apiClientHelper;

  MarketProductsRemoteDataSource({required this.apiClientHelper});

  Future create({required MarketProductModel model}) async {
    var json = model.toJson();
    List uploadList = [];
    for (var imageFile in model.imagesForms) {
      var multipartFile = await MultipartFile.fromFile(imageFile.file!.path);
      uploadList.add(multipartFile);
    }
    json["ImageFiles"] = uploadList;
    final FormData formData = FormData.fromMap(json);
    return apiClientHelper.post(
        endPoint: "FarmMarket/Market/InsertProduct",
        data: formData,
        headers: {
          "Authorization": "Bearer ${CacheHelper.getUserData()!.token}",
        });
  }

  Future deactivate({required int id}) {
    return apiClientHelper
        .put(endPoint: "FarmMarket/Market/DeactivateProduct/$id", headers: {
      "Authorization": "Bearer ${CacheHelper.getUserData()!.token}",
    });
  }

  Future update({required MarketProductModel model}) {
    return apiClientHelper.put(
        endPoint: "FarmMarket/Market/UpdateProduct/${model.id}",
        data: model.toJson(),
        headers: {
          "Authorization": "Bearer ${CacheHelper.getUserData()!.token}",
        });
  }

  Future getByUserId({required String userId, required int pageNumber}) {
    return apiClientHelper.get(
        endPoint: "FarmMarket/Market/GetProductsByFarmer",
        queryParameters: {
          "pageSize": AppConstants.PAGE_SIZE,
          "pageIndex": pageNumber,
          "FarmerId": userId
        },
        headers: {
          "Authorization": "Bearer ${CacheHelper.getUserData()!.token}",
        });
  }

  Future filter(
      {int? category,
      int? subCategory,
      int? product,
      int? code,
      required int pageNumber}) {
    Map<String, dynamic> queryParameters = {
      "pageSize": AppConstants.PAGE_SIZE,
      "pageIndex": pageNumber,
      "Category": category ?? 0,
      "SubCategory": subCategory ?? 0,
      "Product": product ?? 0,
      "Code": code ?? 0
    };
    return apiClientHelper.get(
        endPoint: "FarmMarket/Market/FilterProducts",
        queryParameters: queryParameters,
        headers: {
          "Authorization": "Bearer ${CacheHelper.getUserData()!.token}",
        });
  }

  Future getAll({required int pageNumber}) {
    return apiClientHelper
        .get(endPoint: "FarmMarket/Market/GetProducts", queryParameters: {
      "pageSize": AppConstants.PAGE_SIZE,
      "pageIndex": pageNumber,
    }, headers: {
      "Authorization": "Bearer ${CacheHelper.getUserData()!.token}",
    });
  }

  Future search({String? searchKey, required int pageNumber}) {
    return apiClientHelper
        .post(endPoint: "FarmMarket/Market/SearchForProduct", queryParameters: {
      "pageSize": AppConstants.PAGE_SIZE,
      "pageIndex": pageNumber,
      "searchTerm": searchKey,
      "orderByDescending": AppConstants.ORDER_BY_DESCENDING,
    }, headers: {
      "Authorization": "Bearer ${CacheHelper.getUserData()!.token}",
    });
  }

  Future insertImage(ImageModel model, int farmId) async {
    var json = {
      "FarmMarketId": farmId,
      "UserId": CacheHelper.getUserData()!.user!.id
    };
    List uploadList = [];
    var Image = await MultipartFile.fromFile(model.file!.path);
    json["Image"] = Image;
    final FormData formData = FormData.fromMap(json);
    return await apiClientHelper.post(
        endPoint: "FarmMarketImage/InsertFarmMarketImage",
        data: formData,
        headers: {
          "Authorization": "Bearer ${CacheHelper.getUserData()!.token}",
        });
  }

  Future deleteImage(imageID) async {
    return await apiClientHelper.put(
        endPoint: "FarmMarketImage/DeleteFarmMarketImage/$imageID",
        headers: {
          "Authorization": "Bearer ${CacheHelper.getUserData()!.token}",
        });
  }
}
