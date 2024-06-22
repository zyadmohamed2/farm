import 'package:napta/modules/farm/presentation/bloc/market_products_bloc/get_user_market_product_bloc.dart';
import 'package:napta/modules/lookups/presentation/bloc/market_product_types/market_product_types_bloc.dart';
import 'package:napta/modules/lookups/presentation/bloc/market_product_types/market_product_types_event.dart';
import 'package:napta/modules/farm/presentation/bloc/market_products_bloc/market_products_status.dart';
import 'package:napta/modules/farm/presentation/bloc/market_products_bloc/market_product_events.dart';
import 'package:napta/modules/farm/presentation/widgets/market_product_widget.dart';
import 'package:napta/modules/farm/presentation/widgets/meta_data_loading.dart';
import 'package:napta/modules/image/image_bloc/image_event.dart';
import 'package:napta/modules/image/image_bloc/image_bloc.dart';
import 'package:napta/core/widgets/shared/custom_icon.dart';
import 'package:napta/core/widgets/shared/custom_text.dart';
import 'package:napta/core/resources/color_manager.dart';
import 'package:napta/core/resources/image_manager.dart';
import 'package:napta/core/widgets/no_data_widget.dart';
import 'package:napta/core/functions/responsive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'add_market_product.dart';

class MarketProductsManagement extends StatefulWidget {
  const MarketProductsManagement({super.key});

  @override
  State<MarketProductsManagement> createState() =>
      _MarketProductsManagementState();
}

class _MarketProductsManagementState extends State<MarketProductsManagement> {
  late ScrollController scrollController;

  late GetUserMarketProductsBloc getUserMarketProductsBloc;

  @override
  void initState() {
    getUserMarketProductsBloc = context.read<GetUserMarketProductsBloc>();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    super.initState();
  }

  _onScroll() {
    if (scrollController.hasClients) {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        getUserMarketProductsBloc.add(GetMoreUserMarketProductsEvent());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<GetUserMarketProductsBloc>(context)
            .add(GetUserMarketProductsEvent());
      },
      color: ColorManager.primary,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.responsive(context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.responsive(context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    title: "المنتجات الخاصة بى",
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<MarketProductTypesBloc>(context)
                          .add(GetFarmsForMarketProductTypesEvent());
                      BlocProvider.of<PickImageBloc>(context)
                          .add(InitImageEvent());
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AddProductToMarket()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomText(
                          title: "إضافة منتج",
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(width: 5.responsive(context)),
                        CustomIcon(
                          IconManager.addIcon,
                          color: ColorManager.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              CustomText(
                title: "يمكنك إضافة منتج او التعديل على منتج حالي",
                color: ColorManager.darkGrey,
                textAlign: TextAlign.start,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
              BlocBuilder<GetUserMarketProductsBloc, MarketProductsStatus>(
                builder: (context, state) {
                  if (state is GetMarketProductsSuccessStatus) {
                    if (state.data.isNotEmpty) {
                      return Wrap(
                        spacing: 0,
                        children: state.data.map((model) {
                          return MarketProductWidget(
                            model: model,
                            marginH: 0,
                          );
                        }).toList(),
                      );
                    } else {
                      return NoDataWidget();
                    }
                  } else if (state is LoadingMarketProductsStatus) {
                    return Wrap(
                      spacing: 0,
                      children: [1, 2, 3, 4].map((model) {
                        return UserProductLoading(
                          marginH: 0,
                          width: 1,
                          hasImage: true,
                        );
                      }).toList(),
                    );
                  } else {
                    return NoDataWidget();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
