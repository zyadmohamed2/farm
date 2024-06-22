import 'package:napta/modules/farm/data/models/farm_meta_data.dart';
import 'package:napta/modules/lookups/data/models/category_model.dart';

abstract class ProductionDateEvent {}

class InitProductionDateEvent extends ProductionDateEvent {
  FarmMetaDataModel? farmMetaDataModel;
  InitProductionDateEvent({this.farmMetaDataModel});
}

//
class UpdateProductionDateListEvent extends ProductionDateEvent {
  List<CategoryModel> selected;
  UpdateProductionDateListEvent({required this.selected});
}

class SelectCultivationMethod extends ProductionDateEvent {
  int selected;
  SelectCultivationMethod({required this.selected});
}

class UpdateProductionDateEvent extends ProductionDateEvent {
  CategoryModel selected;
  UpdateProductionDateEvent({required this.selected});
}
