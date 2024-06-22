import 'package:napta/modules/lookups/presentation/bloc/metadata_types_handler/metadata_types_handler_event.dart';
import 'package:napta/modules/lookups/presentation/bloc/metadata_types_handler/metadata_types_handler_bloc.dart';
import 'package:napta/modules/lookups/presentation/bloc/egypt_location_bloc/egypt_location_event.dart';
import 'package:napta/modules/lookups/presentation/bloc/egypt_location_bloc/egypt_location_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/delete_farm_meta_data_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/get_farm_metadata_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/production_date/production_date_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/farm_meta_data_status.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/farm_metadata_events.dart';
import 'package:napta/modules/farm/presentation/bloc/production_date/production_event.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_bloc/get_user_farms_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_bloc/farm_event.dart';
import 'package:napta/modules/farm/presentation/widgets/meta_data_loading.dart';
import 'package:napta/modules/farm/presentation/widgets/meta_data_widget.dart';
import 'package:napta/modules/map/presentation/bloc/map_bloc/map_event.dart';
import 'package:napta/modules/lookups/data/models/category_model.dart';
import 'package:napta/modules/home/presentation/widgets/section_header.dart';
import 'package:napta/modules/farm/presentation/view/edit_farm_screen.dart';
import 'package:napta/modules/map/presentation/bloc/map_bloc/map_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:napta/modules/image/image_bloc/image_event.dart';
import 'package:napta/modules/image/image_bloc/image_bloc.dart';
import 'package:napta/core/widgets/shared/custom_scaffold.dart';
import 'package:napta/core/utils/custom_alert_controller.dart';
import 'package:napta/core/widgets/shared/loading_widget.dart';
import 'package:napta/core/widgets/shared/custom_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:napta/core/widgets/shared/custom_icon.dart';
import 'package:napta/core/widgets/shared/custom_text.dart';
import 'package:napta/core/functions/get_device_type.dart';
import 'package:napta/modules/farm/data/models/farm.dart';
import 'package:napta/core/resources/color_manager.dart';
import 'package:napta/core/resources/image_manager.dart';
import 'package:napta/core/data_source/remote_data.dart';
import 'package:napta/core/functions/extensions.dart';
import 'package:napta/core/functions/responsive.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'add_meta_data.dart';

class FarmUserDetailsScreen extends StatefulWidget {
  FarmModel farmModel;
  FarmUserDetailsScreen({Key? key, required this.farmModel}) : super(key: key);

  @override
  State<FarmUserDetailsScreen> createState() => _FarmUserDetailsScreenState();
}

class _FarmUserDetailsScreenState extends State<FarmUserDetailsScreen> {
  var imageError = ValueNotifier<bool>(false);

  var inAsyncCall = ValueNotifier<bool>(false);

  late ScrollController scrollController;

  late GetFarmMetaDataBloc getUserServicesBloc;

  @override
  void initState() {
    getUserServicesBloc = context.read<GetFarmMetaDataBloc>();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    super.initState();
  }

