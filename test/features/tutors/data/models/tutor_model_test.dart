import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/marketplace/tutors/data/models/tutor_model.dart';

void main() {
  group('TutorModel', () {
    const tutor = TutorModel(
      id: 'tutor-1',
      displayName: 'John Smith',
      photoUrl: 'https://example.com/john.jpg',
      headline: 'Grade 12 Mathematics Tutor',
      rating: 4.8,
      reviewCount: 125,
      experienceYears: 6,
      isVerified: true, 
      teachingModes: [],
    );

    test('fromMap should create TutorModel correctly', () {
      final model = TutorModel.fromFirestore({
        'id': 'tutor-1',
        'displayName': 'John Smith',
        'photoUrl': 'https://example.com/john.jpg',
        'headline': 'Grade 12 Mathematics Tutor',
        'rating': 4.8,
        'reviewCount': 125,
        'experienceYears': 6,
        'isVerified': true,
      });

      expect(model, tutor);
    });

    test('toMap should convert TutorModel correctly', () {
      final map = tutor.toFirestore();

      expect(map['id'], 'tutor-1');
      expect(map['displayName'], 'John Smith');
      expect(map['photoUrl'], 'https://example.com/john.jpg');
      expect(map['headline'], 'Grade 12 Mathematics Tutor');
      expect(map['rating'], 4.8);
      expect(map['reviewCount'], 125);
      expect(map['experienceYears'], 6);
      expect(map['isVerified'], true);
    });

    test('fromMap should use defaults for optional numeric/bool fields',
        () {
      final model = TutorModel.fromFirestore({
        'id': 'tutor-2',
        'displayName': 'Jane Doe',
      });

      expect(model.rating, 0.0);
      expect(model.reviewCount, 0);
      expect(model.experienceYears, 0);
      expect(model.isVerified, false);
      expect(model.photoUrl, isNull);
      expect(model.headline, isNull);
    });
  });
}
