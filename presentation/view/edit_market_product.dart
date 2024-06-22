import 'dart:developer';

import 'package:napta/core/model/image_model.dart';
import 'package:napta/core/widgets/shared/loading_widget.dart';
import 'package:napta/modules/farm/presentation/bloc/market_products_bloc/get_user_market_product_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/market_products_bloc/update_market_product_bloc.dart';
import 'package:napta/modules/image/image_bloc/image_bloc.dart';
import 'package:napta/modules/lookups/presentation/bloc/market_product_types/market_product_types_bloc.dart';
import 'package:napta/modules/lookups/presentation/bloc/market_product_types/market_product_types_event.dart';
import 'package:napta/modules/lookups/presentation/bloc/market_product_types/market_product_types_status.dart';
import 'package:napta/modules/farm/presentation/bloc/market_products_bloc/market_products_status.dart';
import 'package:napta/modules/farm/presentation/bloc/market_products_bloc/market_product_events.dart';
import 'package:napta/core/widgets/shared/custom_text_form_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:napta/core/widgets/shared/custom_drop_down.dart';
import 'package:napta/modules/image/widgets/picked_images.dart';
import 'package:napta/core/widgets/shared/custom_scaffold.dart';
import 'package:napta/core/utils/custom_alert_controller.dart';
import 'package:napta/core/widgets/shared/custom_button.dart';
import 'package:napta/modules/farm/data/models/product.dart';
import 'package:napta/core/functions/custom_navigation.dart';
import 'package:napta/core/widgets/shared/custom_text.dart';
import 'package:napta/core/widgets/shared/text_row.dart';
import 'package:napta/core/resources/color_manager.dart';
import 'package:napta/core/functions/extensions.dart';
import 'package:napta/core/functions/responsive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class EditProductMarket extends StatelessWidget {
  var inAsyncCall = ValueNotifier<bool>(false);
  static final formKey = GlobalKey<FormState>();
  MarketProductModel model;
  final product = ValueNotifier<MarketProductModel>(MarketProductModel());
  EditProductMarket({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    product.value = model;
    return BlocListener<UpdateMarketProductBloc, MarketProductsStatus>(
      listener: (context, state) {
        if (state is LoadingMarketProductsStatus) {
          inAsyncCall.value = true;
        } else if (state is MarketProductUpdatedSuccessStatus) {
          inAsyncCall.value = false;
          BlocProvider.of<GetUserMarketProductsBloc>(context)
              .add(GetUserMarketProductsEvent());
          CustomNavigation.pop(context);
          CustomAlertController.show(context, title: state.message);
        } else if (state is MarketProductUpdatedFailedStatus) {
          inAsyncCall.value = false;
          CustomAlertController.show(context,
              title: state.failure.message, isError: true);
        }
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: inAsyncCall,
        builder: (context, value, child) {
          return ModalProgressHUD(
            inAsyncCall: inAsyncCall.value,
            progressIndicator: const LoadingWidget(),
            child: CustomScaffold(
              title: "تعديل منتج",
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 10.responsive(context)),
                          BlocBuilder<MarketProductTypesBloc,
                              MarketProductTypesStatus>(
                            builder: (context, status) {
                              if (status is MarketProductTypesSuccessStatus) {
                                product.value.unitId =
                                    status.metaDataModel?.unitId;
                                product.value.farmMetaDataId =
                                    status.metaDataModel.id.notNull();
                                return Column(
                                  children: [
                                    TextRowHeader(
                                      title: "أضافة المنتج الي مزرعة",
                                      color: ColorManager.black,
                                    ),
                                    CustomerDropDownList(
                                      selected: status.controller[1]?.selectedId
                                          .notNull(),
                                      list: status.controller[1]!.data.values
                                          .toList(),
                                      onChanged: (int? id) {
                                        product.value.farmId = id.notNull();
                                        BlocProvider.of<MarketProductTypesBloc>(
                                                context)
                                            .add(
                                                GetMetaDataForMarketProductTypesEvent(
                                                    id: id.notNull()));
                                      },
                                    ),
                                    TextRowHeader(
                                      title: "نوع المنتج",
                                      color: ColorManager.black,
                                    ),
                                    CustomerDropDownList(
                                      selected: status.controller[2]?.selectedId
                                          .notNull(),
                                      list: status.controller[2]!.data.values
                                          .toList(),
                                      onChanged: (int? id) {
                                        BlocProvider.of<MarketProductTypesBloc>(
                                                context)
                                            .add(
                                                SelectMetaDataMarketProductTypesEvent(
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
                            title: "سعر المنتج",
                            hintText: "برجاء أدخال سعر المنتج",
                            textColor: ColorManager.black,
                            textInputType: TextInputType.number,
                            initialValue: product.value.price.toString(),
                            onChanged: (String? value) => product.value.price =
                                double.parse(value.toString()),
                            onSaved: (String? value) => product.value.price =
                                double.parse(value.toString()),
                            validator: (String? value) => value.isValid(),
                            password: false,
                            suffix: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.responsive(context)),
                                  child: CustomText(
                                    title: "كجم / جنيه",
                                    color: ColorManager.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                          CustomTextFormFiled(
                            title: "مدة عرض المنتج",
                            hintText: "أدخل مدة عرض المنتج منذ بداية الأضافة",
                            textColor: ColorManager.black,
                            initialValue: product.value.numberOfDays.toString(),
                            textInputType: TextInputType.number,
                            onSaved: (String? value) => product.value
                                .numberOfDays = int.parse(value.toString()),
                            validator: (String? value) => value.isValid(),
                            password: false,
                          ),
                          CustomTextFormFiled(
                            title: "الكمية",
                            hintText: "برجاء أدخال الكمية المتوفرة",
                            textColor: ColorManager.black,
                            textInputType: TextInputType.number,
                            initialValue: product.value.quantity.toString(),
                            onChanged: (String? value) => product
                                .value.quantity = int.parse(value.toString()),
                            onSaved: (String? value) => product.value.quantity =
                                int.parse(value.toString()),
                            validator: (String? value) => value.isValid(),
                            password: false,
                            suffix: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.responsive(context)),
                                  child: CustomText(
                                    title: "كجم",
                                    color: ColorManager.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                          CustomTextFormFiled(
                            title: "وصف الخدمة",
                            hintText: "أدخل وصف الخدمة",
                            initialValue: product.value.description.toString(),
                            textColor: ColorManager.black,
                            minLines: 2,
                            textInputType: TextInputType.text,
                            onSaved: (String? value) =>
                                product.value.description = value.notNull(),
                            validator: (String? value) => value.isValid(),
                            password: false,
                          ),
                          CustomTextFormFiled(
                            title: "خصائص الخدمة",
                            hintText: "أدخل خصائص الخدمة",
                            textColor: ColorManager.black,
                            initialValue: product.value.properties.toString(),
                            minLines: 4,
                            textInputType: TextInputType.text,
                            onSaved: (String? value) =>
                                product.value.properties = value.notNull(),
                            validator: (String? value) => value.isValid(),
                            password: false,
                          ),
                          TextRowHeader(
                            title: "صورة المنتج",
                            color: ColorManager.black,
                          ),
                          PickedImages(
                            title: "ارفاق صور للمنتج",
                            onPicked: (List<ImageModel> pickedImages,
                                List<ImageModel> removedImage) {
                              product.value.imagesForms = pickedImages;
                              product.value.imagesForms.addAll(removedImage);
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
                                BlocProvider.of<PickImageBloc>(context)
                                    .pickedImage
                                    .forEach((key, value) {
                                  log(key.toString());
                                  log(value.status.toString());
                                  log(value.type.toString());
                                });
                                BlocProvider.of<PickImageBloc>(context)
                                    .removedImage
                                    .forEach((value) {
                                  log(value.id.toString());
                                  log(value.status.toString());
                                  log(value.type.toString());
                                });
                                BlocProvider.of<UpdateMarketProductBloc>(
                                        context)
                                    .add(UpdateMarketProductEvent(
                                        model: product.value));
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
