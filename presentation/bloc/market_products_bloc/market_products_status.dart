import 'package:napta/modules/farm/data/models/product.dart';
import 'package:napta/core/error_handler/failure.dart';

abstract class MarketProductsStatus {}

class InitMarketProductsStatus extends MarketProductsStatus {}

class LoadingMarketProductsStatus extends MarketProductsStatus {}

class MarketProductCreatedSuccessStatus extends MarketProductsStatus {
  String message;
  MarketProductCreatedSuccessStatus({required this.message});
}

class MarketProductCreatedFailedStatus extends MarketProductsStatus {
  Failure failure;
  MarketProductCreatedFailedStatus({required this.failure});
}

class MarketProductDeactivatedSuccessStatus extends MarketProductsStatus {
  String message;
  MarketProductDeactivatedSuccessStatus({required this.message});
}

class MarketProductDeactivatedFailedStatus extends MarketProductsStatus {
  Failure failure;
  MarketProductDeactivatedFailedStatus({required this.failure});
}

class MarketProductUpdatedSuccessStatus extends MarketProductsStatus {
  String message;
  MarketProductUpdatedSuccessStatus({required this.message});
}

class MarketProductUpdatedFailedStatus extends MarketProductsStatus {
  Failure failure;
  MarketProductUpdatedFailedStatus({required this.failure});
}

class GetMarketProductsSuccessStatus extends MarketProductsStatus {
  List<MarketProductModel> data;
  GetMarketProductsSuccessStatus({required this.data});
}

class GetMarketProductsFailedStatus extends MarketProductsStatus {
  Failure failure;
  GetMarketProductsFailedStatus({required this.failure});
}

class FiltersMarketProductsSuccessStatus extends MarketProductsStatus {
  List<MarketProductModel> data;
  FiltersMarketProductsSuccessStatus({required this.data});
}

class FiltersMarketProductsFailedStatus extends MarketProductsStatus {
  Failure failure;
  FiltersMarketProductsFailedStatus({required this.failure});
}

class SearchForMarketProductsSuccessStatus extends MarketProductsStatus {
  List<MarketProductModel> data;
  SearchForMarketProductsSuccessStatus({required this.data});
}

class SearchForMarketProductsFailedStatus extends MarketProductsStatus {
  Failure failure;
  SearchForMarketProductsFailedStatus({required this.failure});
}
