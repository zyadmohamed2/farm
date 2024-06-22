import 'package:napta/core/error_handler/failure.dart';
import 'package:napta/modules/farm/data/models/farm.dart';

abstract class FarmStatus {}

class InitFarmStatus extends FarmStatus {}

class LoadingFarmStatus extends FarmStatus {}

class GotUserFarmsSuccessStatus extends FarmStatus {
  List<FarmModel> farms;
  GotUserFarmsSuccessStatus({required this.farms});
}

class GotUserFarmsFailedStatus extends FarmStatus {
  Failure failure;
  GotUserFarmsFailedStatus({required this.failure});
}

class FarmAddedSuccessStatus extends FarmStatus {
  String message;
  FarmAddedSuccessStatus({required this.message});
}

class FarmAddedFailedStatus extends FarmStatus {
  Failure failure;
  FarmAddedFailedStatus({required this.failure});
}

class FarmUpdatedSuccessStatus extends FarmStatus {
  String message;
  FarmUpdatedSuccessStatus({required this.message});
}

class FarmUpdatedFailedStatus extends FarmStatus {
  Failure failure;
  FarmUpdatedFailedStatus({required this.failure});
}

class FarmDeletedSuccessStatus extends FarmStatus {
  String message;
  FarmDeletedSuccessStatus({required this.message});
}

class FarmDeletedFailedStatus extends FarmStatus {
  Failure failure;
  FarmDeletedFailedStatus({required this.failure});
}
