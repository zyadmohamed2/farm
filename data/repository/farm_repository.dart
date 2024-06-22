import 'dart:developer';

import 'package:napta/modules/farm/data/data_source/farm_remote_data_source.dart';
import 'package:napta/core/error_handler/data_source_exception.dart';
import 'package:napta/core/error_handler/error_handler.dart';
import 'package:napta/modules/farm/data/models/farm.dart';
import 'package:napta/core/model/custom_response.dart';
import 'package:napta/core/error_handler/failure.dart';
import 'package:napta/core/network/network_info.dart';
import 'package:napta/core/functions/extensions.dart';
import 'package:napta/core/model/image_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class FarmRepositoryImp {
  FarmRemoteDataSource dataSource;
  NetworkInfo networkInfo;

  FarmRepositoryImp({required this.dataSource, required this.networkInfo});

  Future<Either<Failure, String>> create({required FarmModel model}) async {
    if (await networkInfo.isConnected) {
      try {
        // log("message");
        Response response = await dataSource.create(model: model);
        // log("message ${response.data}");
        CustomResponse<FarmModel> registerResponse =
            CustomResponse<FarmModel>.fromJson(
                response.data, (json) => FarmModel.fromJson(json));
        if (response.statusCode == 200 && registerResponse.ok == true) {
          return const Right("تم إنشاء المزرعة بنجاح");
        } else {
          return Left(
              Failure(code: 200, message: registerResponse.message.notNull()));
        }
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error, "DioException").failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION
          .getFailure(place: "NO_INTERNET_CONNECTION register"));
    }
  }

  Future<Either<Failure, String>> update({required FarmModel model}) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await dataSource.update(model: model);
        CustomResponse<FarmModel> registerResponse =
            CustomResponse<FarmModel>.fromJson(
                response.data, (json) => FarmModel.fromJson(json));
        if (response.statusCode == 200 && registerResponse.ok == true) {
          for (var element in model.imagesForms) {
            if (element.status == ImageEnumMethod.INSERT) {
              await dataSource.insertImage(element, model.id!);
            } else if (element.status == ImageEnumMethod.DELETE &&
                element.type == ImageEnumType.NETWORK) {
              await dataSource.deleteImage(element.id);
            }
          }
          return const Right("تم تعديل بيانات المزرعة بنجاح");
        } else {
          return Left(
              Failure(code: 200, message: registerResponse.message.notNull()));
        }
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error, "DioException").failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION
          .getFailure(place: "NO_INTERNET_CONNECTION register"));
    }
  }

  Future<Either<Failure, String>> delete({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await dataSource.delete(id: id);
        CustomResponse<FarmModel> registerResponse =
            CustomResponse<FarmModel>.fromJson(
                response.data, (json) => FarmModel.fromJson(json));
        if (response.statusCode == 200 && registerResponse.ok == true) {
          return const Right("تم حذف المزرعة بنجاح");
        } else {
          return Left(
              Failure(code: 200, message: registerResponse.message.notNull()));
        }
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error, "DioException").failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION
          .getFailure(place: "NO_INTERNET_CONNECTION register"));
    }
  }

  Future<Either<Failure, Map<int, FarmModel>>> getByUserId(
      {required String userId}) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await dataSource.getByUserId(userId: userId);
        CustomResponse<Map<int, FarmModel>> farms =
            CustomResponse<Map<int, FarmModel>>.fromJson(
                response.data, mapData);
        if (response.statusCode == 200 && farms.ok == true) {
          return Right(farms.data!);
        } else {
          return Left(Failure(code: 200, message: farms.message.notNull()));
        }
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error, "DioException").failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION
          .getFailure(place: "NO_INTERNET_CONNECTION register"));
    }
  }

  Future<Either<Failure, List<FarmModel>>> getByUserIdForDropDown(
      {required String userId}) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await dataSource.getByUserId(userId: userId);
        CustomResponse<Map<int, FarmModel>> farms =
            CustomResponse<Map<int, FarmModel>>.fromJson(
                response.data, mapData);
        if (response.statusCode == 200 && farms.ok == true) {
          List<FarmModel> data = [
            FarmModel(id: 0, name: "حدد الخيار", imagesForms: [])
          ];
          return Right(
              List<FarmModel>.from(data)..addAll(farms.data!.values.toList()));
        } else {
          return Left(Failure(code: 200, message: farms.message.notNull()));
        }
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error, "DioException").failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION
          .getFailure(place: "NO_INTERNET_CONNECTION register"));
    }
  }

  Map<int, FarmModel> mapData(json) {
    Map<int, FarmModel> data = {};
    for (var item in json) {
      data[item['id']] = FarmModel.fromJson(item);
      data[item['id']]!.farmImages!.forEach((key, value) {
        data[item['id']]!.imagesForms.add(ImageModel(
            url: value,
            type: ImageEnumType.NETWORK,
            status: ImageEnumMethod.NORMAL,
            id: key));
      });
    }
    return data;
  }
}
