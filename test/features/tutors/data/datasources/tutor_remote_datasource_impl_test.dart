import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/marketplace/tutors/data/repositories/tutor_remote_data_source_impl.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late TutorRemoteDataSourceImpl datasource;

  setUp(() {
    firestore = FakeFirebaseFirestore();

    datasource = TutorRemoteDataSourceImpl(
      firestore: firestore,
    );
  });

  group('getTutors', () {
    test('should return only published tutors', () async {
      await firestore.collection('tutors').doc('tutor-1').set({
        'displayName': 'Alice',
        'profileStatus': 'published',
        'rating': 4.8,
        'reviewCount': 100,
        'experienceYears': 5,
        'isVerified': true,
      });

      await firestore.collection('tutors').doc('tutor-2').set({
        'displayName': 'Bob',
        'profileStatus': 'draft',
        'rating': 4.9,
        'reviewCount': 80,
        'experienceYears': 7,
        'isVerified': true,
      });

      final result = await datasource.getTutors();

      expect(result.tutors.length, 1);
      expect(result.tutors.first.id, 'tutor-1');
      expect(result.tutors.first.displayName, 'Alice');
    });

    test('should respect pagination limit', () async {
      for (var i = 1; i <= 5; i++) {
        await firestore.collection('tutors').doc('tutor-$i').set({
          'displayName': 'Tutor $i',
          'profileStatus': 'published',
          'rating': 4.5,
          'reviewCount': 10,
          'experienceYears': 2,
          'isVerified': true,
        });
      }

      final result = await datasource.getTutors(limit: 2);

      expect(result.tutors.length, 2);
      expect(result.lastCursor, isNotNull);
      expect(result.hasMore, true);
    });

    test('should return hasMore false when final page is reached',
        () async {
      await firestore.collection('tutors').doc('tutor-1').set({
        'displayName': 'Alice',
        'profileStatus': 'published',
        'rating': 4.8,
        'reviewCount': 100,
        'experienceYears': 5,
        'isVerified': true,
      });

      final result = await datasource.getTutors(limit: 10);

      expect(result.tutors.length, 1);
      expect(result.hasMore, false);
    });

    // test(
    //   'should load the next page using the last document cursor',
    //   () async {
    //     await firestore.collection('tutors').doc('tutor-1').set({
    //       'displayName': 'Alice',
    //       'profileStatus': 'published',
    //       'rating': 4.8,
    //       'reviewCount': 100,
    //       'experienceYears': 5,
    //       'isVerified': true,
    //     });

    //     await firestore.collection('tutors').doc('tutor-2').set({
    //       'displayName': 'Bob',
    //       'profileStatus': 'published',
    //       'rating': 4.7,
    //       'reviewCount': 80,
    //       'experienceYears': 4,
    //       'isVerified': true,
    //     });

    //     await firestore.collection('tutors').doc('tutor-3').set({
    //       'displayName': 'Charlie',
    //       'profileStatus': 'published',
    //       'rating': 4.6,
    //       'reviewCount': 50,
    //       'experienceYears': 3,
    //       'isVerified': true,
    //     });

    //     await firestore.collection('tutors').doc('tutor-4').set({
    //       'displayName': 'David',
    //       'profileStatus': 'published',
    //       'rating': 4.5,
    //       'reviewCount': 40,
    //       'experienceYears': 2,
    //       'isVerified': true,
    //     });

    //     final firstPage = await datasource.getTutors(limit: 2);

    //     expect(firstPage.tutors.length, 2);
    //     expect(firstPage.tutors[0].id, 'tutor-1');
    //     expect(firstPage.tutors[1].id, 'tutor-2');
    //     expect(firstPage.lastCursor, isNotNull);
    //     expect(firstPage.hasMore, true);

    //     final secondPage = await datasource.getTutors(
    //       limit: 2,
    //       startAfter: firstPage.lastCursor,
    //     );

    //     expect(secondPage.tutors.length, 2);
    //     expect(secondPage.tutors[0].id, 'tutor-3');
    //     expect(secondPage.tutors[1].id, 'tutor-4');
    //     expect(secondPage.hasMore, true);
    //   },
    // );
  
  });

  group('getTutor', () {
    test('should return tutor when tutor exists', () async {
      await firestore.collection('tutors').doc('tutor-1').set({
        'displayName': 'Alice',
        'profileStatus': 'published',
        'rating': 4.8,
        'reviewCount': 100,
        'experienceYears': 5,
        'isVerified': true,
      });

      final result = await datasource.getTutor('tutor-1');

      expect(result.id, 'tutor-1');
      expect(result.displayName, 'Alice');
      expect(result.rating, 4.8);
    });

    test('should throw when tutor does not exist', () async {
      expect(
        () => datasource.getTutor('missing-tutor'),
        throwsException,
      );
    });
  });
}
