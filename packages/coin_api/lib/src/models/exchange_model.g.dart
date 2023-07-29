// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'exchange_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exchange _$ExchangeFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Exchange',
      json,
      ($checkedConvert) {
        final val = Exchange(
          base: $checkedConvert('asset_id_base', (v) => v as String),
          quote: $checkedConvert('asset_id_quote', (v) => v as String),
          rate: $checkedConvert('rate', (v) => (v as num).toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {'base': 'asset_id_base', 'quote': 'asset_id_quote'},
    );
