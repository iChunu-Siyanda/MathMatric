import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/pagination_cursor.dart';

class FirestorePaginationCursor extends PaginationCursor {
  final DocumentSnapshot<Map<String, dynamic>> document;

  const FirestorePaginationCursor({
    required this.document,
  });
}
