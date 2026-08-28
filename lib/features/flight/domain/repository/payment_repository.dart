import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/payment_entity.dart';

abstract interface class PaymentRepository {
  Future<Either<Failure, PaymentEntity>> createPayment({
    required int pnrId,
    String? channel,
    String? paymentMethod,
  });

  Future<Either<Failure, PaymentViewEntity>> getPayment(int id);

  Future<Either<Failure, PaymentViewEntity>> getPaymentByPnr(int pnrId);
}
