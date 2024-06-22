import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:napta/core/functions/extensions.dart';
import 'package:napta/modules/farm/presentation/bloc/production_date/production_event.dart';
import 'package:napta/modules/farm/presentation/bloc/production_date/production_state.dart';
import 'package:napta/modules/lookups/data/models/category_model.dart';

Map<int, CategoryModel> months = {
  1: CategoryModel(id: 1, name: "يناير"),
  2: CategoryModel(id: 2, name: "فبراير"),
  3: CategoryModel(id: 3, name: "مارس"),
  4: CategoryModel(id: 4, name: "أبريل"),
  5: CategoryModel(id: 5, name: "مايو"),
  6: CategoryModel(id: 6, name: "يونيو"),
  7: CategoryModel(id: 7, name: "يوليو"),
  8: CategoryModel(id: 8, name: "أغسطس"),
  9: CategoryModel(id: 9, name: "سبتمبر"),
  10: CategoryModel(id: 10, name: "أكتوبر"),
  11: CategoryModel(id: 11, name: "نوفمبر"),
  12: CategoryModel(id: 12, name: "ديسمبر"),
};
Map<int, CategoryModel> sessions = {
  1: CategoryModel(id: 1, name: "صيفي"),
  2: CategoryModel(id: 2, name: "شتوي"),
  3: CategoryModel(id: 3, name: "نيلي"),
  4: CategoryModel(id: 4, name: "بدون عروة"),
};
Map<int, CategoryModel> CultivationMethod = {
  1: CategoryModel(id: 1, name: "شهري"),
  2: CategoryModel(id: 2, name: "موسمي"),
};

class ProductionDateBloc
    extends Bloc<ProductionDateEvent, ProductionDateState> {
  Map<int, CategoryModel> selected = {};
  int methodType = 1;
  getData() => methodType == 1 ? months : sessions;

  ProductionDateBloc()
      : super(ProductionDateUpdatedSuccessState(
            data: months,
            selected: {},
            cultivationMethod: CultivationMethod,
            methodType: 1)) {
    on<InitProductionDateEvent>((event, emit) {
      selected = {};
      if (event.farmMetaDataModel != null) {
        methodType = event.farmMetaDataModel!.cultivationMethodId ?? 1;
        if (event.farmMetaDataModel!.cultivationMethodId == 1) {
          for (var element in event.farmMetaDataModel!.cycleDates!) {
            selected[element.date ?? 0] = CategoryModel(id: element.date ?? 0);
          }
        } else {
          for (var element in event.farmMetaDataModel!.seasonalCrops!) {
            selected[element.seasonId ?? 0] =
                CategoryModel(id: element.seasonId ?? 0);
          }
        }
      }
      emit(ProductionDateUpdatedSuccessState(
          data: getData(),
          selected: selected,
          cultivationMethod: CultivationMethod,
          methodType: methodType));
    });
    on<SelectCultivationMethod>((event, emit) {
      selected = {};
      methodType = event.selected;
      emit(ProductionDateUpdatedSuccessState(
          data: getData(),
          selected: selected,
          cultivationMethod: CultivationMethod,
          methodType: methodType));
    });
    on<UpdateProductionDateListEvent>((event, emit) {
      selected = {};
      for (var item in event.selected) {
        selected[item.id ?? 0] = item;
      }
      emit(ProductionDateUpdatedSuccessState(
          data: getData(),
          selected: selected,
          cultivationMethod: CultivationMethod,
          methodType: methodType));
    });

    on<UpdateProductionDateEvent>((event, emit) {
      if (selected.containsKey(event.selected.id)) {
        selected.remove(event.selected.id);
      } else {
        selected[event.selected.id.notNull()] = event.selected;
      }
      emit(ProductionDateUpdatedSuccessState(
          data: getData(),
          selected: selected,
          cultivationMethod: CultivationMethod,
          methodType: methodType));
    });
  }
}
