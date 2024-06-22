import 'package:flutter/material.dart';
import 'package:napta/core/functions/extensions.dart';
import 'package:napta/core/functions/responsive.dart';
import 'package:napta/core/resources/color_manager.dart';
import 'package:napta/core/resources/image_manager.dart';
import 'package:napta/core/widgets/shared/custom_icon.dart';
import 'package:napta/core/widgets/shared/custom_text.dart';
import 'package:napta/modules/farm/data/models/farm.dart';
import 'package:shimmer/shimmer.dart';

class FarmLoading extends StatelessWidget {
  double marginH;
  double width, imageH;
  FarmLoading({super.key, this.marginH = 0, this.width = 1, this.imageH = 130});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
            vertical: 6.responsive(context),
            horizontal: marginH.responsive(context)),
        padding: EdgeInsets.symmetric(
            horizontal: 10.responsive(context),
            vertical: 10.responsive(context)),
        width: MediaQuery.of(context).size.width * width,
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
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade200,
              child: Container(
                height: imageH.responsive(context),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.responsive(context)),
                    color: ColorManager.grey),
              ),
            ),
            SizedBox(height: 5.responsive(context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade200,
                    child: Container(
                      height: 20.responsive(context),
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(4.responsive(context)),
                          color: ColorManager.grey),
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade200,
                    child: Container(
                      height: 20.responsive(context),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(4.responsive(context)),
                          color: ColorManager.grey),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.responsive(context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade200,
                  child: Container(
                    height: 20.responsive(context),
                    width: 20.responsive(context),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(4.responsive(context)),
                        color: ColorManager.grey),
                  ),
                ),
                SizedBox(width: 5.responsive(context)),
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade200,
                    child: Container(
                      height: 20.responsive(context),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(4.responsive(context)),
                          color: ColorManager.grey),
                    ),
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