  _onScroll() {
    if (scrollController.hasClients) {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        getUserServicesBloc
            .add(GetMoreFarmMetaDatasEvent(farmId: widget.farmModel.id!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: widget.farmModel.name.notNull(),
      top: 56,
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<GetFarmMetaDataBloc>(context)
              .add(GetFarmMetaDatasEvent(farmId: widget.farmModel.id!));
        },
        color: ColorManager.primary,
        child: BlocListener<DeactivateFarmMetaDataBloc, FarmMetaDataStatus>(
          listener: (context, state) {
            if (state is LoadingFarmMetaDataStatus) {
              inAsyncCall.value = true;
            } else if (state is FarmMetaDataDeletedSuccessStatus) {
              inAsyncCall.value = false;
              BlocProvider.of<GetFarmMetaDataBloc>(context)
                  .add(GetFarmMetaDatasEvent(farmId: state.farmId));
              BlocProvider.of<GetUserFarmsBloc>(context)
                  .add(GetUserFarmsEvent());
              CustomAlertController.show(context, title: state.message);
            } else if (state is FarmMetaDataDeletedFailedStatus) {
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
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ValueListenableBuilder<bool>(
                            valueListenable: imageError,
                            builder: (state, value, child) {
                              return Container(
                                height: 150.responsive(context),
                                decoration: imageError.value == false &&
                                        widget.farmModel.farmImages!.isNotEmpty
                                    ? BoxDecoration(
                                        color: ColorManager.white,
                                        image: DecorationImage(
                                          image: NetworkImage((BASE_URL +
                                                  widget.farmModel.farmImages!
                                                      .values.first
                                                      .toString())
                                              .replaceAll("\\", '/')),
                                          onError: (e, p) {
                                            imageError.value = true;
                                          },
                                          fit: BoxFit.cover,
                                          filterQuality: FilterQuality.high,
                                          isAntiAlias: true,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            10.responsive(context)),
                                      )
                                    : BoxDecoration(
                                        color: ColorManager.white,
                                        borderRadius: BorderRadius.circular(
                                            10.responsive(context)),
                                      ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: ColorManager.yellow,
                                            borderRadius: BorderRadius.circular(
                                                8.responsive(context)),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                const Color.fromRGBO(
                                                        12, 124, 84, 0.91)
                                                    .withOpacity(0.75),
                                                const Color.fromRGBO(
                                                        227, 209, 16, 0.91)
                                                    .withOpacity(0.75),
                                              ],
                                              stops: const [
                                                0.2885,
                                                1.5794,
                                              ],
                                            ),
                                          ),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 8.responsive(context),
                                              vertical: 8.responsive(context)),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.responsive(context),
                                              vertical: 4.responsive(context)),
                                          child: Row(
                                            children: [
                                              CustomIcon(
                                                IconManager.store,
                                                size: 18.responsive(context),
                                                color: ColorManager.white,
                                              ),
                                              SizedBox(
                                                  width: 5.responsive(context)),
                                              CustomText(
                                                title:
                                                    "${widget.farmModel.farmMetaDataCount.notNull().toString()} منتج",
                                                fontSize: 9,
                                                color: ColorManager.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 5.responsive(context)),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.responsive(context)),
                            child: CustomText(
                              title: widget.farmModel.name.notNull(),
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 5.responsive(context)),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.responsive(context)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomIcon(
                                  IconManager.map,
                                  size: 20.responsive(context),
                                ),
                                SizedBox(width: 3.responsive(context)),
                                Expanded(
                                  child: CustomText(
                                    title: widget.farmModel.addressDetails
                                        .notNull(),
                                    fontSize: 11,
                                    color: ColorManager.darkGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5.responsive(context)),
                          SectionHeader(
                            title: "المنتجات",
                          ),
                          BlocBuilder<GetFarmMetaDataBloc, FarmMetaDataStatus>(
                            builder: (context, status) {
                              if (status is GetUserFarmMetaDatasSuccessStatus) {
                                return Wrap(
                                  children: status.data.map((model) {
                                    return MetaDataWidget(
                                      width: 1,
                                      marginH: 15,
                                      model: model,
                                    );
                                  }).toList(),
                                );
                              } else if (status is LoadingFarmMetaDataStatus) {
                                return Wrap(
                                  children: [1, 2, 3, 4].map((e) {
                                    return UserProductLoading(
                                      marginH: 15,
                                      width: 1,
                                    );
                                  }).toList(),
                                );
                              } else {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.responsive(context),
                                        vertical: 20.responsive(context)),
                                    child: CustomText(
                                      title: "لا يوجد منتجات حتي الان",
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          /*
                          SizedBox(height: 15.responsive(context)),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(
                                horizontal: 15.responsive(context)
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: CustomText(
                                    title: "الاكثر مبيعا",
                                    color: ColorManager.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: filter(context),
                                )
                              ],
                            ),
                          ),
                          Wrap(
                            children: [1].map((e){
                              return Container(
                                width: MediaQuery.of(context).size.width ,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 15.responsive(context),
                                    vertical: 5.responsive(context)
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.responsive(context),
                                    vertical: 10.responsive(context)
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: ColorManager.grey.withOpacity(0.2)),
                                  borderRadius: BorderRadius.circular(8.responsive(context)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          title: "اسم المنتج",
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: ColorManager.primary,
                                        ),
                                        CustomText(
                                          title: "95%",
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: ColorManager.primary,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.responsive(context)),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: LayoutBuilder(
                                            builder: (context , constrains){
                                              return LinearPercentIndicator(
                                                width: constrains.maxWidth,
                                                padding: EdgeInsets.zero,
                                                lineHeight: 12.responsive(context),
                                                percent: 0.5,
                                                isRTL: true,
                                                barRadius: Radius.circular(10.responsive(context)),
                                                animation: true,
                                                restartAnimation: true,
                                                backgroundColor: ColorManager.lightGrey,
                                                progressColor: ColorManager.primary,
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.responsive(context)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(4.responsive(context)),
                                              decoration : BoxDecoration(
                                                  color: const Color(0xff0F9968).withOpacity(0.18),
                                                  borderRadius: BorderRadius.circular(10.responsive(context))
                                              ),
                                              width: 20.responsive(context),
                                              height: 20.responsive(context),
                                              child: CustomIcon(
                                                IconManager.order,
                                                color: ColorManager.primary,
                                              ),
                                            ),
                                            SizedBox(width: 8.responsive(context),),
                                            CustomText(
                                              title: "935 طلب",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(4.responsive(context)),
                                              decoration : BoxDecoration(
                                                  color: const Color(0xff0F9968).withOpacity(0.18),
                                                  borderRadius: BorderRadius.circular(10.responsive(context))
                                              ),
                                              width: 20.responsive(context),
                                              height: 20.responsive(context),
                                              child: CustomIcon(
                                                IconManager.dollar,
                                                color: ColorManager.primary,
                                              ),
                                            ),
                                            SizedBox(width: 8.responsive(context),),
                                            CustomText(
                                              title: "12000 جنية ارباح",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                           */
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 5)
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        color: ColorManager.backGroundColor,
                        child: Column(
                          children: [
                            SizedBox(height: 10.responsive(context)),
                            CustomButton(
                              title: "اضافة المنتج",
                              onTap: () {
                                BlocProvider.of<ProductionDateBloc>(context)
                                    .add(InitProductionDateEvent());
                                BlocProvider.of<
                                            MetaDataTypesHandlerBlocForCreate>(
                                        context)
                                    .add(
                                        GetCategoriesForMetaDataTypesHandlerForCreateEvent());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => AddProductToFarm(
                                            farmId: widget.farmModel.id!)));
                              },
                              buttonColor: ColorManager.white,
                              textColor: ColorManager.black,
                              borderColor: ColorManager.black,
                            ),
                            SizedBox(height: 10.responsive(context)),
                            CustomButton(
                              title: "تعديل المزرعة",
                              onTap: () {
                                BlocProvider.of<EgyptLocationBloc>(context).add(
                                    GetAllTypesForEgyptLocationEvent(
                                        government: widget
                                            .farmModel.governmentId
                                            .notNull(),
                                        center:
                                            widget.farmModel.centerId.notNull(),
                                        village: widget.farmModel.villageId
                                            .notNull()));
                                BlocProvider.of<ManageMapBloc>(context).add(
                                    CreateMapEvent(
                                        latLng: LatLng(
                                            widget.farmModel.latitude!,
                                            widget.farmModel.longitude!)));
                                BlocProvider.of<PickImageBloc>(context).add(
                                    SetImagesEvent(
                                        images: widget.farmModel.imagesForms));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditFarmScreen(
                                          latLng: LatLng(
                                              widget.farmModel.latitude!,
                                              widget.farmModel.longitude!),
                                          editFarmModel:
                                              widget.farmModel.clone()),
                                    ));
                              },
                            ),
                            SizedBox(height: 10.responsive(context)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  filter(context) {
    return Container(
      decoration: BoxDecoration(
          color: ColorManager.white,
          border: Border.all(
              width: 1.responsive(context), color: ColorManager.extraLightGrey),
          borderRadius: BorderRadius.circular(10.responsive(context))),
      padding: EdgeInsets.symmetric(
        horizontal: 10.responsive(context),
        vertical: getDeviceType(MediaQuery.of(context)).deviceType ==
                DeviceType.tablet
            ? 3.responsive(context)
            : 0,
      ),
      child: DropdownButton(
        items: [
          CategoryModel(id: 1, name: "هذا الاسبوع"),
          CategoryModel(id: 2, name: "هذا الشهر"),
        ].map((e) {
          return DropdownMenuItem(
              value: e.id,
              alignment: AlignmentDirectional.centerStart,
              child: CustomText(
                title: e.name.notNull(),
                fontWeight: FontWeight.w400,
                fontSize: 11,
                color: ColorManager.grey,
                textAlign: TextAlign.start,
              ));
        }).toList(),
        onChanged: (int? i) {},
        icon: CustomIcon(
          IconManager.downArrow,
          color: ColorManager.grey,
        ),
        iconSize: 20.responsive(context),
        value: 1,
        underline: Container(),
        isExpanded: true,
      ),
    );
  }
}
