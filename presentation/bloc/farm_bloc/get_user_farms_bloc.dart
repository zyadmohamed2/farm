import 'package:napta/modules/farm/presentation/bloc/farm_bloc/farm_status.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_bloc/farm_event.dart';
import 'package:napta/modules/farm/data/repository/farm_repository.dart';
import 'package:napta/core/error_handler/failure.dart';
import 'package:napta/core/functions/extensions.dart';
import 'package:napta/core/data_source/app_pref.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetUserFarmsBloc extends Bloc<FarmEvent, FarmStatus> {
  FarmRepositoryImp repository;
  GetUserFarmsBloc({required this.repository}) : super(InitFarmStatus()) {
    on<GetUserFarmsEvent>((event, emit) async {
      emit(LoadingFarmStatus());
      var response = await repository.getByUserId(
          userId: CacheHelper.getUserData()!.user!.id.notNull());
      response.fold((failure) {
        emit(GotUserFarmsFailedStatus(failure: failure));
      }, (farms) {
        if (farms.isNotEmpty) {
          emit(GotUserFarmsSuccessStatus(farms: farms.values.toList()));
        } else {
          emit(GotUserFarmsFailedStatus(
              failure: Failure(code: 0, message: "لا يوجد بيانات")));
        }
      });
    });
  }
}
