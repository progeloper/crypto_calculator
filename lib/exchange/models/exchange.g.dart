// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exchange _$ExchangeFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Exchange',
      json,
      ($checkedConvert) {
        final val = Exchange(
          quote: $checkedConvert('quote', (v) => v as String),
          base: $checkedConvert('base', (v) => v as String),
          rate: $checkedConvert('rate', (v) => (v as num).toDouble()),
        );
        return val;
      },
    );

Map<String, dynamic> _$ExchangeToJson(Exchange instance) => <String, dynamic>{
      'quote': instance.quote,
      'base': instance.base,
      'rate': instance.rate,
    };
