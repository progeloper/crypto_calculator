import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:coin_repository/coin_repository.dart' hide ExchangeModel;
import 'package:coin_repository/coin_repository.dart' as coin_repository;

part 'exchange.g.dart';

@JsonSerializable()
class Exchange extends Equatable {
  final String quote;
  final String base;
  final double rate;

  const Exchange({
    required this.quote,
    required this.base,
    required this.rate,
  });

  static const empty = Exchange(quote: 'USD', base: 'BTC', rate: 0);

  factory Exchange.fromRepository(coin_repository.ExchangeModel model) {
    return Exchange(quote: model.quote, base: model.base, rate: model.rate);
  }

  factory Exchange.fromJson(Map<String, dynamic> json) =>
      _$ExchangeFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeToJson(this);

  Exchange copyWith({
    String? base,
    String? quote,
    double? rate,
  }) {
    return Exchange(
      quote: quote ?? this.quote,
      base: base ?? this.base,
      rate: rate ?? this.rate,
    );
  }

  @override
  List<Object?> get props => [quote, base, rate];
}
