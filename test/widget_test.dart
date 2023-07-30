import 'package:crypto_calculator/exchange/cubit/exchange_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:crypto_calculator/exchange/models/exchange.dart';
import 'package:coin_repository/coin_repository.dart' as coin_repo;
import 'package:hydrated_bloc/hydrated_bloc.dart';

const exchangeBase = 'BTC';
const exchangeQuote = 'USD';
const exchangeRate = 29221.66889089644;

class MockCoinRepository extends Mock implements coin_repo.CoinRepository {}

class MockExchange extends Mock implements coin_repo.ExchangeModel {}

class MockStorage extends Mock implements Storage {}

late Storage hydratedStorage;

void initHydratedStorage() {
  TestWidgetsFlutterBinding.ensureInitialized();
  hydratedStorage = MockStorage();
  when(
    () => hydratedStorage.write(any(), any<dynamic>()),
  ).thenAnswer((_) async {});
  HydratedBloc.storage = hydratedStorage;
}

void main() {
  initHydratedStorage();

  group(
    'ExchangeCubit',
    () {
      late coin_repo.CoinRepository coinRepo;
      late coin_repo.ExchangeModel exchangeModel;
      late ExchangeCubit exchangeCubit;

      setUp(
        () async {
          exchangeModel = MockExchange();
          coinRepo = MockCoinRepository();
          when(() => exchangeModel.base).thenReturn(exchangeBase);
          when(() => exchangeModel.quote).thenReturn(exchangeQuote);
          when(() => exchangeModel.rate).thenReturn(exchangeRate);
          when(() => coinRepo.getExchange(
                any(),
                any(),
              )).thenAnswer((_) async => exchangeModel);
          exchangeCubit = ExchangeCubit(coinRepo);
        },
      );

      test(
        'initial state is correct',
        () {
          final exchangeCubit = ExchangeCubit(coinRepo);
          expect(exchangeCubit.state, ExchangeState());
        },
      );

      group('toJson/fromJson', () {
        test('work properly', () {
          final exchangeCubit = ExchangeCubit(coinRepo);
          expect(
            exchangeCubit.fromJson(exchangeCubit.toJson(exchangeCubit.state)),
            exchangeCubit.state,
          );
        });
      });

      group(
        'fetchExchange',
        () {
          blocTest<ExchangeCubit, ExchangeState>(
            'emits nothing base is null',
            build: () => exchangeCubit,
            act: (cubit) => cubit.fetchExchange(null, exchangeQuote),
            expect: () => <ExchangeState>[],
          );

          blocTest<ExchangeCubit, ExchangeState>(
            'emits nothing quote is null',
            build: () => exchangeCubit,
            act: (cubit) => cubit.fetchExchange(exchangeBase, null),
            expect: () => <ExchangeState>[],
          );

          blocTest<ExchangeCubit, ExchangeState>(
            'emits nothing base is empty',
            build: () => exchangeCubit,
            act: (cubit) => cubit.fetchExchange('', exchangeQuote),
            expect: () => <ExchangeState>[],
          );

          blocTest<ExchangeCubit, ExchangeState>(
            'emits nothing quote is empty',
            build: () => exchangeCubit,
            act: (cubit) => cubit.fetchExchange(exchangeBase, ''),
            expect: () => <ExchangeState>[],
          );

          blocTest<ExchangeCubit, ExchangeState>(
            'calls getExchange with correct parameters',
            build: () => exchangeCubit,
            act: (cubit) => cubit.fetchExchange(exchangeBase, exchangeQuote),
            verify: (_) {
              verify(() => coinRepo.getExchange(exchangeBase, exchangeQuote))
                  .called(1);
            },
          );

          blocTest<ExchangeCubit, ExchangeState>(
            'emits [loading, failure] when getExchange throws',
            setUp: () {
              when(
                () => coinRepo.getExchange(any(), any()),
              ).thenThrow(Exception('error'));
            },
            build: () => exchangeCubit,
            act: (cubit) => cubit.fetchExchange(exchangeBase, exchangeQuote),
            expect: () => <ExchangeState>[
              const ExchangeState(status: ExchangeStatus.loading),
              const ExchangeState(status: ExchangeStatus.failure),
            ],
          );

          blocTest<ExchangeCubit, ExchangeState>(
            'emits [loading, success] when getExchange returns',
            build: () => exchangeCubit,
            act: (cubit) => cubit.fetchExchange(exchangeBase, exchangeQuote),
            expect: () => <dynamic>[
              ExchangeState(status: ExchangeStatus.loading),
              isA<ExchangeState>()
                  .having((ex) => ex.status, 'status', ExchangeStatus.success)
                  .having((ex) => ex.exchange.base, 'base', exchangeBase)
                  .having((ex) => ex.exchange.quote, 'quote', exchangeQuote)
                  .having((ex) => ex.exchange.rate, 'rate', exchangeRate),
            ],
          );
        },
      );

      group(
        'refreshExchange',
        () {
          blocTest<ExchangeCubit, ExchangeState>(
            'emits nothing when status is not success',
            build: () => exchangeCubit,
            act: (cubit) => cubit.refreshExchange(),
            expect: () => <ExchangeState>[],
            verify: (_) {
              verifyNever(() => coinRepo.getExchange(any(), any()));
            },
          );

          blocTest<ExchangeCubit, ExchangeState>(
            'emits nothing when status is not success',
            build: () => exchangeCubit,
            seed: () => ExchangeState(status: ExchangeStatus.success),
            act: (cubit) => cubit.refreshExchange(),
            expect: () => <ExchangeState>[],
            verify: (_) {
              verifyNever(() => coinRepo.getExchange(any(), any()));
            },
          );

          blocTest<ExchangeCubit, ExchangeState>(
            'invokes getExchange with correct parameters',
            build: () => exchangeCubit,
            seed: () => ExchangeState(
              status: ExchangeStatus.success,
              exchange: Exchange(
                quote: exchangeQuote,
                base: exchangeBase,
                rate: exchangeRate,
              ),
            ),
            act: (cubit) => cubit.refreshExchange(),
            verify: (_) {
              verify(() => coinRepo.getExchange(exchangeBase, exchangeQuote));
            },
          );

          blocTest<ExchangeCubit, ExchangeState>(
            'emits nothing when exception is thrown',
            setUp: () {
              when(() => coinRepo.getExchange(any(), any()))
                  .thenThrow(Exception('error'));
            },
            build: () => exchangeCubit,
            seed: () => const ExchangeState(
              status: ExchangeStatus.success,
              exchange: Exchange(
                quote: exchangeQuote,
                base: exchangeBase,
                rate: exchangeRate,
              ),
            ),
            act: (cubit) => cubit.refreshExchange(),
            expect: () => <ExchangeState>[],
          );

          blocTest<ExchangeCubit, ExchangeState>(
            'emits updated exchange',
            build: () => exchangeCubit,
            seed: () => const ExchangeState(
              status: ExchangeStatus.success,
              exchange: Exchange(
                quote: 'GBP',
                base: 'ETH',
                rate: 22762.01,
              ),
            ),
            act: (cubit) => cubit.refreshExchange(),
            expect: () => <Matcher>[
              isA<ExchangeState>()
                  .having((ex) => ex.status, 'exchangeStatus',
                      ExchangeStatus.success)
                  .having(
                    (ex) => ex.exchange,
                    'exchange',
                    isA<Exchange>()
                        .having((x) => x.base, 'base', exchangeBase)
                        .having((x) => x.quote, 'quote', exchangeQuote)
                        .having((x) => x.rate, 'rate', exchangeRate),
                  ),
            ],
          );
        },
      );
    },
  );
}
