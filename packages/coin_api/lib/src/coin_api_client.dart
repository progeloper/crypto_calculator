import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:coin_api/coin_api.dart';

class CurrencyNotFoundException implements Exception{}

class CoinApiClient{
  CoinApiClient({
    http.Client? client,
  }) : _client = client ?? http.Client();

  final http.Client _client;
  static const baseUrl = 'http://api-ncsa.coinapi.net/v1/exchangerate/';
  static const key = 'D7601F5A-861C-41FB-A685-80EFB1779DFD';

  Future<Exchange> exchangeRateSearch({required String base, required String quote})async{
    String request = '${baseUrl+base}/$quote?apikey=$key';
    final rateRequest = Uri.parse(request);
    final http.Response rateResponse = await _client.get(rateRequest);
    if(rateResponse.statusCode != 200){
      throw CurrencyNotFoundException();
    } else{
      final rateJson = jsonDecode(rateResponse.body) as Map;
      if(!rateJson.containsKey('asset_id_base') || !rateJson.containsKey('asset_id_quote')) {
        throw CurrencyNotFoundException();
      }
      return Exchange.fromJson(rateJson as Map<String, dynamic>);
    }
  }
}