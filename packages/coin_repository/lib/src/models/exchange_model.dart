import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exchange_model.g.dart';

@JsonSerializable()
class ExchangeModel extends Equatable {
  @JsonKey(name: 'asset_id_base')
  final String base;
  @JsonKey(name: 'asset_id_quote')
  final String quote;

  final double rate;

  const ExchangeModel({
    required this.base,
    required this.quote,
    required this.rate,
  });

  factory ExchangeModel.fromJson(Map<String, dynamic> json)=>_$ExchangeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeModelToJson(this);

  @override
  // TODO: implement props
  List<Object?> get props => [
        base,
        quote,
        rate,
      ];
}
