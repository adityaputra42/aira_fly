import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/payment_entity.dart';
import '../../repository/payment_repository.dart';

class GetPayment implements UseCase<PaymentViewEntity, GetPaymentParams> {
  final PaymentRepository paymentRepository;

  const GetPayment(this.paymentRepository);

  @override
  Future<Either<Failure, PaymentViewEntity>> call(GetPaymentParams params) {
    return paymentRepository.getPayment(params.id);
  }
}

class GetPaymentParams {
  final int id;

  const GetPaymentParams({required this.id});
}
