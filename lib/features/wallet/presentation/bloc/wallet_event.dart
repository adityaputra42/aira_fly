part of 'wallet_bloc.dart';

sealed class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class LoadBalanceRequested extends WalletEvent {}

class LoadWalletTransactionsRequested extends WalletEvent {
  final int page;
  final int limit;

  const LoadWalletTransactionsRequested({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

class TopupWalletRequested extends WalletEvent {
  final double amount;
  final String? channel;

  const TopupWalletRequested({required this.amount, this.channel});

  @override
  List<Object?> get props => [amount, channel];
}

class LoadTopupStatusRequested extends WalletEvent {
  final String code;

  const LoadTopupStatusRequested({required this.code});

  @override
  List<Object?> get props => [code];
}
