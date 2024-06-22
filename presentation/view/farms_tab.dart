import 'package:napta/modules/farm/presentation/bloc/farm_bloc/get_user_farms_bloc.dart';
import 'package:napta/modules/lookups/presentation/bloc/egypt_location_bloc/egypt_location_bloc.dart';
import 'package:napta/modules/lookups/presentation/bloc/egypt_location_bloc/egypt_location_event.dart';
import 'package:napta/modules/map/presentation/bloc/location_bloc/location_status.dart';
import 'package:napta/modules/map/presentation/bloc/location_bloc/location_event.dart';
import 'package:napta/modules/map/presentation/bloc/location_bloc/location_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_bloc/farm_status.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_bloc/farm_event.dart';
import 'package:napta/modules/map/presentation/bloc/map_bloc/map_event.dart';
import 'package:napta/modules/map/presentation/bloc/map_bloc/map_bloc.dart';
import 'package:napta/modules/farm/presentation/widgets/farm_loading.dart';
import 'package:napta/modules/farm/presentation/widgets/farm_widget.dart';
import 'package:napta/modules/farm/presentation/view/create_farm.dart';
import 'package:napta/modules/image/image_bloc/image_event.dart';
import 'package:napta/modules/image/image_bloc/image_bloc.dart';
import 'package:napta/core/utils/custom_alert_controller.dart';
import 'package:napta/core/functions/custom_navigation.dart';
import 'package:napta/core/widgets/shared/custom_text.dart';
import 'package:napta/core/widgets/shared/custom_icon.dart';
import 'package:napta/core/resources/color_manager.dart';
import 'package:napta/core/resources/image_manager.dart';
import 'package:napta/core/widgets/no_data_widget.dart';
import 'package:napta/core/functions/responsive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class UserFarmsTab extends StatelessWidget {
  const UserFarmsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<GetUserFarmsBloc>(context).add(GetUserFarmsEvent());
      },
      color: ColorManager.primary,
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.responsive(context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.responsive(context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    title: "المزارع الخاصة بى",
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<ManageLocationBloc>(context)
                          .add(GetCurrentLocationEvent());
                    },
                    child:
                        BlocListener<ManageLocationBloc, ManageLocationStatus>(
                      listener: (context, status) {
                        if (status is LocationGotSuccessStatus) {
                          BlocProvider.of<PickImageBloc>(context)
                              .add(InitImageEvent());
                          CustomNavigation.push(context,
                              newPage: CreateFarmScreen(latLng: status.latLng));
                          BlocProvider.of<EgyptLocationBloc>(context)
                              .add(GetGovernForEgyptLocationEvent());
                          BlocProvider.of<ManageMapBloc>(context)
                              .add(CreateMapEvent(latLng: status.latLng));
                        } else if (status is LocationEnablesFailedStatus) {
                          CustomAlertController.show(context,
                              title:
                                  "برجاء تفعيل الموقع لكي تتمكن من استخدام الخريطة",
                              isError: true);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomText(
                            title: "إضافة مزرعة",
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                          SizedBox(width: 5.responsive(context)),
                          CustomIcon(
                            IconManager.addIcon,
                            color: ColorManager.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              CustomText(
                title: "يمكنك إضافة مزرعة او التعديل على مزرعة حالية",
                color: ColorManager.darkGrey,
                textAlign: TextAlign.start,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
              BlocBuilder<GetUserFarmsBloc, FarmStatus>(
                  builder: (context, status) {
                if (status is GotUserFarmsSuccessStatus) {
                  return Wrap(
                    children: status.farms.map((farmModel) {
                      return FarmWidget(farmModel: farmModel);
                    }).toList(),
                  );
                } else if (status is LoadingFarmStatus) {
                  return Wrap(
                    children: [1, 2, 3].map((farmModel) {
                      return FarmLoading();
                    }).toList(),
                  );
                } else {
                  return NoDataWidget();
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
