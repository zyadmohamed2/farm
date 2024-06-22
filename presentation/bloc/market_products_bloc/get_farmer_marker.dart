import 'package:napta/modules/farm/data/repository/market_products_repository.dart';
import 'package:napta/modules/farm/data/models/product.dart';
import 'market_products_status.dart';
import 'market_product_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetMarketProductsByUserIdBloc
    extends Bloc<MarketProductsEvent, MarketProductsStatus> {
  MarketProductsRepositoryImp repository;
  List<MarketProductModel> data = [];
  int pageNumber = 1;
  GetMarketProductsByUserIdBloc({required this.repository})
      : super(InitMarketProductsStatus()) {
    on<GetUserMarketProductsEvent>((event, emit) async {
      emit(LoadingMarketProductsStatus());
      pageNumber = 1;
      var response = await repository.getByUserId(
          userId: event.userId!, pageNumber: pageNumber);
      response.fold((failure) {
        emit(GetMarketProductsFailedStatus(failure: failure));
      }, (data) {
        pageNumber++;
        this.data = [];
        this.data = data;
        emit(GetMarketProductsSuccessStatus(data: data));
      });
    });

    on<GetMoreUserMarketProductsEvent>((event, emit) async {
      var response = await repository.getByUserId(
          userId: event.userId!, pageNumber: pageNumber);
      response.fold((failure) {
        emit(GetMarketProductsSuccessStatus(data: data));
      }, (data) {
        pageNumber++;
        this.data = List.from(this.data)..addAll(data);
        emit(GetMarketProductsSuccessStatus(data: this.data));
      });
    });
  }
}
