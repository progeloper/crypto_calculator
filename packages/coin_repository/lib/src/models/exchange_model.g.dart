// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeModel _$ExchangeModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ExchangeModel',
      json,
      ($checkedConvert) {
        final val = ExchangeModel(
          base: $checkedConvert('asset_id_base', (v) => v as String),
          quote: $checkedConvert('asset_id_quote', (v) => v as String),
          rate: $checkedConvert('rate', (v) => (v as num).toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {'base': 'asset_id_base', 'quote': 'asset_id_quote'},
    );

Map<String, dynamic> _$ExchangeModelToJson(ExchangeModel instance) =>
    <String, dynamic>{
      'asset_id_base': instance.base,
      'asset_id_quote': instance.quote,
      'rate': instance.rate,
    };
