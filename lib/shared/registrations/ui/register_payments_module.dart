import 'package:get_it/get_it.dart';
import 'package:math_matric/features/marketplace/payments/domain/repositories/payment_repository.dart';
import 'package:math_matric/features/marketplace/payments/domain/usecases/get_payment_use_case.dart';
import 'package:math_matric/features/marketplace/payments/domain/usecases/initiate_payment_use_case.dart';
import 'package:math_matric/features/marketplace/payments/presentation/bloc/payment_bloc.dart';

final getIt = GetIt.instance;

void registerPaymentsModule() {
  //usecases:
  getIt.registerLazySingleton(
    () => InitiatePaymentUseCase(getIt<PaymentRepository>(),),
  );

  getIt.registerLazySingleton(
    () => GetPaymentUseCase(getIt<PaymentRepository>(),)
  );

  //Bloc:
  getIt.registerFactory(
    () => PaymentBloc(
      initiatePayment: getIt(), 
      getPayment: getIt(),
    )
  );
}
