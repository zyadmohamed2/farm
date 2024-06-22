import 'dart:developer';

import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/get_farm_metadata_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/farm_metadata_events.dart';
import 'package:napta/modules/farm/presentation/view/farm_users_details.dart';
import 'package:napta/core/widgets/shared/custom_icon.dart';
import 'package:napta/core/widgets/shared/custom_text.dart';
import 'package:napta/modules/farm/data/models/farm.dart';
import 'package:napta/core/resources/color_manager.dart';
import 'package:napta/core/data_source/remote_data.dart';
import 'package:napta/core/resources/image_manager.dart';
import 'package:napta/core/functions/extensions.dart';
import 'package:napta/core/functions/responsive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class FarmWidget extends StatelessWidget {
  FarmModel farmModel;
  var imageError = ValueNotifier<bool>(false);
  double marginH;
  FarmWidget({super.key, required this.farmModel, this.marginH = 0});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<GetFarmMetaDataBloc>(context)
            .add(GetFarmMetaDatasEvent(farmId: farmModel.id.notNull()));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => FarmUserDetailsScreen(farmModel: farmModel)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: 6.responsive(context),
            horizontal: marginH.responsive(context)),
        padding: EdgeInsets.symmetric(
            horizontal: 10.responsive(context),
            vertical: 10.responsive(context)),
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
        child: Column(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: imageError,
              builder: (state, value, child) {
                return imageError.value == false &&
                        farmModel.farmImages!.isNotEmpty
                    ? Container(
                        height: 130.responsive(context),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage((BASE_URL +
                                    (farmModel.farmImages!.isNotEmpty
                                        ? farmModel.farmImages!.values.first
                                            .toString()
                                        : ""))
                                .replaceAll("\\", '/')),
                            onError: (e, p) {
                              imageError.value = true;
                            },
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            isAntiAlias: true,
                          ),
                          borderRadius:
                              BorderRadius.circular(10.responsive(context)),
                        ),
                      )
                    : Container();
              },
            ),
            SizedBox(height: 5.responsive(context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  title: farmModel.name.notNull(),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: ColorManager.yellow,
                    borderRadius: BorderRadius.circular(5.responsive(context)),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.responsive(context),
                      vertical: 4.responsive(context)),
                  child: Row(
                    children: [
                      CustomIcon(
                        IconManager.store,
                        size: 18.responsive(context),
                      ),
                      SizedBox(width: 4.responsive(context)),
                      CustomText(
                        title: "${farmModel.farmMetaDataCount.notNull()} منتج",
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                )
              ],
            ),
            if (farmModel.addressDetails != null)
              SizedBox(height: 5.responsive(context)),
            if (farmModel.addressDetails != null)
              Row(
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
                      title: farmModel.addressDetails.notNull(),
                      fontSize: 11,
                      color: ColorManager.darkGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
