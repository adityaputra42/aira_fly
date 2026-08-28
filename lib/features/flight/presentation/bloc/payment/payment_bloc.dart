import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/payment_entity.dart';
import '../../../domain/usecases/payment/create_payment.dart';
import '../../../domain/usecases/payment/get_payment.dart';
import '../../../domain/usecases/payment/get_payment_by_pnr.dart';
part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final CreatePayment createPaymentUseCase;
  final GetPayment getPaymentUseCase;
  final GetPaymentByPnr getPaymentByPnrUseCase;

  PaymentBloc({
    required this.createPaymentUseCase,
    required this.getPaymentUseCase,
    required this.getPaymentByPnrUseCase,
  }) : super(PaymentInitial()) {
    on<CreatePaymentRequested>(_onCreatePayment);
    on<LoadPaymentRequested>(_onLoadPayment);
    on<LoadPaymentByPnrRequested>(_onLoadPaymentByPnr);
  }

  Future _onCreatePayment(CreatePaymentRequested event, Emitter emit) async {
    emit(PaymentLoading());

    final result = await createPaymentUseCase(
      CreatePaymentParams(
        pnrId: event.pnrId,
        channel: event.channel,
        paymentMethod: event.paymentMethod,
      ),
    );

    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (payment) => emit(PaymentCreated(payment)),
    );
  }

  Future _onLoadPayment(LoadPaymentRequested event, Emitter emit) async {
    emit(PaymentLoading());

    final result = await getPaymentUseCase(GetPaymentParams(id: event.id));

    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (payment) => emit(PaymentDetailLoaded(payment)),
    );
  }

  Future _onLoadPaymentByPnr(LoadPaymentByPnrRequested event, Emitter emit) async {
    emit(PaymentLoading());

    final result = await getPaymentByPnrUseCase(GetPaymentByPnrParams(pnrId: event.pnrId));

    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (payment) => emit(PaymentDetailLoaded(payment)),
    );
  }

}
