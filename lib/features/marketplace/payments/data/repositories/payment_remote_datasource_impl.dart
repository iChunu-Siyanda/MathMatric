import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:math_matric/core/constants/firestore_collections.dart';
import 'package:math_matric/features/marketplace/payments/data/datasources/payment_remote_datasource.dart';
import '../models/payment_model.dart';

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final FirebaseFunctions functions;
  final FirebaseFirestore firestore;
  const PaymentRemoteDataSourceImpl({required this.functions,required this.firestore});

  CollectionReference<Map<String, dynamic>> get _firestore => firestore.collection(FirestoreCollections.payments);

  @override
  Future<PaymentModel> initiatePayment({
    required String bookingId,
  }) async {
    final callable = functions.httpsCallable('initiatePayment');

    final result = await callable.call({'bookingId': bookingId,});

    final data = Map<String, dynamic>.from(result.data);

    final paymentData = Map<String,dynamic>.from(data['payment']);

    return PaymentModel.fromFirestore(paymentData);
  }

  @override
  Future<PaymentModel?> getPayment({
    required String paymentId,
  }) async {
    final snapshot = await _firestore
        .doc(paymentId) //paymentId = bookingId.
        .get();

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return PaymentModel.fromFirestore({
      'id': snapshot.id,
      ...snapshot.data()!,
    });
  }
}
