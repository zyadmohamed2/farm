import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/farm_meta_data_status.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/farm_metadata_events.dart';
import 'package:napta/modules/farm/data/repository/farm_meta_data_repository.dart';
import 'package:napta/core/functions/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeactivateFarmMetaDataBloc
    extends Bloc<FarmMetaDataEvent, FarmMetaDataStatus> {
  FarmMetaDataRepositoryImp repository;
  DeactivateFarmMetaDataBloc({required this.repository})
      : super(InitFarmMetaDataStatus()) {
    on<DeleteFarmMetaDataEvent>((event, emit) async {
      emit(LoadingFarmMetaDataStatus());
      var response = await repository.delete(id: event.model.id.notNull());
      response.fold((failure) {
        emit(FarmMetaDataDeletedFailedStatus(failure: failure));
      }, (message) {
        emit(FarmMetaDataDeletedSuccessStatus(
            message: message, farmId: event.model.farmId.notNull()));
      });
    });
  }
}
