import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:napta/core/functions/extensions.dart';
import 'package:napta/core/utils/custom_alert_controller.dart';
import 'package:napta/core/widgets/no_data_widget.dart';
import 'package:napta/core/widgets/shared/custom_scaffold.dart';
import 'package:napta/core/widgets/shared/loading_widget.dart';
import 'package:napta/modules/farm/data/models/farm.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_bloc/farm_event.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_bloc/get_user_farms_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/delete_farm_meta_data_bloc.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/farm_meta_data_status.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/farm_metadata_events.dart';
import 'package:napta/modules/farm/presentation/bloc/farm_meta_data/get_farm_metadata_bloc.dart';
import 'package:napta/modules/farm/presentation/widgets/meta_data_widget.dart';

class FarmMetaData extends StatefulWidget {
  FarmModel farmModel;

  FarmMetaData({Key? key, required this.farmModel}) : super(key: key);

  @override
  State<FarmMetaData> createState() => _FarmMetaDataState();
}

class _FarmMetaDataState extends State<FarmMetaData> {
  var inAsyncCall = ValueNotifier<bool>(false);

  late ScrollController scrollController;

  late GetFarmMetaDataBloc getUserServicesBloc;

  @override
  void initState() {
    getUserServicesBloc = context.read<GetFarmMetaDataBloc>();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    super.initState();
  }

  _onScroll() {
    if (scrollController.hasClients) {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        getUserServicesBloc
            .add(GetMoreFarmMetaDatasEvent(farmId: widget.farmModel.id!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeactivateFarmMetaDataBloc, FarmMetaDataStatus>(
      listener: (context, state) {
        if (state is LoadingFarmMetaDataStatus) {
          inAsyncCall.value = true;
        } else if (state is FarmMetaDataDeletedSuccessStatus) {
          inAsyncCall.value = false;
          BlocProvider.of<GetFarmMetaDataBloc>(context)
              .add(GetFarmMetaDatasEvent(farmId: state.farmId));
          BlocProvider.of<GetUserFarmsBloc>(context).add(GetUserFarmsEvent());
          CustomAlertController.show(context, title: state.message);
        } else if (state is FarmMetaDataDeletedFailedStatus) {
          inAsyncCall.value = false;
          CustomAlertController.show(context,
              title: state.failure.message, isError: true);
        }
      },
      child: ValueListenableBuilder(
        valueListenable: inAsyncCall,
        builder: (context, value, child) {
          return CustomScaffold(
            title: "منتجات ${widget.farmModel.name.notNull()}",
            body: ModalProgressHUD(
              inAsyncCall: inAsyncCall.value,
              progressIndicator: const LoadingWidget(),
              child: BlocBuilder<GetFarmMetaDataBloc, FarmMetaDataStatus>(
                builder: (context, status) {
                  if (status is GetUserFarmMetaDatasSuccessStatus) {
                    return SingleChildScrollView(
                      child: Wrap(
                        children: status.data.map((model) {
                          return MetaDataWidget(
                            model: model,
                          );
                        }).toList(),
                      ),
                    );
                  } else if (status is LoadingFarmMetaDataStatus) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [LoadingWidget()],
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [NoDataWidget()],
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
