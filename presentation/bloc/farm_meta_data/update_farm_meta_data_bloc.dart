import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/farm_meta_data_status.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/farm_metadata_events.dart';
import 'package:napta/modules/farm/data/repository/farm_meta_data_repository.dart';
import 'package:napta/core/functions/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateFarmMetaDataBloc
    extends Bloc<FarmMetaDataEvent, FarmMetaDataStatus> {
  FarmMetaDataRepositoryImp repository;
  UpdateFarmMetaDataBloc({required this.repository})
      : super(InitFarmMetaDataStatus()) {
    on<UpdateFarmMetaDataEvent>((event, emit) async {
      emit(LoadingFarmMetaDataStatus());
      var response = await repository.update(model: event.model);
      response.fold((failure) {
        emit(FarmMetaDataUpdatedFailedStatus(failure: failure));
      }, (message) {
        emit(FarmMetaDataUpdatedSuccessStatus(message: message));
      });
    });
  }
}
