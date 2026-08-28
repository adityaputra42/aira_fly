import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/payment_entity.dart';
import '../../repository/payment_repository.dart';

class CreatePayment implements UseCase<PaymentEntity, CreatePaymentParams> {
  final PaymentRepository paymentRepository;

  const CreatePayment(this.paymentRepository);

  @override
  Future<Either<Failure, PaymentEntity>> call(CreatePaymentParams params) {
    return paymentRepository.createPayment(
      pnrId: params.pnrId,
      channel: params.channel,
      paymentMethod: params.paymentMethod,
    );
  }
}

class CreatePaymentParams {
  final int pnrId;

  final String? channel;
  final String? paymentMethod;

  const CreatePaymentParams({required this.pnrId, this.channel, this.paymentMethod});
}
