import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:crypto_calculator/exchange/models/exchange.dart';
import 'package:coin_repository/coin_repository.dart' as coin_repo;
import 'package:hydrated_bloc/hydrated_bloc.dart';


const exchangeBase = 'BTC';
const exchangeQuote = 'USD';

class MockCoinRepository extends Mock implements coin_repo.CoinRepository{}

class MockExchange extends Mock implements coin_repo.ExchangeModel{}

class MockStorage extends Mock implements Storage{}

late Storage hydratedStorage;

void initHydratedStorage(){
  TestWidgetsFlutterBinding.ensureInitialized();
  hydratedStorage = MockStorage();
  when(
      ()=> hydratedStorage.write(any(), any<dynamic>()),
  ).thenAnswer((_)async{});
  HydratedBloc.storage = hydratedStorage;
}

void main() {
  initHydratedStorage();


}
