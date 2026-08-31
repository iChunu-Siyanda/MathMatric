import 'package:equatable/equatable.dart';

class TutorEntity extends Equatable {
  final String id;
  final String displayName;
  final String? photoUrl;
  final String? headline;
  final double rating;
  final int reviewCount;
  final int experienceYears;
  final bool isVerified;

  const TutorEntity({
    required this.id,
    required this.displayName,
    this.photoUrl,
    this.headline,
    required this.rating,
    required this.reviewCount,
    required this.experienceYears,
    required this.isVerified,
  });

  @override
  List<Object?> get props => [
    id,
    displayName,
    photoUrl,
    headline,
    rating,
    reviewCount,
    experienceYears,
    isVerified,
  ];
}


// Example:
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