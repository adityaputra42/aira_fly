import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/usecases/get_balance.dart';
import '../../domain/usecases/get_topup_status.dart';
import '../../domain/usecases/list_wallet_transactions.dart';
import '../../domain/usecases/topup_wallet.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetBalance getBalanceUseCase;
  final ListWalletTransactions listTransactionsUseCase;
  final TopupWallet topupWalletUseCase;
  final GetTopupStatus getTopupStatusUseCase;

  WalletBloc({
    required this.getBalanceUseCase,
    required this.listTransactionsUseCase,
    required this.topupWalletUseCase,
    required this.getTopupStatusUseCase,
  }) : super(WalletInitial()) {
    on<LoadBalanceRequested>(_onLoadBalance);
    on<LoadWalletTransactionsRequested>(_onLoadTransactions);
    on<TopupWalletRequested>(_onTopup);
    on<LoadTopupStatusRequested>(_onLoadTopupStatus);
  }

  Future _onLoadBalance(LoadBalanceRequested event, Emitter emit) async {
    emit(WalletLoading());

    final result = await getBalanceUseCase(NoParams());

    result.fold(
      (failure) => emit(WalletError(failure.message)),
      (balance) => emit(BalanceLoaded(balance)),
    );
  }

  Future _onLoadTransactions(LoadWalletTransactionsRequested event, Emitter emit) async {
    emit(WalletLoading());

    final result = await listTransactionsUseCase(
      ListWalletTransactionsParams(page: event.page, limit: event.limit),
    );

    result.fold(
      (failure) => emit(WalletError(failure.message)),
      (transactions) => emit(WalletTransactionsLoaded(transactions)),
    );
  }

  Future _onTopup(TopupWalletRequested event, Emitter emit) async {
    emit(WalletLoading());

    final result = await topupWalletUseCase(
      TopupWalletParams(amount: event.amount, channel: event.channel),
    );

    result.fold(
      (failure) => emit(WalletError(failure.message)),
      (topup) => emit(TopupCreated(topup)),
    );
  }

  Future _onLoadTopupStatus(LoadTopupStatusRequested event, Emitter emit) async {
    emit(WalletLoading());

    final result = await getTopupStatusUseCase(GetTopupStatusParams(code: event.code));

    result.fold(
      (failure) => emit(WalletError(failure.message)),
      (status) => emit(TopupStatusLoaded(status)),
    );
  }
}
