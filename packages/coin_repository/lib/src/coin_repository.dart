import 'dart:async';

import 'package:coin_api/coin_api.dart' hide Exchange;
import 'package:coin_repository/coin_repository.dart';

class CoinRepository{
  final CoinApiClient _coinApiClient;

  CoinRepository({
    CoinApiClient? coinApiClient,
  }) : _coinApiClient = coinApiClient ?? CoinApiClient();

  Future<ExchangeModel> getExchange(String base, String quote)async{
    final exchange = await _coinApiClient.exchangeRateSearch(base: base, quote: quote);
    return ExchangeModel(base: exchange.base, quote: exchange.quote, rate: exchange.rate);
  }
}