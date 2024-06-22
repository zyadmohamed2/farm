import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:napta/core/functions/responsive.dart';
import 'package:napta/core/utils/custom_alert_controller.dart';
import 'package:napta/core/widgets/shared/custom_scaffold.dart';
import 'package:napta/modules/farm/presentation/bloc/market_products_bloc/delete_market_product_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/market_products_bloc/get_user_market_product_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/market_products_bloc/market_product_events.dart';
import 'package:napta/modules/farm/presentation/bloc/market_products_bloc/market_products_status.dart';
import 'package:napta/modules/farm/presentation/view/farms_tab.dart';
import 'package:napta/modules/farm/presentation/view/market_products_management.dart';
import 'package:napta/core/resources/color_manager.dart';
import 'package:napta/core/resources/font_manager.dart';
import 'package:napta/modules/home/presentation/widgets/home_header.dart';

class FarmManagement extends StatelessWidget {
  var inAsyncCall = ValueNotifier<bool>(false);
  FarmManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeactivateMarketProductBloc, MarketProductsStatus>(
      listener: (context, state) {
        if (state is LoadingMarketProductsStatus) {
          inAsyncCall.value = true;
        } else if (state is MarketProductDeactivatedSuccessStatus) {
          inAsyncCall.value = false;
          CustomAlertController.show(context, title: state.message);
          BlocProvider.of<GetUserMarketProductsBloc>(context)
              .add(GetUserMarketProductsEvent());
        } else if (state is MarketProductDeactivatedFailedStatus) {
          inAsyncCall.value = false;
          CustomAlertController.show(context,
              title: state.failure.message, isError: true);
        }
      },
      child: DefaultTabController(
        length: 2,
        child: CustomScaffold(
          title: "أدارة مزرعتي",
          enableHeader: false,
          body: ValueListenableBuilder(
              valueListenable: inAsyncCall,
              builder: (context, value, child) {
                return ModalProgressHUD(
                  inAsyncCall: inAsyncCall.value,
                  child: Column(
                    children: <Widget>[
                      const HomeHeader(),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.0),
                          border: const Border(
                              bottom: BorderSide(color: Colors.grey, width: 2)),
                        ),
                        child: TabBar(
                            labelColor: ColorManager.primary,
                            labelStyle: TextStyle(
                                fontFamily: FontManager.cairo,
                                fontSize: 9.responsive(context),
                                color: ColorManager.primary,
                                fontWeight: FontWeight.w700),
                            indicatorWeight: 2,
                            //isScrollable: true,
                            labelPadding: const EdgeInsets.all(0),
                            unselectedLabelColor: ColorManager.darkGrey,
                            unselectedLabelStyle: TextStyle(
                                fontFamily: FontManager.cairo,
                                fontSize: 9.responsive(context),
                                color: ColorManager.darkGrey,
                                fontWeight: FontWeight.w700,
                                inherit: true),
                            indicatorColor: ColorManager.primary,
                            tabs: [
                              getTabHeader(title: "المزارع"),
                              getTabHeader(title: "المنتجات")
                            ]),
                      ),
                      const Expanded(
                        child: TabBarView(
                          children: [
                            UserFarmsTab(),
                            MarketProductsManagement(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget getTabHeader({required String title}) {
    return Tab(
      text: title,
    );
  }
}
