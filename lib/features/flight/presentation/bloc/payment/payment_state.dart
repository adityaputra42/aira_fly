part of 'payment_bloc.dart';

sealed class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

final class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentCreated extends PaymentState {
  final PaymentEntity payment;

  const PaymentCreated(this.payment);

  @override
  List<Object?> get props => [payment];
}

class PaymentDetailLoaded extends PaymentState {
  final PaymentViewEntity payment;

  const PaymentDetailLoaded(this.payment);

  @override
  List<Object?> get props => [payment];
}


class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);

  @override
  List<Object?> get props => [message];
}
