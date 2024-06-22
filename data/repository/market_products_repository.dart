import 'package:napta/core/model/image_model.dart';
import 'package:napta/modules/farm/data/data_source/farm_market_remote_datasource.dart';
import 'package:napta/core/error_handler/data_source_exception.dart';
import 'package:napta/core/error_handler/error_handler.dart';
import 'package:napta/modules/farm/data/models/product.dart';
import 'package:napta/core/functions/extensions.dart';
import 'package:napta/core/model/custom_response.dart';
import 'package:napta/core/error_handler/failure.dart';
import 'package:napta/core/network/network_info.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:developer';

class MarketProductsRepositoryImp {
  MarketProductsRemoteDataSource dataSource;
  NetworkInfo networkInfo;

  MarketProductsRepositoryImp(
      {required this.networkInfo, required this.dataSource});

  Future<Either<Failure, String>> create(
      {required MarketProductModel model}) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await dataSource.create(model: model);
        CustomResponse<MarketProductModel> data =
            CustomResponse<MarketProductModel>.fromJson(
                response.data, (json) => MarketProductModel.fromJson(json));
        if (response.statusCode == 200 && data.ok == true) {
          return const Right("تم إنشاء المنتج بنجاح");
        } else {
          return Left(Failure(code: 200, message: data.message.notNull()));
        }
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error, "DioException create").failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION
          .getFailure(place: "NO_INTERNET_CONNECTION create"));
    }
  }

  Future<Either<Failure, String>> delete({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await dataSource.deactivate(id: id);
        CustomResponse<MarketProductModel> data =
            CustomResponse<MarketProductModel>.fromJson(
                response.data, (json) => MarketProductModel.fromJson(json));
        if (response.statusCode == 200 && data.ok == true) {
          return const Right("تم حذف المنتج بنجاح");
        } else {
          return Left(Failure(code: 200, message: data.message.notNull()));
        }
      } on DioException catch (error) {
        return Left(
            ErrorHandler.handle(error, "DioException   Delete").failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION
          .getFailure(place: "NO_INTERNET_CONNECTION   Delete"));
    }
  }

  Future<Either<Failure, String>> update(
      {required MarketProductModel model}) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await dataSource.update(model: model);
        CustomResponse<MarketProductModel> data =
            CustomResponse<MarketProductModel>.fromJson(
                response.data, (json) => MarketProductModel.fromJson(json));
        if (response.statusCode == 200 && data.ok == true) {
          for (var element in model.imagesForms) {
            if (element.status == ImageEnumMethod.INSERT) {
              await dataSource.insertImage(element, model.id!);
            } else if (element.status == ImageEnumMethod.DELETE &&
                element.type == ImageEnumType.NETWORK) {
              await dataSource.deleteImage(element.id);
            }
          }
          return const Right("تم تحديث المنتج بنجاح");
        } else {
          return Left(Failure(code: 200, message: data.message.notNull()));
        }
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error, "DioException update").failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION
          .getFailure(place: "NO_INTERNET_CONNECTION update"));
    }
  }

  Future<Either<Failure, List<MarketProductModel>>> getByUserId(
      {required String userId, required int pageNumber}) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await dataSource.getByUserId(
            userId: userId, pageNumber: pageNumber);
        CustomResponse<List<MarketProductModel>> data =
            CustomResponse<List<MarketProductModel>>.fromJson(
                response.data, mapData);
        if (response.statusCode == 200 &&
            data.ok == true &&
            data.data != null) {
          return Right(data.data!);
        } else {
          return Left(Failure(code: 200, message: data.message.notNull()));
        }
      } on DioException catch (error) {
        return Left(
            ErrorHandler.handle(error, "DioException getByUserId").failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION
          .getFailure(place: "NO_INTERNET_CONNECTION getByUserId"));
    }
  }

  Future<Either<Failure, List<MarketProductModel>>> filter(
      {int? category,
      int? subCategory,
      int? product,
      int? code,
      required int pageNumber}) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await dataSource.filter(
            category: category,
            subCategory: subCategory,
            product: product,
            code: code,
            pageNumber: pageNumber);
        CustomResponse<List<MarketProductModel>> data =
            CustomResponse<List<MarketProductModel>>.fromJson(
                response.data, mapData);
        if (response.statusCode == 200 && data.ok == true) {
          return Right(data.data!);
        } else {
          return Left(Failure(code: 200, message: data.message.notNull()));
        }
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error, "DioException filter").failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION
          .getFailure(place: "NO_INTERNET_CONNECTION register"));
    }
  }

  Future<Either<Failure, List<MarketProductModel>>> getAll(
      {required int pageNumber}) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await dataSource.getAll(pageNumber: pageNumber);
        CustomResponse<List<MarketProductModel>> data =
            CustomResponse<List<MarketProductModel>>.fromJson(
                response.data, mapData);
        if (response.statusCode == 200 && data.ok == true) {
          return Right(data.data!);
        } else {
          return Left(Failure(code: 200, message: data.message.notNull()));
        }
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error, "DioException getAll").failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION
          .getFailure(place: "NO_INTERNET_CONNECTION register"));
    }
  }

  Future<Either<Failure, List<MarketProductModel>>> search(
      {String? searchKey, required int pageNumber}) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await dataSource.search(
            searchKey: searchKey, pageNumber: pageNumber);
        CustomResponse<List<MarketProductModel>> data =
            CustomResponse<List<MarketProductModel>>.fromJson(
                response.data, mapData);
        if (response.statusCode == 200 && data.ok == true) {
          return Right(data.data!);
        } else {
          return Left(Failure(code: 200, message: data.message.notNull()));
        }
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error, "DioException search").failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION
          .getFailure(place: "NO_INTERNET_CONNECTION register"));
    }
  }

  List<MarketProductModel> mapData(json) {
    Map<int, MarketProductModel> data = {};
    for (var item in json) {
      data[item['id']] = MarketProductModel.fromJson(item);
      data[item['id']]!.farmMarketImages!.forEach((key, value) {
        log(key.toString(), name: "IMAGEKEYIMAGEKEY");
        data[item['id']]!.imagesForms.add(ImageModel(
            url: value,
            type: ImageEnumType.NETWORK,
            status: ImageEnumMethod.NORMAL,
            id: key));
      });
    }
    return data.values.toList();
  }
}
