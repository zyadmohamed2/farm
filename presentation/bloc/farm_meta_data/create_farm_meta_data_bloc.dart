import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/farm_meta_data_status.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/farm_metadata_events.dart';
import 'package:napta/modules/farm/data/repository/farm_meta_data_repository.dart';
import 'package:napta/core/functions/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateFarmMetaDataBloc
    extends Bloc<FarmMetaDataEvent, FarmMetaDataStatus> {
  FarmMetaDataRepositoryImp repository;
  CreateFarmMetaDataBloc({required this.repository})
      : super(InitFarmMetaDataStatus()) {
    on<AddNewFarmMetaDataEvent>((event, emit) async {
      emit(LoadingFarmMetaDataStatus());
      var response = await repository.create(model: event.model);
      response.fold((failure) {
        emit(FarmMetaDataAddedFailedStatus(failure: failure));
      }, (message) {
        emit(FarmMetaDataAddedSuccessStatus(message: message));
      });
    });
  }
}
