// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeState _$ExchangeStateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ExchangeState',
      json,
      ($checkedConvert) {
        final val = ExchangeState(
          status: $checkedConvert(
              'status',
              (v) =>
                  $enumDecodeNullable(_$ExchangeStatusEnumMap, v) ??
                  ExchangeStatus.initial),
          exchange: $checkedConvert(
              'exchange',
              (v) => v == null
                  ? null
                  : Exchange.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$ExchangeStateToJson(ExchangeState instance) =>
    <String, dynamic>{
      'status': _$ExchangeStatusEnumMap[instance.status]!,
      'exchange': instance.exchange.toJson(),
    };

const _$ExchangeStatusEnumMap = {
  ExchangeStatus.initial: 'initial',
  ExchangeStatus.loading: 'loading',
  ExchangeStatus.success: 'success',
  ExchangeStatus.failure: 'failure',
};
