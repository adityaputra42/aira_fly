part of 'wallet_bloc.dart';

sealed class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

final class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class BalanceLoaded extends WalletState {
  final BalanceEntity balance;

  const BalanceLoaded(this.balance);

  @override
  List<Object?> get props => [balance];
}

class WalletTransactionsLoaded extends WalletState {
  final List<WalletTransactionEntity> transactions;

  const WalletTransactionsLoaded(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

class TopupCreated extends WalletState {
  final TopupEntity topup;

  const TopupCreated(this.topup);

  @override
  List<Object?> get props => [topup];
}

class TopupStatusLoaded extends WalletState {
  final TopupStatusEntity status;

  const TopupStatusLoaded(this.status);

  @override
  List<Object?> get props => [status];
}

class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object?> get props => [message];
}
