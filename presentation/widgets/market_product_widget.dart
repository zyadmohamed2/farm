import 'dart:developer';

import 'package:napta/modules/image/image_bloc/image_bloc.dart';
import 'package:napta/modules/image/image_bloc/image_event.dart';
import 'package:napta/modules/lookups/presentation/bloc/market_product_types/market_product_types_event.dart';
import 'package:napta/modules/lookups/presentation/bloc/market_product_types/market_product_types_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/market_products_bloc/delete_market_product_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/market_products_bloc/market_product_events.dart';
import 'package:napta/modules/farm/presentation/widgets/delete_product_utils.dart';
import 'package:napta/modules/farm/presentation/view/edit_market_product.dart';
import 'package:napta/modules/farm/data/models/product.dart';
import 'package:napta/core/resources/color_manager.dart';
import 'package:napta/core/resources/image_manager.dart';
import 'package:napta/core/widgets/shared/custom_icon.dart';
import 'package:napta/core/widgets/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:napta/core/data_source/remote_data.dart';
import 'package:napta/core/functions/custom_navigation.dart';
import 'package:napta/core/functions/extensions.dart';
import 'package:napta/core/functions/responsive.dart';
import 'package:napta/core/enums/e_order_enums.dart';
import 'package:napta/modules/orders/presentation/widgets/order_status.dart';

class MarketProductWidget extends StatelessWidget {
  double width;
  double marginH;
  bool hasEdit;
  MarketProductModel model;
  MarketProductWidget(
      {Key? key,
      this.width = 1,
      this.marginH = 15,
      this.hasEdit = true,
      required this.model})
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
          horizontal: 5.responsive(context), vertical: 5.responsive(context)),
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
          model.farmMarketImages!.isNotEmpty
              ? Container(
                  width: MediaQuery.of(context).size.width * 0.27,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        getImageURL(
                            model.farmMarketImages?.values.first.toString()),
                      ),
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      isAntiAlias: true,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorManager.lightGrey.withOpacity(0.50),
                        ColorManager.lightGrey.withOpacity(0.75),
                      ],
                      stops: const [
                        0.2885,
                        1.5794,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10.responsive(context)),
                  ),
                )
              : Container(),
          SizedBox(
            width: 10.responsive(context),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: "نوع القسم : ${model.categoryName.notNull()}",
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: ColorManager.primary,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      title: "كود : ${model.codeName.notNull()}",
                      fontWeight: FontWeight.w700,
                      fontSize: 9,
                    ),
                    OrderStatusWidget(
                      status: EOrderStatus.getByValue(model.status.toString()),
                      width: false,
                    )
                  ],
                ),
              ],
            ),
          ),
          if (hasEdit == true)
            VerticalDivider(
              thickness: 1.responsive(context),
            ),
          if (hasEdit == true)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    BlocProvider.of<MarketProductTypesBloc>(context).add(
                        GetAllTypesForMarketProductTypesEvent(
                            farm: model.farmId.notNull(),
                            metadata: model.farmMetaDataId.notNull()));
                    BlocProvider.of<PickImageBloc>(context)
                        .add(SetImagesEvent(images: model.imagesForms));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                EditProductMarket(model: model.clone())));
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
                          BlocProvider.of<DeactivateMarketProductBloc>(context)
                              .add(DeactivateMarketProductEvent(
                                  id: model.id.notNull()));
                          CustomNavigation.pop(context);
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
          if (hasEdit == true)
            SizedBox(
              width: 4.responsive(context),
            )
        ],
      ),
    );
  }
}
