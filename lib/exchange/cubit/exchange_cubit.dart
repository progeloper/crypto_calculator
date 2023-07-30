import 'package:bloc/bloc.dart';
import 'package:crypto_calculator/exchange/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:coin_repository/coin_repository.dart' show CoinRepository;

part 'exchange_state.dart';
part 'exchange_cubit.g.dart';

class ExchangeCubit extends Cubit<ExchangeState> {
  ExchangeCubit(this._repository): super(ExchangeState());

  final CoinRepository _repository;

  Future<void> fetchExchange(String? base, String? quote) async{
    if(base == null || base.isEmpty || quote == null || quote.isEmpty) return;
    emit(state.copyWith(status: ExchangeStatus.loading));
    try{
      final exchange = Exchange.fromRepository(await _repository.getExchange(base, quote));
      emit(state.copyWith(exchange: exchange, status: ExchangeStatus.success));
    } on Exception{
      emit(state.copyWith(status: ExchangeStatus.failure));
    }
  }

  Future<void> refreshExchange() async{
    if(!state.status.isSuccess) return;
    if(state.exchange == Exchange.empty) return;
    try{
      final exchange = Exchange.fromRepository(await _repository.getExchange(state.exchange.base, state.exchange.quote));
      emit(state.copyWith(exchange: exchange, status: ExchangeStatus.success));
    } on Exception{
      emit(state);
    }
  }

  @override
  ExchangeState fromJson(Map<String, dynamic> json){
    return ExchangeState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(){
    return state.toJson();
  }

}
