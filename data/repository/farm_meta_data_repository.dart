import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:napta/core/error_handler/data_source_exception.dart';
import 'package:napta/core/error_handler/error_handler.dart';
import 'package:napta/core/error_handler/failure.dart';
import 'package:napta/core/functions/extensions.dart';
import 'package:napta/core/model/custom_response.dart';
import 'package:napta/core/network/network_info.dart';
import 'package:napta/modules/farm/data/data_source/meta_data_datasource.dart';
import 'package:napta/modules/farm/data/models/farm_meta_data.dart';

class FarmMetaDataRepositoryImp {
  FarmMetaDataDataSource dataSource;
  NetworkInfo networkInfo;

  FarmMetaDataRepositoryImp(
      {required this.dataSource, required this.networkInfo});

  Future<Either<Failure, String>> create(
      {required FarmMetaDataModel model}) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await dataSource.create(model: model);
        CustomResponse<FarmMetaDataModel> registerResponse =
            CustomResponse<FarmMetaDataModel>.fromJson(
                response.data, (json) => FarmMetaDataModel.fromJson(json));
        if (response.statusCode == 200 && registerResponse.ok == true) {
          return const Right("تم إنشاء المنتج بنجاح");
        } else {
          return Left(
              Failure(code: 200, message: registerResponse.message.notNull()));
        }
      } on DioException catch (error) {
        return Left(
            ErrorHandler.handle(error, "DioException Create Farm").failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION
          .getFailure(place: "NO_INTERNET_CONNECTION Create Farm"));
    }
  }

  Future<Either<Failure, String>> update(
      {required FarmMetaDataModel model}) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await dataSource.update(model: model);
        CustomResponse<FarmMetaDataModel> registerResponse =
            CustomResponse<FarmMetaDataModel>.fromJson(
                response.data, (json) => FarmMetaDataModel.fromJson(json));
        if (response.statusCode == 200 && registerResponse.ok == true) {
          return const Right("تم تعديل بيانات المنتج بنجاح");
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
        CustomResponse<FarmMetaDataModel> registerResponse =
            CustomResponse<FarmMetaDataModel>.fromJson(
                response.data, (json) => FarmMetaDataModel.fromJson(json));
        if (response.statusCode == 200 && registerResponse.ok == true) {
          return const Right("تم حذف المنتج بنجاح");
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

  Future<Either<Failure, List<FarmMetaDataModel>>> getByUserId(
      {required String userId}) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await dataSource.getByUserId(userId: userId);
        CustomResponse<List<FarmMetaDataModel>> farms =
            CustomResponse<List<FarmMetaDataModel>>.fromJson(
          response.data,
          (json) => (json as List<dynamic>)
              .map((json) => FarmMetaDataModel.fromJson(json))
              .toList(),
        );
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

  Future<Either<Failure, List<FarmMetaDataModel>>> getByFarmId(
      {required int farmId, required int pageNumber}) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await dataSource.getByFarmId(
            farmId: farmId, pageNumber: pageNumber);
        CustomResponse<List<FarmMetaDataModel>> farms =
            CustomResponse<List<FarmMetaDataModel>>.fromJson(
          response.data,
          (json) => (json as List<dynamic>)
              .map((json) => FarmMetaDataModel.fromJson(json))
              .toList(),
        );
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
}
