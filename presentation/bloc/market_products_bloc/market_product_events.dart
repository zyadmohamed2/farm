import 'package:napta/modules/farm/data/models/product.dart';

abstract class MarketProductsEvent {}

class CreateMarketProductEvent extends MarketProductsEvent {
  MarketProductModel model;
  CreateMarketProductEvent({required this.model});
}

class UpdateMarketProductEvent extends MarketProductsEvent {
  MarketProductModel model;
  UpdateMarketProductEvent({required this.model});
}

class DeactivateMarketProductEvent extends MarketProductsEvent {
  int id;
  DeactivateMarketProductEvent({required this.id});
}

class GetMarketProductsByUserIdEvent extends MarketProductsEvent {
  String userId;
  GetMarketProductsByUserIdEvent({required this.userId});
}

class GetUserMarketProductsEvent extends MarketProductsEvent {
  String? userId;
  GetUserMarketProductsEvent({this.userId});
}

class GetMoreUserMarketProductsEvent extends MarketProductsEvent {
  String? userId;
  GetMoreUserMarketProductsEvent({this.userId});
}

class GetAllMarketProductsEvent extends MarketProductsEvent {}

class GetMoreAllMarketProductsEvent extends MarketProductsEvent {}

class SearchForMarketProductsEvent extends MarketProductsEvent {
  int searchKey;
  SearchForMarketProductsEvent({required this.searchKey});
}

class SearchForMoreMarketProductsEvent extends MarketProductsEvent {
  int searchKey;
  SearchForMoreMarketProductsEvent({required this.searchKey});
}

class FilterMarketProductsEvent extends MarketProductsEvent {
  int? category, subCategory, product, code;
  FilterMarketProductsEvent(
      {this.category, this.subCategory, this.product, this.code});
}

class FilterMoreMarketProductsEvent extends MarketProductsEvent {
  int? category, subCategory, product, code;
  FilterMoreMarketProductsEvent(
      {this.category, this.subCategory, this.product, this.code});
}
