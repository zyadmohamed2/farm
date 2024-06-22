import 'package:napta/modules/farm/data/models/farm.dart';

abstract class FarmEvent {}

class GetUserFarmsEvent extends FarmEvent {}

class AddNewFarmsEvent extends FarmEvent {
  FarmModel model;
  AddNewFarmsEvent({required this.model});
}

class UpdateFarmEvent extends FarmEvent {
  FarmModel model;
  UpdateFarmEvent({required this.model});
}

class DeleteFarmEvent extends FarmEvent {
  FarmModel model;
  DeleteFarmEvent({required this.model});
}
