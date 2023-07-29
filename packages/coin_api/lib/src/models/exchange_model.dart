import 'package:json_annotation/json_annotation.dart';

part 'exchange_model.g.dart';

@JsonSerializable()
class Exchange {
  @JsonKey(name: 'asset_id_base')
  final String base;
  @JsonKey(name: 'asset_id_quote')
  final String quote;
  @JsonKey(name: 'rate')
  final double rate;

  const Exchange({
    required this.base,
    required this.quote,
    required this.rate,
  });

  factory Exchange.fromJson(Map<String, dynamic> json) => _$ExchangeFromJson(json);

}