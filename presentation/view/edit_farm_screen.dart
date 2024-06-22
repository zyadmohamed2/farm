import 'dart:math';

import 'package:napta/modules/lookups/presentation/bloc/egypt_location_bloc/egypt_location_status.dart';
import 'package:napta/modules/lookups/presentation/bloc/egypt_location_bloc/egypt_location_event.dart';
import 'package:napta/modules/lookups/presentation/bloc/egypt_location_bloc/egypt_location_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_bloc/get_user_farms_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_bloc/farm_status.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_bloc/farm_event.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_bloc/farm_bloc.dart';
import 'package:napta/modules/map/presentation/bloc/map_bloc/map_event.dart';
import 'package:napta/modules/map/presentation/bloc/map_bloc/map_bloc.dart';
import 'package:napta/modules/map/presentation/widgets/map_widget.dart';
import 'package:napta/core/widgets/shared/custom_text_form_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:napta/core/widgets/shared/custom_drop_down.dart';
import 'package:napta/core/widgets/shared/custom_scaffold.dart';
import 'package:napta/modules/image/widgets/picked_images.dart';
import 'package:napta/core/widgets/shared/loading_widget.dart';
import 'package:napta/core/utils/custom_alert_controller.dart';
import 'package:napta/core/widgets/shared/custom_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:napta/core/functions/custom_navigation.dart';
import 'package:napta/modules/farm/data/models/farm.dart';
import 'package:napta/core/resources/color_manager.dart';
import 'package:napta/core/widgets/shared/text_row.dart';
import 'package:napta/core/functions/extensions.dart';
import 'package:napta/core/functions/responsive.dart';
import 'package:napta/core/model/image_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class EditFarmScreen extends StatelessWidget {
  LatLng latLng;
  var farmModel = ValueNotifier<FarmModel>(
      FarmModel(isDeleted: false, latitude: 0, longitude: 0, imagesForms: []));
  FarmModel editFarmModel;
  var inAsyncCall = ValueNotifier<bool>(false);
  static final formKey = GlobalKey<FormState>();
  EditFarmScreen({Key? key, required this.latLng, required this.editFarmModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (farmModel.value.latitude == 0 || farmModel.value.longitude == 0) {
      farmModel.value = editFarmModel;
      farmModel.value.longitude = latLng.longitude;
      farmModel.value.latitude = latLng.latitude;
    }
    return BlocListener<FarmManagementBloc, FarmStatus>(
      listener: (context, state) {
        if (state is LoadingFarmStatus) {
          inAsyncCall.value = true;
        } else if (state is FarmUpdatedSuccessStatus) {
          inAsyncCall.value = false;
          CustomNavigation.pop(context);
          CustomNavigation.pop(context);
          CustomAlertController.show(context, title: state.message);
          BlocProvider.of<GetUserFarmsBloc>(context).add(GetUserFarmsEvent());
        } else if (state is FarmUpdatedFailedStatus) {
          inAsyncCall.value = false;
          CustomAlertController.show(context,
              title: state.failure.message, isError: true);
        }
      },
      child: ValueListenableBuilder(
        valueListenable: inAsyncCall,
        builder: (BuildContext context, bool value, Widget? child) {
          return ModalProgressHUD(
            inAsyncCall: inAsyncCall.value,
            progressIndicator: const LoadingWidget(),
            child: DefaultTabController(
              length: 2,
              child: CustomScaffold(
                  title: "تعديل مزرعة جديدة",
                  body: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 15.responsive(context)),
                          CustomTextFormFiled(
                            title: "اسم المزرعة",
                            hintText: "برجاء أدخال أسم المزرعة",
                            initialValue: farmModel.value.name.notNull(),
                            onSaved: (String? value) =>
                                farmModel.value.name = value,
                            validator: (String? value) => value.isValid(),
                            textColor: ColorManager.black,
                            password: false,
                          ),
                          CustomTextFormFiled(
                            title: "العنوان",
                            hintText: "برجاء أدخال عنوان المزرعة",
                            initialValue:
                                farmModel.value.addressDetails.notNull(),
                            textColor: ColorManager.black,
                            onSaved: (String? value) =>
                                farmModel.value.addressDetails = value,
                            validator: (String? value) => value.isValid(),
                            minLines: 2,
                            password: false,
                          ),
                          BlocBuilder<EgyptLocationBloc, EgyptLocationStatus>(
                            builder: (context, status) {
                              if (status is EgyptLocationSuccessStatus) {
                                return Column(
                                  children: [
                                    TextRowHeader(
                                      title: "المحافظة",
                                      color: ColorManager.black,
                                    ),
                                    CustomerDropDownList(
                                      selected: status.controller[1]?.selectedId
                                          .notNull(),
                                      list: status.controller[1]!.data.values
                                          .toList(),
                                      onChanged: (int? id) {
                                        farmModel.value.governmentId =
                                            id.notNull();
                                        BlocProvider.of<EgyptLocationBloc>(
                                                context)
                                            .add(GetCenterForEgyptLocationEvent(
                                                id: id.notNull()));
                                      },
                                    ),
                                    TextRowHeader(
                                      title: "المركز",
                                      color: ColorManager.black,
                                    ),
                                    CustomerDropDownList(
                                      selected: status.controller[2]?.selectedId
                                          .notNull(),
                                      list: status.controller[2]!.data.values
                                          .toList(),
                                      onChanged: (int? id) {
                                        farmModel.value.centerId = id.notNull();
                                        BlocProvider.of<EgyptLocationBloc>(
                                                context)
                                            .add(
                                                GetVillageForEgyptLocationEvent(
                                                    id: id.notNull()));
                                      },
                                    ),
                                    TextRowHeader(
                                      title: "القرية",
                                      color: ColorManager.black,
                                    ),
                                    CustomerDropDownList(
                                      selected: status.controller[3]?.selectedId
                                          .notNull(),
                                      list: status.controller[3]!.data.values
                                          .toList(),
                                      onChanged: (int? id) {
                                        farmModel.value.villageId =
                                            id.notNull();
                                        BlocProvider.of<EgyptLocationBloc>(
                                                context)
                                            .add(
                                                SelectVillageForEgyptLocationEvent(
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
                          SizedBox(
                            height: 3.responsive(context),
                          ),
                          TextRowHeader(
                            title: "صورة المزرعة",
                            color: ColorManager.black,
                          ),
                          PickedImages(
                            title: "ارفاق صور للمزرعة",
                            numberOfImages: 1,
                            onPicked: (List<ImageModel> pickedImages,
                                List<ImageModel> removedImage) {
                              farmModel.value.imagesForms = pickedImages;
                              farmModel.value.imagesForms.addAll(removedImage);
                            },
                          ),
                          SizedBox(
                            height: 3.responsive(context),
                          ),
                          TextRowHeader(
                            title: "موقع المزرعة على الخريطة",
                            color: ColorManager.black,
                          ),
                          MapWidget(
                            onLongPress: (LatLng latLng) {
                              farmModel.value.longitude = latLng.longitude;
                              farmModel.value.latitude = latLng.latitude;
                              BlocProvider.of<ManageMapBloc>(context)
                                  .add(UpdateMapEvent(latLng: latLng));
                            },
                          ),
                          SizedBox(
                            height: 20.responsive(context),
                          ),
                          CustomButton(
                            title: "تعديل المزرعة",
                            buttonColor: ColorManager.secondary,
                            onTap: () {
                              if (formKey.currentState?.validate() == true) {
                                formKey.currentState?.save();
                                BlocProvider.of<FarmManagementBloc>(context)
                                    .add(UpdateFarmEvent(
                                        model: farmModel.value));
                              }
                            },
                          ),
                          SizedBox(height: 20.responsive(context)),
                        ],
                      ),
                    ),
                  )),
            ),
          );
        },
      ),
    );
  }

  getTabHeader({required String title}) {
    return Tab(
      text: title,
    );
  }
}
