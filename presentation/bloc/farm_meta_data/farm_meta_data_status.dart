import 'package:napta/modules/farm/data/models/farm_meta_data.dart';
import 'package:napta/core/error_handler/failure.dart';

abstract class FarmMetaDataStatus {}

class InitFarmMetaDataStatus extends FarmMetaDataStatus {}

class LoadingFarmMetaDataStatus extends FarmMetaDataStatus {}

class GetUserFarmMetaDatasSuccessStatus extends FarmMetaDataStatus {
  List<FarmMetaDataModel> data;
  GetUserFarmMetaDatasSuccessStatus({required this.data});
}

class GetUserFarmMetaDatasFailedStatus extends FarmMetaDataStatus {
  Failure failure;
  GetUserFarmMetaDatasFailedStatus({required this.failure});
}

class FarmMetaDataAddedSuccessStatus extends FarmMetaDataStatus {
  String message;
  FarmMetaDataAddedSuccessStatus({required this.message});
}

class FarmMetaDataAddedFailedStatus extends FarmMetaDataStatus {
  Failure failure;
  FarmMetaDataAddedFailedStatus({required this.failure});
}

class FarmMetaDataUpdatedSuccessStatus extends FarmMetaDataStatus {
  String message;
  FarmMetaDataUpdatedSuccessStatus({required this.message});
}

class FarmMetaDataUpdatedFailedStatus extends FarmMetaDataStatus {
  Failure failure;
  FarmMetaDataUpdatedFailedStatus({required this.failure});
}

class FarmMetaDataDeletedSuccessStatus extends FarmMetaDataStatus {
  String message;
  int farmId;
  FarmMetaDataDeletedSuccessStatus(
      {required this.message, required this.farmId});
}

class FarmMetaDataDeletedFailedStatus extends FarmMetaDataStatus {
  Failure failure;
  FarmMetaDataDeletedFailedStatus({required this.failure});
}
