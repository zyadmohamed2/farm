/*
import 'package:flutter/material.dart';
import 'package:napta/core/functions/responsive.dart';
import 'package:napta/core/widgets/product_screen.dart';
import 'package:napta/core/widgets/shared/custom_scaffold.dart';
import 'package:napta/core/resources/color_manager.dart';
import 'package:napta/core/resources/image_manager.dart';
import 'package:napta/core/widgets/shared/custom_icon.dart';
import 'package:napta/core/widgets/shared/custom_text.dart';
import 'package:napta/modules/farm/data/models/farm_meta_data.dart';
import 'package:napta/modules/farm/data/models/product.dart';
import 'package:napta/modules/farm/presentation/widgets/market_product_widget.dart';
import 'package:napta/modules/farm/presentation/widgets/meta_data_widget.dart';
import 'package:napta/modules/profile/presentation/bloc/get_user_data_by_userId/userdata_event.dart';
import 'farmer_profile.dart';

class FarmProfileScreen extends StatelessWidget {
  const FarmProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "مزرعة الخس",
      top: 56,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150.responsive(context),
              decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage(
                      "assets/images/farm.png",
                    ),
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    isAntiAlias: true,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10.responsive(context)),
                    bottomLeft: Radius.circular(10.responsive(context)),
                  )
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
                          borderRadius: BorderRadius.circular(8.responsive(context)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromRGBO(12, 124, 84, 0.91).withOpacity(0.75),
                              Color.fromRGBO(227, 209, 16, 0.91).withOpacity(0.75),
                            ],
                            stops: [
                              0.2885,
                              1.5794,
                            ],
                          ),
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal: 8.responsive(context),
                            vertical: 8.responsive(context)
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.responsive(context),
                            vertical: 4.responsive(context)
                        ),
                        child: Row(
                          children: [
                            CustomIcon(
                              IconManager.store,
                              size: 18.responsive(context),
                              color: ColorManager.white,
                            ),
                            SizedBox(width: 5.responsive(context)),
                            CustomText(
                              title: "26 منتج",
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
            ),
            SizedBox(height: 5.responsive(context)),
            Wrap(
              children: [1,2,3,4,5,6,7,8].map((e) =>
                InkWell(
                  onTap: (){
                    //BlocProvider.of<GetUserDataByUserIDBloc>(context).add(GetUserDataByUserIDEvent(userId: "model.userId.toString()"));
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ProductScreen(
                        title: "",
                      model: MarketProductModel(),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) => FarmerProfileScreen()));
                      },
                    )));
                  },
                  child: MarketProductWidget(
                    hasEdit: false,
                    model: MarketProductModel(),
                  ),
                )
              ).toList(),
            ),
            SizedBox(height: 15.responsive(context)),
          ],
        ),
      ),
    );
  }
}
*/
