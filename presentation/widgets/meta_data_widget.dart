import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:napta/core/functions/custom_navigation.dart';
import 'package:napta/core/functions/extensions.dart';
import 'package:napta/core/functions/responsive.dart';
import 'package:napta/modules/farm/data/models/farm_meta_data.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/delete_farm_meta_data_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/farm_metadata_events.dart';
import 'package:napta/modules/farm/presentation/bloc/production_date/production_date_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/production_date/production_event.dart';
import 'package:napta/modules/farm/presentation/view/edit_meta_data.dart';
import 'package:napta/modules/farm/presentation/widgets/delete_product_utils.dart';
import 'package:napta/core/resources/color_manager.dart';
import 'package:napta/core/resources/image_manager.dart';
import 'package:napta/core/widgets/shared/custom_icon.dart';
import 'package:napta/core/widgets/shared/custom_text.dart';
import 'package:napta/modules/lookups/presentation/bloc/metadata_types_handler/metadata_types_handler_bloc.dart';
import 'package:napta/modules/lookups/presentation/bloc/metadata_types_handler/metadata_types_handler_event.dart';
import 'package:napta/modules/home/data/model/schema_model.dart';

class MetaDataWidget extends StatelessWidget {
  SchemaModel schemaModel = SchemaModel(
      id: 1,
      color1: ColorManager.primary,
      color2: ColorManager.secondary.withOpacity(0.6),
      title: "محاصيل زراعية",
      icon: "assets/logo/crops.svg",
      onTap: () {});
  double width;
  double marginH;
  FarmMetaDataModel model;
  MetaDataWidget(
      {Key? key, this.width = 1, this.marginH = 15, required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      width: MediaQuery.of(context).size.width * width,
      height: MediaQuery.of(context).size.width * 0.3,
      margin: EdgeInsets.symmetric(
          horizontal: marginH.responsive(context),
          vertical: 5.responsive(context)),
      padding: EdgeInsets.symmetric(
          horizontal: 10.responsive(context), vertical: 5.responsive(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: ColorManager.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(10.responsive(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 20.responsive(context),
                      height: 20.responsive(context),
                      padding: EdgeInsets.all(5.responsive(context)),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(25.responsive(context)),
                        gradient: LinearGradient(
                          colors: [
                            schemaModel.color1,
                            schemaModel.color2,
                            schemaModel.color1,
                            schemaModel.color2,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: CustomIcon(
                        IconManager.category,
                        fit: BoxFit.contain,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 5.responsive(context)),
                    CustomText(
                      title: model.categoryName.notNull().toString(),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: ColorManager.primary,
                    ),
                  ],
                ),
                CustomText(
                  title: "كود : ${model.codeName.notNull()}",
                  fontWeight: FontWeight.w700,
                  fontSize: 9,
                ),
              ],
            ),
          ),
          VerticalDivider(
            thickness: 1.responsive(context),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  //BlocProvider.of<ProductionDateBloc>(context).add(UpdateProductionDateListEvent(selected: model.cycleDates));
                  BlocProvider.of<MetaDataTypesHandlerBlocForCreate>(context)
                      .add(GetAllTypesForMetaDataTypesHandlerForCreateEvent(
                          category: model.categoryId.notNull(),
                          subCategory: model.subCategoryId.notNull(),
                          code: model.codeId.notNull(),
                          product: model.productId.notNull()));

                  BlocProvider.of<ProductionDateBloc>(context)
                      .add(InitProductionDateEvent(farmMetaDataModel: model));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              EditProductFromFarm(model: model.clone())));
                },
                child: CustomIcon(
                  IconManager.editIcon,
                  size: 18.responsive(context),
                ),
              ),
              InkWell(
                onTap: () {
                  showMaterialModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25.responsive(context)),
                          topLeft: Radius.circular(25.responsive(context))),
                    ),
                    builder: (context) => DeleteProductBottomSheet(
                      yes: () {
                        CustomNavigation.pop(context);
                        BlocProvider.of<DeactivateFarmMetaDataBloc>(context)
                            .add(DeleteFarmMetaDataEvent(model: model));
                      },
                    ),
                  );
                },
                child: CustomIcon(
                  IconManager.delete,
                  size: 18.responsive(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
