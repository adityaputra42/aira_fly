part of 'wallet_bloc.dart';

enum WalletStatus { initial, loading, success, failure }

class WalletState extends Equatable {
  final WalletStatus balanceStatus;
  final WalletStatus transactionsStatus;
  final WalletStatus createTopupStatus;
  final WalletStatus getTopupStatusStatus;

  final BalanceEntity? balance;
  final List<WalletTransactionEntity> transactions;
  final TopupEntity? topup;
  final TopupStatusEntity? topupStatus;

  final String? balanceError;
  final String? transactionsError;
  final String? createTopupError;
  final String? getTopupStatusError;

  const WalletState({
    this.balanceStatus = WalletStatus.initial,
    this.transactionsStatus = WalletStatus.initial,
    this.createTopupStatus = WalletStatus.initial,
    this.getTopupStatusStatus = WalletStatus.initial,
    this.balance,
    this.transactions = const [],
    this.topup,
    this.topupStatus,
    this.balanceError,
    this.transactionsError,
    this.createTopupError,
    this.getTopupStatusError,
  });

  WalletState copyWith({
    WalletStatus? balanceStatus,
    WalletStatus? transactionsStatus,
    WalletStatus? createTopupStatus,
    WalletStatus? getTopupStatusStatus,
    BalanceEntity? balance,
    List<WalletTransactionEntity>? transactions,
    TopupEntity? topup,
    TopupStatusEntity? topupStatus,
    String? balanceError,
    String? transactionsError,
    String? createTopupError,
    String? getTopupStatusError,
  }) {
    return WalletState(
      balanceStatus: balanceStatus ?? this.balanceStatus,
      transactionsStatus: transactionsStatus ?? this.transactionsStatus,
      createTopupStatus: createTopupStatus ?? this.createTopupStatus,
      getTopupStatusStatus: getTopupStatusStatus ?? this.getTopupStatusStatus,
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      topup: topup ?? this.topup,
      topupStatus: topupStatus ?? this.topupStatus,
      balanceError: balanceError ?? this.balanceError,
      transactionsError: transactionsError ?? this.transactionsError,
      createTopupError: createTopupError ?? this.createTopupError,
      getTopupStatusError: getTopupStatusError ?? this.getTopupStatusError,
    );
  }

  @override
  List<Object?> get props => [
    balanceStatus,
    transactionsStatus,
    createTopupStatus,
    getTopupStatusStatus,
    balance,
    transactions,
    topup,
    topupStatus,
    balanceError,
    transactionsError,
    createTopupError,
    getTopupStatusError,
  ];
}
