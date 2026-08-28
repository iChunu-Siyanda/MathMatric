# Identity model:
Firebase Auth UID
      │
      ├── students/{studentId}
      │
      └── tutors/{tutorId}


# Fierstore:
FIRESTORE
│
├── curriculum/
│   └── mathmatric/
│       │
│       ├── bundles/
│       │   └── {bundleId}
│       │
│       ├── subjects/
│       │   └── {subjectId}
│       │
│       ├── topics/
│       │   └── {topicId}
│       │
│       ├── levels/
│       │   └── {levelId}
│       │
│       ├── questions/
│       │   └── {questionId}
│       │
│       └── examPapers/
│           └── {examPaperId}
│
│
├── students/
│   └── {studentId}                         ← Firebase Auth UID
│       │
│       ├── profile
│       │
│       ├── questionAttempts/
│       │   └── {attemptId}
│       │
│       ├── userLevelProgresses/
│       │   └── {levelId}
│       │
│       ├── userTopicProgresses/
│       │   └── {topicId}
│       │
│       ├── studySessions/
│       │   └── {sessionId}
│       │
│       ├── notifications/
│       │   └── {notificationId}
│       │
│       ├── notificationPreferences/
│       │   └── preferences
│       │
│       ├── paymentMethods/
│       │   └── {paymentMethodId}
│       │
│       └── favouriteTutors/
│           └── {tutorId}
│
│
├── tutors/
│   └── {tutorId}                           ← Firebase Auth UID
│       │
│       ├── profile
│       │
│       ├── verification
│       │
│       ├── qualifications/
│       │   └── {qualificationId}
│       │
│       ├── offerings/
│       │   └── {offeringId}
│       │
│       ├── location
│       │
│       ├── serviceAreas/
│       │   └── {serviceAreaId}
│       │
│       ├── availabilityRules/
│       │   └── {ruleId}
│       │
│       ├── availabilityExceptions/
│       │   └── {exceptionId}
│       │
│       ├── rating
│       │
│       ├── reliability
│       │
│       └── reviews/
│           └── {reviewId}
│
│
├── bookings/
│   └── {bookingId}
│       │
│       ├── cancellation
│       │
│       ├── reschedules/
│       │   └── {rescheduleId}
│       │
│       └── dispute
│
│
├── tutoringSessions/
│   └── {sessionId}
│       │
│       ├── attendance/
│       │   └── {userId}
│       │
│       └── videoSession
│
│
├── masterclasses/
│   └── {masterclassId}
│       │
│       ├── sessions/
│       │   └── {sessionId}
│       │       │
│       │       └── attendance/
│       │           └── {userId}
│       │
│       └── enrollments/
│           └── {studentId}
│
│
├── payments/
│   └── {paymentId}
│       │
│       └── refunds/
│           └── {refundId}
│
│
├── tutorAccounts/
│   └── {tutorId}
│       │
│       ├── earnings/
│       │   └── {earningId}
│       │
│       └── payouts/
│           └── {payoutId}
│
│
└── supportCases/
    └── {caseId}


# Storage:
STORAGE
│
├── exam-papers/
│   └── mathematics/
│       └── grade-12/
│           └── {year}/
│               └── {session}/
│                   └── {paperId}/
│                       ├── page-01.webp
│                       ├── page-02.webp
│                       └── ...
│
├── tutors/
│   └── {tutorId}/
│       ├── profile/
│       │   └── profile-image
│       │
│       ├── qualifications/
│       │   └── {qualificationId}/
│       │       └── document
│       │
│       └── verification/
│           └── {documentType}/
│               └── document
│
├── masterclasses/
│   └── {masterclassId}/
│       ├── thumbnails/
│       │   └── thumbnail
│       │
│       └── resources/
│           └── {resourceId}
│
└── support/
    └── {caseId}/
        └── {evidenceId}


# Storage Security:
exam-papers/
    → Students: READ
    → Tutors: READ if appropriate
    → Write: Admin/backend only

tutors/{tutorId}/verification/
    → Tutor: UPLOAD own documents
    → Student: NO ACCESS
    → Admin/backend: controlled access

tutors/{tutorId}/profile/
    → Public/published profile image: READ
    → Tutor: own write


# Example of Curriculums:
curriculum/                         ← collection
└── mathmatric/                     ← document
    ├── bundles/                    ← subcollection
    │   └── grade12_math_v1/
    ├── subjects/
    │   └── mathematics_grade12/
    ├── topics/
    ├── levels/
    ├── questions/
    └── examPapers/
           ├── ep_math_2023_p1/          ← Document ID (examPaperId)
        │   ├── id: "ep_math_2023_p1"
        │   ├── name: "November 2023 Paper 1"
        │   ├── subjectId: "maths_gr12"
        │   └── pageCount: 12
        │
        └── ep_math_2023_p2/          ← Document ID (examPaperId)
            ├── id: "ep_math_2023_p2"
            ├── name: "November 2023 Paper 2"
            ├── subjectId: "maths_gr12"
            └── pageCount: 14 
                