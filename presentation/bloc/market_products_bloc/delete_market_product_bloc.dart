import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:napta/modules/farm/data/repository/market_products_repository.dart';
import 'market_product_events.dart';
import 'market_products_status.dart';

class DeactivateMarketProductBloc
    extends Bloc<MarketProductsEvent, MarketProductsStatus> {
  MarketProductsRepositoryImp repository;
  DeactivateMarketProductBloc({required this.repository})
      : super(InitMarketProductsStatus()) {
    on<DeactivateMarketProductEvent>((event, emit) async {
      emit(LoadingMarketProductsStatus());
      var response = await repository.delete(id: event.id);
      response.fold((failure) {
        emit(MarketProductDeactivatedFailedStatus(failure: failure));
      }, (message) {
        emit(MarketProductDeactivatedSuccessStatus(message: message));
      });
    });
  }
}
