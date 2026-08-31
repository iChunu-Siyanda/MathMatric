import 'package:math_matric/features/marketplace/tutors/domain/entities/teaching_mode.dart';

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
    required super.teachingModes, 
    required super.searchKeys, 
    required super.onlinePriceCents, 
    required super.inPersonPriceCents,
    super.bio,
    super.qualification,
    super.institution,
    super.latitude,
    super.longitude,
    super.geohash,
  });

  factory TutorModel.fromFirestore(Map<String, dynamic> map) {
    return TutorModel(
      id: map['id'] as String,
      displayName: map['displayName'] as String,
      photoUrl: map['photoUrl'] as String?,
      headline: map['headline'] as String?,

      bio: map['bio'] as String?,
      qualification: map['qualification'] as String?,
      institution: map['institution'] as String?,

      searchKeys: List<String>.from(
        map['searchKeys'] ?? const [],
      ),

      teachingModes: (map['teachingModes'] as List<dynamic>? ?? [])
          .map(
            (mode) => TeachingMode.values.byName(
              mode as String,
            ),
          )
          .toList(),

      onlinePriceCents: (map['onlinePrice'] as num).toDouble(),
      inPersonPriceCents: (map['inPersonPrice'] as num).toDouble(),

      rating: (map['rating'] as num).toDouble(),
      reviewCount: map['reviewCount'] as int,
      experienceYears: map['experienceYears'] as int,

      isVerified: map['isVerified'] as bool,

      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      geohash: map['geohash'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'photoUrl': photoUrl,
      'headline': headline,

      'bio': bio,
      'qualification': qualification,
      'institution': institution,

      'searchKeys': searchKeys,

      'teachingModes': teachingModes
          .map((mode) => mode.name)
          .toList(),

      'onlinePrice': onlinePriceCents,
      'inPersonPrice': inPersonPriceCents,

      'rating': rating,
      'reviewCount': reviewCount,
      'experienceYears': experienceYears,

      'isVerified': isVerified,

      'latitude': latitude,
      'longitude': longitude,
      'geohash': geohash,
    };
  }
}
