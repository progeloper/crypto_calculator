import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:coin_api/coin_api.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group(
    'Exchange',
    () {
      test('returns correct exchange rate object', () {
        expect(
          Exchange.fromJson(
            <String, dynamic>{
              "time": "2017-08-09T14:31:18.3150000Z",
              "asset_id_base": "BTC",
              "asset_id_quote": "USD",
              "rate": 3260.3514321215056208129867667
            },
          ),
          isA<Exchange>()
              .having((obj) => obj.base, 'BTC', 'BTC')
              .having((obj) => obj.quote, 'USD', 'USD')
              .having(
                  (obj) => obj.rate, 'rate', 3260.3514321215056208129867667),
        );
      });
    },
  );

  group('CoinApiClient', () {
    late http.Client client;
    late CoinApiClient coinApiClient;
    const baseUrl = 'http://api-ncsa.coinapi.net/v1/exchangerate/';
    const key = 'http://api-ncsa.coinapi.net/v1/exchangerate/';

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      client = MockHttpClient();
      coinApiClient = CoinApiClient(client: client);
    });

    group('constructor', () {
      test('does not require a httpClient', () {
        expect(CoinApiClient(), isNotNull);
      });
    });

    group('Exchange search', () {
      const base = 'BTC';
      const quote = 'USD';

      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => client.get(any())).thenAnswer((_) async => response);
        try {
          await coinApiClient.exchangeRateSearch(base: base, quote: quote);
        } catch (_) {}
        verify(
          () => client.get(
            Uri.parse('${baseUrl + base}/$quote?apikey=$key'),
          ),
        ).called(1);
      });

      test(
        'Non-200 rsponse',
        () {
          final response = MockResponse();
          when(() => response.statusCode).thenReturn(400);
          when(() => response.body).thenReturn('{}');
          when(() => client.get(any()))
              .thenAnswer((invocation) async => response);
        },
      );

      test(
        'returns exchange rate on valid response',
        () async {
          final response = MockResponse();
          when(() => response.statusCode).thenReturn(200);
          when(() => response.body).thenReturn(
            '''{
  "time": "2017-08-09T14:31:18.3150000Z",
  "asset_id_base": "BTC",
  "asset_id_quote": "USD",
  "rate": 3260.3514321215056208129867667
}''',
          );
          when(() => client.get(any()))
              .thenAnswer((invocation) async => response);
          final actual =
              await coinApiClient.exchangeRateSearch(base: base, quote: quote);
          expect(
            actual,
            isA<Exchange>()
                .having((obj) => obj.base, 'BTC', 'BTC')
                .having((obj) => obj.quote, 'USD', 'USD')
                .having(
                    (obj) => obj.rate, 'rate', 3260.3514321215056208129867667),
          );
        },
      );
    });
  });
}
