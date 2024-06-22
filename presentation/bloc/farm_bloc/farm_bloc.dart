import 'package:napta/modules/farm/presentation/bloc/farm_bloc/farm_status.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_bloc/farm_event.dart';
import 'package:napta/modules/farm/data/repository/farm_repository.dart';
import 'package:napta/core/functions/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FarmManagementBloc extends Bloc<FarmEvent, FarmStatus> {
  FarmRepositoryImp repository;
  FarmManagementBloc({required this.repository}) : super(InitFarmStatus()) {
    on<AddNewFarmsEvent>((event, emit) async {
      emit(LoadingFarmStatus());
      var response = await repository.create(model: event.model);
      response.fold((failure) {
        emit(FarmAddedFailedStatus(failure: failure));
      }, (message) {
        emit(FarmAddedSuccessStatus(message: message));
      });
    });

    on<UpdateFarmEvent>((event, emit) async {
      emit(LoadingFarmStatus());
      var response = await repository.update(model: event.model);
      response.fold((failure) {
        emit(FarmUpdatedFailedStatus(failure: failure));
      }, (message) {
        emit(FarmUpdatedSuccessStatus(message: message));
      });
    });

    on<DeleteFarmEvent>((event, emit) async {
      emit(LoadingFarmStatus());
      var response = await repository.delete(id: event.model.id.notNull());
      response.fold((failure) {
        emit(FarmDeletedFailedStatus(failure: failure));
      }, (message) {
        emit(FarmDeletedSuccessStatus(message: message));
      });
    });
  }
}
