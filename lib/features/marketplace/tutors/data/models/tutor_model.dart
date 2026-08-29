import '../../domain/entities/tutor_entity.dart';

class TutorModel extends TutorEntity {
  const TutorModel({
    required super.id,
    required super.displayName,
    super.photoUrl,
    super.headline,
    required super.rating,
    required super.reviewCount,
    required super.experienceYears,
    required super.isVerified,
  });

  factory TutorModel.fromFirestore(Map<String, dynamic> map) {
    return TutorModel(
      id: map['id'] as String,
      displayName: map['displayName'] as String,
      photoUrl: map['photoUrl'] as String?,
      headline: map['headline'] as String?,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
      experienceYears: (map['experienceYears'] as num?)?.toInt() ?? 0,
      isVerified: map['isVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'headline': headline,
      'rating': rating,
      'reviewCount': reviewCount,
      'experienceYears': experienceYears,
      'isVerified': isVerified,
    };
  }
}
