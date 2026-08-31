import 'package:equatable/equatable.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/teaching_mode.dart';

class TutorEntity extends Equatable {
  final String id;
  final String displayName;
  final String? photoUrl;
  final String? headline;

  final String? bio;
  final String? qualification;
  final String? institution;
  
  final List<String> searchKeys;
  final List<TeachingMode> teachingModes;
  final double onlinePriceCents;
  final double inPersonPriceCents;

  final double rating;
  final int reviewCount;
  final int experienceYears;
  final bool isVerified;

  final double? latitude;
  final double? longitude;
  final String? geohash;

  const TutorEntity({
    required this.id,
    required this.displayName,
    this.photoUrl,
    this.headline,
    this.bio,
    this.qualification,
    this.institution,
    required this.searchKeys,
    required this.teachingModes,
    required this.onlinePriceCents,
    required this.inPersonPriceCents,
    required this.rating,
    required this.reviewCount,
    required this.experienceYears,
    required this.isVerified,
    this.latitude,
    this.longitude,
    this.geohash,
  });

  @override
  List<Object?> get props => [
    id,
    displayName,
    photoUrl,
    headline,
    bio,
    qualification,
    institution,
    searchKeys,
    teachingModes,
    onlinePriceCents,
    inPersonPriceCents,
    rating,
    reviewCount,
    experienceYears,
    isVerified,
    latitude,
    longitude,
    geohash,
  ];
}

// teachingModes:
// [
//   "online",
//   "inPerson"
// ]


// Example In Tutors App:
// tutors/
// └── tutor_001/
//     │
//     ├── displayName: "Siya Ndlovu"
//     ├── photoUrl: "..."
//     ├── headline: "Grade 12 Mathematics Tutor"
//     │
//     ├── profileStatus: "published"
//     ├── isVerified: true
//     │
//     ├── serachKeys:
//     │   ├── "mathematics_grade12"
//     │   ├── "mathematics_grade12:quadratic_functions:online"
//     │   └── "mathematics_grade12:calculus:inPerson"
//     ├── teachingModes:
//     │   ├── "online"
//     │   └── "inPerson"
//     │
//     ├── onlinePrice: 180
//     ├── inPersonPrice: 250
//     │
//     ├── rating: 4.8
//     ├── reviewCount: 124
//     ├── experienceYears: 6
//     │
//     ├── latitude: -26.2041
//     ├── longitude: 28.0473
//     └── geohash: "..."