import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:napta/core/functions/responsive.dart';
import 'package:napta/modules/farm/presentation/view/add_market_product.dart';
import 'package:napta/modules/farm/presentation/view/add_meta_data.dart';
import 'package:napta/modules/farm/presentation/widgets/delete_product_utils.dart';
import 'package:napta/core/resources/color_manager.dart';
import 'package:napta/core/resources/image_manager.dart';
import 'package:napta/core/widgets/shared/custom_icon.dart';
import 'package:napta/core/widgets/shared/custom_text.dart';

class FarmMarketDetails extends StatelessWidget {
  double width;
  double marginH;
  bool hasEdit;
  FarmMarketDetails(
      {Key? key, this.width = 1, this.marginH = 15, this.hasEdit = true})
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
          Container(
            width: MediaQuery.of(context).size.width * 0.27,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage(
                  "assets/images/product.png",
                ),
                fit: BoxFit.contain,
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
          ),
          SizedBox(
            width: 10.responsive(context),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: "نوع القسم : ${"خس"}",
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: ColorManager.primary,
                ),
                CustomText(
                  title: "500 جنية / كجم",
                  fontWeight: FontWeight.w700,
                  fontSize: 9,
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AddProductToFarm(
                                  farmId: 0,
                                )));
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
                      builder: (context) => DeleteProductBottomSheet(),
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
