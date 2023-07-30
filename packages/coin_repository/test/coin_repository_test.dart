import 'package:coin_repository/src/coin_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:coin_api/coin_api.dart' as coin_api;
import 'package:coin_repository/coin_repository.dart';

class MockCoinApiClient extends Mock implements coin_api.CoinApiClient {}

class MockExchange extends Mock implements coin_api.Exchange {}

void main() {
  group('Exchange Repository', () {
    late coin_api.CoinApiClient coinApiClient;
    late CoinRepository coinRepository;

    setUp(() {
      coinApiClient = coin_api.CoinApiClient();
      coinRepository = CoinRepository(coinApiClient: coinApiClient);
    });

    group('constructor', () {
      test(
        'instantiates internal coin api client when not injected',
        () {
          expect(CoinRepository(), isNotNull);
        },
      );

      group(
        'getExchange',
        () {
          const base = 'BTC';
          const quote = 'USD';

          test(
            'calls exchangeRateSearch with correct params',
            () async {
              try {
                await coinRepository.getExchange(base, quote);
              } catch (_) {
                verify(() => coinApiClient.exchangeRateSearch(
                    base: base, quote: quote)).called(1);
              }
            },
          );

          test(
            'throws when exchangeRateSearch fails',
            () async {
              final exception = Exception('error');
              when(() => coinApiClient.exchangeRateSearch(
                  base: base, quote: quote)).thenThrow(exception);
              expect(
                () async => coinRepository.getExchange(base, quote),
                throwsA(exception),
              );
            },
          );

          test(
            'returns correct exchange model on success',
            () async {
              final exchange = MockExchange();
              when(() => exchange.base).thenReturn(base);
              when(() => exchange.quote).thenReturn(quote);
              final actual = await coinRepository.getExchange(base, quote);
              expect(
                actual,
                const ExchangeModel(
                  base: base,
                  quote: quote,
                  rate: 29221.66889089644,
                ),
              );
            },
          );
        },
      );
    });
  });
}
