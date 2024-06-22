// ignore_for_file: must_be_immutable
import 'package:napta/modules/farm/presentation/bloc/market_products_bloc/market_product_events.dart';
import 'package:napta/modules/farm/presentation/bloc/market_products_bloc/market_products_status.dart';
import 'package:napta/modules/farm/presentation/bloc/market_products_bloc/get_farmer_marker.dart';
import 'package:napta/modules/authentication/data/models/register_response.dart';
import 'package:napta/modules/farm/presentation/widgets/meta_data_loading.dart';
import 'package:napta/core/widgets/shared/custom_scaffold.dart';
import 'package:napta/core/widgets/main_profile_header.dart';
import 'package:napta/core/widgets/no_data_widget.dart';
import 'package:napta/core/widgets/product_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class FarmerProfileScreen extends StatefulWidget {
  User data;
  FarmerProfileScreen({super.key, required this.data});

  @override
  State<FarmerProfileScreen> createState() => _FarmerProfileScreenState();
}

class _FarmerProfileScreenState extends State<FarmerProfileScreen> {
  late ScrollController scrollController;

  late GetMarketProductsByUserIdBloc getMarketProductsByUserIdBloc;

  @override
  void initState() {
    getMarketProductsByUserIdBloc =
        context.read<GetMarketProductsByUserIdBloc>();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    super.initState();
  }

  _onScroll() {
    if (scrollController.hasClients) {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        getMarketProductsByUserIdBloc
            .add(GetMoreUserMarketProductsEvent(userId: widget.data.id!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "",
      enableHeader: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MainProfileHeader(data: widget.data),
          Expanded(
            child: BlocBuilder<GetMarketProductsByUserIdBloc,
                MarketProductsStatus>(
              builder: (context, state) {
                if (state is GetMarketProductsSuccessStatus) {
                  if (state.data.isNotEmpty) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Wrap(
                        spacing: 0,
                        children: state.data.map((model) {
                          return ProductWidget(
                            model: model,
                            width: .5,
                          );
                        }).toList(),
                      ),
                    );
                  } else {
                    return Center(child: NoDataWidget());
                  }
                } else if (state is LoadingMarketProductsStatus) {
                  return Wrap(
                      spacing: 0,
                      children: [1, 2, 3, 4].map((model) {
                        return UserProductLoading(marginH: 15, width: 1);
                      }).toList());
                } else {
                  return Center(child: NoDataWidget());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
