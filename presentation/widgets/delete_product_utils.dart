import 'package:napta/core/resources/color_manager.dart';
import 'package:napta/core/resources/image_manager.dart';
import 'package:napta/core/widgets/shared/custom_button.dart';
import 'package:napta/core/functions/responsive.dart';
import 'package:napta/core/widgets/shared/custom_text.dart';
import 'package:flutter/material.dart';

class DeleteProductBottomSheet extends StatelessWidget {
  var yes, no;
  String title;
  bool hasIcon;
  DeleteProductBottomSheet(
      {Key? key,
      this.yes,
      this.no,
      this.title = "هل تريد حذف المنتج ؟",
      this.hasIcon = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25.responsive(context)),
            topLeft: Radius.circular(25.responsive(context)),
          ),
          color: ColorManager.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(),
          Column(
            children: [
              if (hasIcon) Image.asset(IconManager.deleteIcon),
              if (hasIcon)
                SizedBox(
                  height: 10.responsive(context),
                ),
              CustomText(
                title: title,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          Column(
            children: [
              CustomButton(
                title: "نعم",
                onTap: yes,
              ),
              SizedBox(
                height: 10.responsive(context),
              ),
              CustomButton(
                title: "لا",
                onTap: no ??
                    () {
                      Navigator.pop(context);
                    },
                buttonColor: ColorManager.white,
                textColor: ColorManager.black,
                borderColor: ColorManager.black,
              ),
            ],
          )
        ],
      ),
    );
  }
}
