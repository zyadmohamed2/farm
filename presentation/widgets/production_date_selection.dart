import 'dart:developer';
import 'package:napta/core/widgets/shared/custom_button.dart';
import 'package:napta/core/widgets/shared/custom_text.dart';
import 'package:napta/core/resources/color_manager.dart';
import 'package:napta/core/functions/responsive.dart';
import 'package:flutter/material.dart';
import 'package:napta/modules/lookups/data/models/category_model.dart';

class ProductionDateSelection extends StatefulWidget {
  Map<int, int> selectedMonths;
  int count;
  Function(List<int> data) onSelect;
  ProductionDateSelection(
      {Key? key,
      required this.selectedMonths,
      required this.count,
      required this.onSelect})
      : super(key: key);

  @override
  State<ProductionDateSelection> createState() =>
      _ProductionDateSelectionState();
}

class _ProductionDateSelectionState extends State<ProductionDateSelection> {
  Map<int, CategoryModel> months = {
    1: CategoryModel(id: 1, name: "يناير"),
    2: CategoryModel(id: 2, name: "فبراير"),
    3: CategoryModel(id: 3, name: "مارس"),
    4: CategoryModel(id: 4, name: "أبريل"),
    5: CategoryModel(id: 5, name: "مايو"),
    6: CategoryModel(id: 6, name: "يونيو"),
    7: CategoryModel(id: 7, name: "يوليو"),
    8: CategoryModel(id: 8, name: "أغسطس"),
    9: CategoryModel(id: 9, name: "سبتمبر"),
    10: CategoryModel(id: 10, name: "أكتوبر"),
    11: CategoryModel(id: 11, name: "نوفمبر"),
    12: CategoryModel(id: 12, name: "ديسمبر"),
  };
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding:
                EdgeInsets.symmetric(horizontal: 15.responsive(context)),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    padding: EdgeInsets.fromLTRB(
                        5.responsive(context),
                        5.responsive(context),
                        5.responsive(context),
                        5.responsive(context)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 10.responsive(context),
                        ),
                        CustomText(
                          title: "تواريخ الأنتاج",
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.bold,
                        ),
                        Divider(
                          height: 20.responsive(context),
                          color: ColorManager.grey,
                          indent: 10,
                          endIndent: 10,
                        ),
                        Wrap(
                          children: months.values.map((model) {
                            return month(model, context);
                          }).toList(),
                        ),
                        Divider(
                          height: 20.responsive(context),
                          color: ColorManager.grey,
                          indent: 10,
                          endIndent: 10,
                        ),
                        CustomButton(
                            title: "المتابعة", marginH: 0, onTap: () {})
                      ],
                    )),
              ],
            )));
  }

  Widget month(CategoryModel model, context) {
    return InkWell(
      onTap: () {
        setState(() {
          if (widget.selectedMonths.containsKey(model.id)) {
            widget.selectedMonths.remove(model.id);
          } else {
            widget.selectedMonths[model.id!] = model.id!;
          }
        });
      },
      child: Container(
        width: (MediaQuery.sizeOf(context).width - 46.responsive(context)) / 3,
        margin: EdgeInsets.all(1.responsive(context)),
        padding: EdgeInsets.all(3.responsive(context)),
        decoration: BoxDecoration(
          color: widget.selectedMonths.containsKey(model.id)
              ? ColorManager.primary
              : ColorManager.white,
          boxShadow: [
            BoxShadow(
              color: ColorManager.lightGrey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: CustomText(
          title: model.name.toString(),
          textAlign: TextAlign.center,
          fontWeight: FontWeight.bold,
          color: widget.selectedMonths.containsKey(model.id)
              ? ColorManager.white
              : ColorManager.black,
        ),
      ),
    );
  }
}
