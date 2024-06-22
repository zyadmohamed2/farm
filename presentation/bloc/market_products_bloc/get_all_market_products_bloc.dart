import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:napta/modules/farm/data/models/product.dart';
import 'package:napta/modules/farm/data/repository/market_products_repository.dart';

import 'market_product_events.dart';
import 'market_products_status.dart';

class GetAllMarketProductsBloc
    extends Bloc<MarketProductsEvent, MarketProductsStatus> {
  MarketProductsRepositoryImp repository;
  List<MarketProductModel> data = [];
  int pageNumber = 1;
  GetAllMarketProductsBloc({required this.repository})
      : super(InitMarketProductsStatus()) {
    on<GetAllMarketProductsEvent>((event, emit) async {
      emit(LoadingMarketProductsStatus());
      pageNumber = 1;
      var response = await repository.getAll(pageNumber: pageNumber);
      response.fold((failure) {
        emit(GetMarketProductsFailedStatus(failure: failure));
      }, (data) {
        pageNumber++;
        this.data = [];
        this.data = data;
        emit(GetMarketProductsSuccessStatus(data: data));
      });
    });

    on<GetMoreAllMarketProductsEvent>((event, emit) async {
      var response = await repository.getAll(pageNumber: pageNumber);
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
