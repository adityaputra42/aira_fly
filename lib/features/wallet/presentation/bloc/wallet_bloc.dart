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
  }) : super(WalletState()) {
    on<LoadBalanceRequested>(_onLoadBalance);
    on<LoadWalletTransactionsRequested>(_onLoadTransactions);
    on<TopupWalletRequested>(_onTopup);
    on<LoadTopupStatusRequested>(_onLoadTopupStatus);
  }

  Future<void> _onLoadBalance(LoadBalanceRequested event, Emitter<WalletState> emit) async {
    emit(state.copyWith(balanceStatus: WalletStatus.loading, balanceError: null));

    final result = await getBalanceUseCase(NoParams());

    result.fold(
      (failure) {
        emit(state.copyWith(balanceStatus: WalletStatus.failure, balanceError: failure.message));
      },
      (balance) {
        emit(state.copyWith(balanceStatus: WalletStatus.success, balance: balance));
      },
    );
  }

  Future<void> _onLoadTransactions(
    LoadWalletTransactionsRequested event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(transactionsStatus: WalletStatus.loading, transactionsError: null));

    final result = await listTransactionsUseCase(
      ListWalletTransactionsParams(page: event.page, limit: event.limit),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            transactionsStatus: WalletStatus.failure,
            transactionsError: failure.message,
          ),
        );
      },
      (transactions) {
        emit(state.copyWith(transactionsStatus: WalletStatus.success, transactions: transactions));
      },
    );
  }

  Future<void> _onTopup(TopupWalletRequested event, Emitter<WalletState> emit) async {
    emit(state.copyWith(createTopupStatus: WalletStatus.loading, createTopupError: null));

    final result = await topupWalletUseCase(
      TopupWalletParams(amount: event.amount, channel: event.channel),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            createTopupStatus: WalletStatus.failure,
            createTopupError: failure.message,
          ),
        );
      },
      (topup) {
        emit(state.copyWith(createTopupStatus: WalletStatus.success, topup: topup));
      },
    );
  }

  Future<void> _onLoadTopupStatus(LoadTopupStatusRequested event, Emitter<WalletState> emit) async {
    emit(state.copyWith(getTopupStatusStatus: WalletStatus.loading, getTopupStatusError: null));

    final result = await getTopupStatusUseCase(GetTopupStatusParams(code: event.code));

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            getTopupStatusStatus: WalletStatus.failure,
            getTopupStatusError: failure.message,
          ),
        );
      },
      (status) {
        emit(state.copyWith(getTopupStatusStatus: WalletStatus.success, topupStatus: status));
      },
    );
  }
}
