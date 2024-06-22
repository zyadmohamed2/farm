// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable
import 'package:napta/modules/farm/presentation/bloc/production_date/production_date_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/production_date/production_event.dart';
import 'package:napta/modules/lookups/data/models/category_model.dart';
import 'package:napta/core/widgets/shared/custom_text.dart';
import 'package:napta/core/resources/color_manager.dart';
import 'package:napta/core/functions/responsive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class CultivationMethodWidget extends StatelessWidget {
  CategoryModel model;
  bool isSelected;
  int cultivationType;
  CultivationMethodWidget(
      {super.key,
      required this.model,
      required this.isSelected,
      required this.cultivationType});

  @override
  Widget build(BuildContext context) {
    double width = cultivationType != 1
        ? (MediaQuery.sizeOf(context).width - 50.responsive(context)) / 2
        : (MediaQuery.sizeOf(context).width - 50.responsive(context)) / 3;
    return InkWell(
      onTap: () {
        BlocProvider.of<ProductionDateBloc>(context)
            .add(UpdateProductionDateEvent(selected: model));
      },
      child: Container(
        width: width,
        margin: EdgeInsets.all(3.responsive(context)),
        padding: EdgeInsets.all(5.responsive(context)),
        decoration: BoxDecoration(
          color: isSelected ? ColorManager.primary : ColorManager.white,
          borderRadius: BorderRadius.circular(10.responsive(context)),
          border: Border.all(color: ColorManager.lightGrey),
          boxShadow: [
            BoxShadow(
              color: ColorManager.lightGrey.withOpacity(0.3),
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
          color: isSelected ? ColorManager.white : ColorManager.black,
        ),
      ),
    );
  }
}
