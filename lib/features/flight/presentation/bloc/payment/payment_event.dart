part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class CreatePaymentRequested extends PaymentEvent {
  final int pnrId;
  final String? channel;
  final String? paymentMethod;

  const CreatePaymentRequested({required this.pnrId, this.channel, this.paymentMethod});

  @override
  List<Object?> get props => [pnrId, channel, paymentMethod];
}

class LoadPaymentRequested extends PaymentEvent {
  final int id;

  const LoadPaymentRequested({required this.id});

  @override
  List<Object?> get props => [id];
}

class LoadPaymentByPnrRequested extends PaymentEvent {
  final int pnrId;

  const LoadPaymentByPnrRequested({required this.pnrId});

  @override
  List<Object?> get props => [pnrId];
}
