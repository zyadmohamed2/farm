import 'package:napta/modules/farm/data/repository/market_products_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'market_product_events.dart';
import 'market_products_status.dart';

class CreateMarketProductBloc
    extends Bloc<MarketProductsEvent, MarketProductsStatus> {
  MarketProductsRepositoryImp repository;
  CreateMarketProductBloc({required this.repository})
      : super(InitMarketProductsStatus()) {
    on<CreateMarketProductEvent>((event, emit) async {
      emit(LoadingMarketProductsStatus());
      var response = await repository.create(model: event.model);
      response.fold((failure) {
        emit(MarketProductCreatedFailedStatus(failure: failure));
      }, (message) {
        emit(MarketProductCreatedSuccessStatus(message: message));
      });
    });
  }
}
