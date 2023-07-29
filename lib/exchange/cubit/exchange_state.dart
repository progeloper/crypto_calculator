part of 'exchange_cubit.dart';

enum ExchangeStatus { initial, loading, success, failure }

extension ExchangeStatusX on ExchangeStatus {
  bool get isInitial => this == ExchangeStatus.initial;
  bool get isLoading => this == ExchangeStatus.loading;
  bool get isSuccess => this == ExchangeStatus.success;
  bool get isFailure => this == ExchangeStatus.failure;
}

@JsonSerializable()
class ExchangeState extends Equatable {
  final ExchangeStatus status;
  final Exchange exchange;
  const ExchangeState({
    this.status = ExchangeStatus.initial,
    Exchange? exchange,
  }) : exchange = exchange ?? Exchange.empty;

  factory ExchangeState.fromJson(Map<String, dynamic> json) =>
      _$ExchangeStateFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeStateToJson(this);

  ExchangeState copyWith({
    Exchange? exchange,
    ExchangeStatus? status,
  }) {
    return ExchangeState(
      status: status ?? this.status,
      exchange: exchange ?? this.exchange,
    );
  }

  @override
  List<Object?> get props => [status, exchange];
}
