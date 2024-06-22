import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:napta/modules/farm/data/repository/market_products_repository.dart';
import 'package:napta/modules/farm/presentation/bloc/market_products_bloc/market_product_events.dart';
import 'package:napta/modules/farm/presentation/bloc/market_products_bloc/market_products_status.dart';

class UpdateMarketProductBloc
    extends Bloc<MarketProductsEvent, MarketProductsStatus> {
  MarketProductsRepositoryImp repository;
  UpdateMarketProductBloc({required this.repository})
      : super(InitMarketProductsStatus()) {
    on<UpdateMarketProductEvent>((event, emit) async {
      emit(LoadingMarketProductsStatus());
      var response = await repository.update(model: event.model);
      response.fold((failure) {
        emit(MarketProductUpdatedFailedStatus(failure: failure));
      }, (message) {
        emit(MarketProductUpdatedSuccessStatus(message: message));
      });
    });
  }
}
