import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:napta/core/functions/responsive.dart';
import 'package:napta/core/resources/color_manager.dart';
import 'package:napta/core/widgets/no_data_widget.dart';
import 'package:napta/core/widgets/product_widget.dart';
import 'package:napta/core/widgets/shared/custom_scaffold.dart';
import 'package:napta/core/widgets/shared/loading_widget.dart';
import 'package:napta/modules/farm/presentation/bloc/market_products_bloc/get_all_market_products_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/market_products_bloc/market_product_events.dart';
import 'package:napta/modules/farm/presentation/bloc/market_products_bloc/market_products_status.dart';

class DisplayProducts extends StatefulWidget {
  const DisplayProducts({super.key});

  @override
  State<DisplayProducts> createState() => _DisplayProductsState();
}

class _DisplayProductsState extends State<DisplayProducts> {
  var inAsyncCall = ValueNotifier<bool>(false);

  late ScrollController scrollController;

  late GetAllMarketProductsBloc getUserConsultantsBloc;

  @override
  void initState() {
    getUserConsultantsBloc = context.read<GetAllMarketProductsBloc>();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    super.initState();
  }

  _onScroll() {
    if (scrollController.hasClients) {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        getUserConsultantsBloc.add(GetMoreAllMarketProductsEvent());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "المنتجات",
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<GetAllMarketProductsBloc>(context)
              .add(GetAllMarketProductsEvent());
        },
        color: ColorManager.primary,
        child: BlocBuilder<GetAllMarketProductsBloc, MarketProductsStatus>(
          builder: (context, state) {
            if (state is GetMarketProductsSuccessStatus) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Wrap(
                  children: state.data.map((model) {
                    return ProductWidget(
                      width: 0.5,
                      model: model,
                    );
                  }).toList(),
                ),
              );
            } else if (state is LoadingMarketProductsStatus) {
              return Center(
                child: LoadingWidget(),
              );
            } else {
              return Center(
                child: NoDataWidget(),
              );
            }
          },
        ),
      ),
    );
  }
}
