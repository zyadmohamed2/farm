import 'package:flutter/material.dart';
import 'package:napta/core/functions/responsive.dart';
import 'package:napta/core/resources/color_manager.dart';
import 'package:shimmer/shimmer.dart';

class UserProductLoading extends StatelessWidget {
  double marginH;
  double width;
  bool hasImage;
  UserProductLoading(
      {super.key, this.marginH = 0, this.width = 1, this.hasImage = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        width: (MediaQuery.of(context).size.width * width) - 2 * marginH,
        height: MediaQuery.of(context).size.width * 0.3,
        margin: EdgeInsets.symmetric(
            vertical: 6.responsive(context), horizontal: marginH),
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
        child: Row(
          children: [
            if (hasImage == true)
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade200,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.24,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(4.responsive(context)),
                      color: ColorManager.grey),
                ),
              ),
            SizedBox(width: 2.responsive(context)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade200,
                        child: Container(
                          height: 20.responsive(context),
                          width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(4.responsive(context)),
                              color: ColorManager.grey),
                        ),
                      ),
                    ],
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade200,
                    child: Container(
                      height: 20.responsive(context),
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(4.responsive(context)),
                          color: ColorManager.grey),
                    ),
                  ),
                ],
              ),
            ),
            VerticalDivider(
              thickness: 1.responsive(context),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              ],
            ),
          ],
        ));
  }
}
