import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/farm_meta_data_status.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/farm_metadata_events.dart';
import 'package:napta/modules/farm/data/repository/farm_meta_data_repository.dart';
import 'package:napta/modules/farm/data/models/farm_meta_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetFarmMetaDataBloc extends Bloc<FarmMetaDataEvent, FarmMetaDataStatus> {
  FarmMetaDataRepositoryImp repository;
  List<FarmMetaDataModel> data = [];
  int pageNumber = 1;
  GetFarmMetaDataBloc({required this.repository})
      : super(InitFarmMetaDataStatus()) {
    on<GetFarmMetaDatasEvent>((event, emit) async {
      emit(LoadingFarmMetaDataStatus());
      pageNumber = 1;
      var response = await repository.getByFarmId(
          farmId: event.farmId, pageNumber: pageNumber);
      response.fold((failure) {
        emit(GetUserFarmMetaDatasFailedStatus(failure: failure));
      }, (data) {
        pageNumber++;
        this.data = [];
        this.data = data;
        emit(GetUserFarmMetaDatasSuccessStatus(data: data));
      });
    });

    on<GetMoreFarmMetaDatasEvent>((event, emit) async {
      var response = await repository.getByFarmId(
          farmId: event.farmId, pageNumber: pageNumber);
      response.fold((failure) {
        emit(GetUserFarmMetaDatasSuccessStatus(data: data));
      }, (data) {
        pageNumber++;
        this.data = List.from(this.data)..addAll(data);
        emit(GetUserFarmMetaDatasSuccessStatus(data: this.data));
      });
    });
  }
}
