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
