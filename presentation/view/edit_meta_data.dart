// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable
import 'package:napta/modules/farm/presentation/widgets/month_widget.dart';
import 'package:napta/modules/lookups/presentation/bloc/metadata_types_handler/metadata_types_handler_event.dart';
import 'package:napta/modules/lookups/presentation/bloc/metadata_types_handler/metadata_types_handler_status.dart';
import 'package:napta/modules/lookups/presentation/bloc/metadata_types_handler/metadata_types_handler_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/update_farm_meta_data_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/get_farm_metadata_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/production_date/production_date_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/farm_meta_data_status.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/farm_metadata_events.dart';
import 'package:napta/modules/farm/presentation/bloc/production_date/production_event.dart';
import 'package:napta/modules/farm/presentation/bloc/production_date/production_state.dart';
import 'package:napta/modules/lookups/data/models/category_model.dart';
import 'package:napta/core/widgets/shared/custom_text_form_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:napta/modules/farm/data/models/farm_meta_data.dart';
import 'package:napta/core/widgets/shared/custom_drop_down.dart';
import 'package:napta/core/utils/custom_alert_controller.dart';
import 'package:napta/core/widgets/shared/loading_widget.dart';
import 'package:napta/core/widgets/shared/custom_scaffold.dart';
import 'package:napta/core/widgets/shared/custom_button.dart';
import 'package:napta/core/functions/custom_navigation.dart';
import 'package:napta/core/widgets/shared/custom_text.dart';
import 'package:napta/core/resources/color_manager.dart';
import 'package:napta/core/widgets/shared/text_row.dart';
import 'package:napta/core/functions/extensions.dart';
import 'package:napta/core/functions/responsive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class EditProductFromFarm extends StatelessWidget {
  var onSaved;
  FarmMetaDataModel model;
  var inAsyncCall = ValueNotifier<bool>(false);
  static final formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  var farmMetaData = ValueNotifier<FarmMetaDataModel>(
      FarmMetaDataModel(isDeleted: false, cycleDates: [], seasonalCrops: []));

  EditProductFromFarm({Key? key, this.onSaved, required this.model})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    farmMetaData.value = model;
    return BlocListener<UpdateFarmMetaDataBloc, FarmMetaDataStatus>(
      listener: (context, state) {
        if (state is LoadingFarmMetaDataStatus) {
          inAsyncCall.value = true;
        } else if (state is FarmMetaDataUpdatedSuccessStatus) {
          inAsyncCall.value = false;
          BlocProvider.of<GetFarmMetaDataBloc>(context).add(
              GetFarmMetaDatasEvent(
                  farmId: farmMetaData.value.farmId.notNull()));
          CustomNavigation.pop(context);
          CustomAlertController.show(context, title: state.message);
        } else if (state is FarmMetaDataUpdatedFailedStatus) {
          inAsyncCall.value = false;
          CustomAlertController.show(context,
              title: state.failure.message, isError: true);
        }
      },
      child: ValueListenableBuilder(
        valueListenable: inAsyncCall,
        builder: (context, value, child) {
          return ModalProgressHUD(
            inAsyncCall: inAsyncCall.value,
            progressIndicator: const LoadingWidget(),
            child: CustomScaffold(
              title: "تعديل المنتج",
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 10.responsive(context)),
                          BlocBuilder<MetaDataTypesHandlerBlocForCreate,
                              MetaDataTypesHandlerForCreateStatus>(
                            builder: (context, status) {
                              if (status
                                  is MetaDataTypesHandlerForCreateSuccessStatus) {
                                return Column(
                                  children: [
                                    TextRowHeader(
                                      title: "القسم الرئيسي",
                                      color: ColorManager.black,
                                    ),
                                    CustomerDropDownList(
                                      selected: status.controller[1]?.selectedId
                                          .notNull(),
                                      list: status.controller[1]!.data.values
                                          .toList(),
                                      onChanged: (int? id) {
                                        farmMetaData.value.categoryId =
                                            id.notNull();
                                        BlocProvider.of<
                                                    MetaDataTypesHandlerBlocForCreate>(
                                                context)
                                            .add(
                                                GetSubCategoriesForMetaDataTypesHandlerForCreateEvent(
                                                    id: id.notNull()));
                                      },
                                    ),
                                    TextRowHeader(
                                      title: "القسم الفرعي",
                                      color: ColorManager.black,
                                    ),
                                    CustomerDropDownList(
                                      selected: status.controller[2]?.selectedId
                                          .notNull(),
                                      list: status.controller[2]!.data.values
                                          .toList(),
                                      onChanged: (int? id) {
                                        farmMetaData.value.subCategoryId =
                                            id.notNull();
                                        BlocProvider.of<
                                                    MetaDataTypesHandlerBlocForCreate>(
                                                context)
                                            .add(
                                                GetProductsForMetaDataTypesHandlerForCreateEvent(
                                                    id: id.notNull()));
                                      },
                                    ),
                                    TextRowHeader(
                                      title: "نوع المنتج",
                                      color: ColorManager.black,
                                    ),
                                    CustomerDropDownList(
                                      selected: status.controller[3]?.selectedId
                                          .notNull(),
                                      list: status.controller[3]!.data.values
                                          .toList(),
                                      onChanged: (int? id) {
                                        farmMetaData.value.productId =
                                            id.notNull();
                                        BlocProvider.of<
                                                    MetaDataTypesHandlerBlocForCreate>(
                                                context)
                                            .add(
                                                GetCodesForMetaDataTypesHandlerForCreateEvent(
                                                    id: id.notNull()));
                                      },
                                    ),
                                    TextRowHeader(
                                      title: "كود المنتج",
                                      color: ColorManager.black,
                                    ),
                                    CustomerDropDownList(
                                      selected: status.controller[4]?.selectedId
                                          .notNull(),
                                      list: status.controller[4]!.data.values
                                          .toList(),
                                      onChanged: (int? id) {
                                        farmMetaData.value.codeId =
                                            id.notNull();
                                        BlocProvider.of<
                                                    MetaDataTypesHandlerBlocForCreate>(
                                                context)
                                            .add(
                                                SelectCodesForMetaDataTypesHandlerForCreateEvent(
                                                    id: id.notNull()));
                                      },
                                    ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                          CustomTextFormFiled(
                            title: "السعة الانتاجية",
                            hintText: "مثال : 30 كيلو في الدورة الواحدة",
                            onSaved: (String? value) => farmMetaData
                                .value.capacity = int.parse(value ?? "0"),
                            validator: (String? value) => value.isValid(),
                            initialValue: farmMetaData.value.capacity
                                .toString()
                                .notNull(),
                            textColor: ColorManager.black,
                            textInputType: TextInputType.number,
                            password: false,
                          ),
                          BlocConsumer<ProductionDateBloc, ProductionDateState>(
                            listener: (context, state) {
                              if (state is ProductionDateUpdatedSuccessState) {
                                //farmMetaData.value.cycleDates = state.selected;
                                if (state.selected.isNotEmpty) {
                                  controller.text = farmMetaData
                                      .value.cycleDates!.length
                                      .toString();
                                } else {
                                  controller.text = "";
                                }
                              }
                            },
                            builder: (context, state) {
                              if (state is ProductionDateUpdatedSuccessState) {
                                return Column(
                                  children: [
                                    TextRowHeader(
                                      title: "أضغط لتحديد شهور بدأ الدورات",
                                      color: ColorManager.black,
                                      horizontal: 15,
                                    ),
                                    CustomerDropDownList(
                                        selected: state.methodType,
                                        list: state.cultivationMethod.values
                                            .toList(),
                                        onChanged: (int? id) {
                                          farmMetaData
                                              .value.cultivationMethodId = id;
                                          BlocProvider.of<ProductionDateBloc>(
                                                  context)
                                              .add(SelectCultivationMethod(
                                                  selected: id ?? 1));
                                        }),
                                    TextRowHeader(
                                      title: "أضغط لتحديد شهور بدأ الدورات",
                                      color: ColorManager.black,
                                      horizontal: 15,
                                    ),
                                    Container(
                                      color: ColorManager.white,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 15.responsive(context),
                                          vertical: 5.responsive(context)),
                                      child: Column(
                                        children: [
                                          Center(
                                            child: Wrap(
                                              children: state.data.values
                                                  .map((model) {
                                                return CultivationMethodWidget(
                                                  model: model,
                                                  isSelected: state.selected
                                                      .containsKey(model.id),
                                                  cultivationType:
                                                      state.methodType,
                                                );
                                              }).toList(),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                          SizedBox(
                            height: 20.responsive(context),
                          ),
                          CustomButton(
                            title: "تعديل المنتج",
                            marginH: 15,
                            onTap: () {
                              if (formKey.currentState?.validate() == true) {
                                formKey.currentState?.save();
                                farmMetaData.value.cycleDates = [];
                                farmMetaData.value.seasonalCrops = [];
                                BlocProvider.of<ProductionDateBloc>(context)
                                    .selected
                                    .values
                                    .forEach((element) {
                                  if (farmMetaData.value.cultivationMethodId ==
                                      1) {
                                    farmMetaData.value.cycleDates!
                                        .add(CycleDates(date: element.id));
                                    farmMetaData.value.cycleNumber =
                                        farmMetaData.value.cycleDates!.length;
                                  } else {
                                    farmMetaData.value.seasonalCrops!.add(
                                        SeasonalCrops(seasonId: element.id));
                                    farmMetaData.value.cycleNumber =
                                        farmMetaData
                                            .value.seasonalCrops!.length;
                                  }
                                });
                                BlocProvider.of<UpdateFarmMetaDataBloc>(context)
                                    .add(UpdateFarmMetaDataEvent(
                                        model: farmMetaData.value));
                              }
                            },
                          ),
                          SizedBox(
                            height: 20.responsive(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
