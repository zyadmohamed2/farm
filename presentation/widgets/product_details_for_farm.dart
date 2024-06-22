import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:napta/core/functions/responsive.dart';
import 'package:napta/core/widgets/shared/custom_button.dart';
import 'package:napta/core/resources/color_manager.dart';
import 'package:napta/modules/farm/data/models/farm.dart';
import 'package:napta/modules/farm/data/models/farm_meta_data.dart';
import 'meta_data_widget.dart';

class ProductDetailsForFarmWidget extends StatelessWidget {
  final FarmModel farmModel;
  const ProductDetailsForFarmWidget({Key? key, required this.farmModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10.responsive(context)),
          Wrap(
            children: [1, 2, 3].map((e) {
              return MetaDataWidget(model: FarmMetaDataModel(cycleDates: []));
            }).toList(),
          ),
          SizedBox(height: 20.responsive(context)),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.responsive(context)),
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(10.responsive(context)),
              child: CustomButton(
                title: "إضافة المنتج",
                marginH: 0,
                onTap: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (_) =>  AddProductToFarm(farmId: ,)));
                },
                buttonColor: ColorManager.white,
                textColor: ColorManager.black,
                borderColor: ColorManager.white,
              ),
            ),
          ),
          SizedBox(height: 100.responsive(context)),
        ],
      ),
    );
  }
}
