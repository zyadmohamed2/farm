import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:napta/modules/farm/data/models/product.dart';
import 'package:napta/modules/farm/data/repository/market_products_repository.dart';

import 'market_product_events.dart';
import 'market_products_status.dart';

class FilterMarketProductsBloc
    extends Bloc<MarketProductsEvent, MarketProductsStatus> {
  MarketProductsRepositoryImp repository;
  int? category, subCategory, product, code;
  List<MarketProductModel> data = [];
  int pageNumber = 1;
  FilterMarketProductsBloc({required this.repository})
      : super(InitMarketProductsStatus()) {
    on<FilterMarketProductsEvent>((event, emit) async {
      emit(LoadingMarketProductsStatus());
      category = event.category;
      subCategory = event.subCategory;
      product = event.product;
      code = event.code;

      pageNumber = 1;
      var response = await repository.filter(
        pageNumber: pageNumber,
        category: category,
        code: code,
        subCategory: subCategory,
        product: product,
      );
      response.fold((failure) {
        emit(GetMarketProductsFailedStatus(failure: failure));
      }, (data) {
        pageNumber++;
        this.data = [];
        this.data = data;
        emit(GetMarketProductsSuccessStatus(data: data));
      });
    });

    on<FilterMoreMarketProductsEvent>((event, emit) async {
      var response = await repository.filter(
        pageNumber: pageNumber,
        category: category,
        code: code,
        subCategory: subCategory,
        product: product,
      );
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
