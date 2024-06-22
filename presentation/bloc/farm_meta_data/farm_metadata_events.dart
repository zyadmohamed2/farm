import 'package:napta/modules/farm/data/models/farm_meta_data.dart';

abstract class FarmMetaDataEvent {}

class GetFarmMetaDatasEvent extends FarmMetaDataEvent {
  int farmId;
  GetFarmMetaDatasEvent({required this.farmId});
}

class GetMoreFarmMetaDatasEvent extends FarmMetaDataEvent {
  int farmId;
  GetMoreFarmMetaDatasEvent({required this.farmId});
}

class AddNewFarmMetaDataEvent extends FarmMetaDataEvent {
  FarmMetaDataModel model;
  AddNewFarmMetaDataEvent({required this.model});
}

class UpdateFarmMetaDataEvent extends FarmMetaDataEvent {
  FarmMetaDataModel model;
  UpdateFarmMetaDataEvent({required this.model});
}

class DeleteFarmMetaDataEvent extends FarmMetaDataEvent {
  FarmMetaDataModel model;
  DeleteFarmMetaDataEvent({required this.model});
}
