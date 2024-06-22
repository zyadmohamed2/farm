import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:napta/core/data_source/app_pref.dart';
import 'package:napta/core/functions/extensions.dart';
import 'package:napta/modules/farm/data/models/product.dart';
import 'package:napta/modules/farm/data/repository/market_products_repository.dart';
import 'market_product_events.dart';
import 'market_products_status.dart';

class GetUserMarketProductsBloc
    extends Bloc<MarketProductsEvent, MarketProductsStatus> {
  MarketProductsRepositoryImp repository;
  List<MarketProductModel> data = [];
  int pageNumber = 1;
  GetUserMarketProductsBloc({required this.repository})
      : super(InitMarketProductsStatus()) {
    on<GetUserMarketProductsEvent>((event, emit) async {
      emit(LoadingMarketProductsStatus());
      pageNumber = 1;
      var response = await repository.getByUserId(
          userId: CacheHelper.getUserData()!.user!.id.notNull(),
          pageNumber: pageNumber);
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
          userId: CacheHelper.getUserData()!.user!.id.notNull(),
          pageNumber: pageNumber);
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
