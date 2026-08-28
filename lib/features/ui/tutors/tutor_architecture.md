# Tutor:
1. Classification: Core Firestore document
2. Firestore: 
tutors/{tutorId}
3. Relationships:
Tutor
├── Firebase Auth user
├── TutorProfile          1:1
├── TutorVerification     1:1
├── TutorQualification    1:N
├── TutorOffering         1:N
├── TutorLocation         1:1
└── TutorServiceArea      1:N
4. Authority:
Backend: status, eligibility, timestamps
Tutor: limited account/profile operations
Student: public/read-only information
Admin: moderation/suspension
5. Drift: No authoritative storage. Cache only if marketplace UX later benefits from it.
6. Decision: Tutor is the root marketplace identity.


# TutorProfile:
1. Classification: Core Firestore document
2. Firestore:
tutors/{tutorId}/profile
3. Relationships:
Tutor
  └── TutorProfile  1:1
4. Authority:
Tutor: name, bio, photo, languages, experience
Backend: profileStatus, timestamps
Student: read-only published profile
Admin: moderation
5. Drift: No authoritative storage. Optional cache for recently viewed profiles.
6. Decision: Keep the profile public-facing and clean.


# TutorVerification:
1. Classification: Sensitive Firestore document
2. Firestore:
tutors/{tutorId}/verification
3. Relationships:
Tutor
  └── TutorVerification  1:1
          ├── Identity verification
          ├── Qualification verification
          ├── Background verification
          └── Address verification
4. Authority:
Backend/Admin: full control
Tutor: submit/update verification requests
Student:No access to sensitive verification data
5. Storage:
Firebase Storage
└── tutor-verification/{tutorId}/...
6. Drift: Never cache verification documents/status locally unless a future UX requirement specifically demands a minimal derived status.
7. Decision: Verification is trusted backend state. The client can request verification; it cannot declare itself verified.


# TutorQualification:
1. Classification: Firestore subcollection
Firestore:
tutors/{tutorId}/qualifications/{qualificationId}
2. Relationships:
Tutor
  └── TutorQualification  1:N
          ↓
    Verification status
3. Authority:
Tutor: submits qualification information/documents
Backend/Admin: verifies and controls verificationStatus
Student: read-only verified qualification summary
4. Storage:
Firebase Storage
└── tutor-qualifications/{tutorId}/{qualificationId}/...
5. Drift: No. Optional cache of verified public summaries only.
6. Decision: The qualification record and its verification are separate concepts. A tutor can submit a qualification without it becoming a verified qualification.


# TutorOffering:
1. Classification: Firestore subcollection
2. Firestore:
tutors/{tutorId}/offerings/{offeringId}
3. Relationships:
Tutor
  └── TutorOffering  1:N
          ├── subjectId → MathMatric Subject
          └── topicIds[] → MathMatric Topics
4. Authority:
Tutor: creates/edits offering, supported modes, durations, prices
Backend: validates curriculum references, eligibility, pricing rules
Student: read-only
5. Drift: No authoritative storage. Optional cache for discovery/profile.
6. Decision: One offering supports online + in-person, with separate pricing per mode/duration. Existing MathMatric curriculum IDs are reused


# TutorLocation:
1. Classification: Firestore document
2. Firestore:
tutors/{tutorId}/location
3. Relationships:
Tutor
  └── TutorLocation  1:1
          ↓
    TutorServiceArea
          ↓
       Discovery
4. Authority:
Tutor: provides/updates service location
Backend: validates/geospatial indexing
Student: receives approximate distance/area only
5. Drift: No. Optional cache for discovery.
6. Decision: Never expose the tutor's exact private address. Store coordinates/geohash for matching, while the student sees only appropriate location information.


# TutorServiceArea:
1. Classification: Firestore subcollection
2. Firestore:
tutors/{tutorId}/serviceAreas/{serviceAreaId}
3. Relationships:
Tutor
  └── TutorServiceArea  1:N
          ↓
    Nearby Discovery
4. Authority:
Tutor: defines service area/radius
Backend: validates and applies geographic eligibility
Student: read-only result
5. Drift: No authoritative storage.
6. Decision: Start with radius-based service areas. Multiple areas can be supported later without redesigning the model.


# TutorAvailabilityRule:
1. Classification: Firestore subcollection
2. Firestore:
tutors/{tutorId}/availabilityRules/{ruleId}
3. Relationships:
Tutor
  └── AvailabilityRule  1:N
          ↓
    BookableSlot
4. Authority:
Tutor: creates/updates recurring availability
Backend: validates rules and calculates bookable slots
Student: read-only
5. Drift: No authoritative storage.
6. Decision: Store recurring rules, not generated future slots. Availability is calculated using rules + exceptions + existing bookings.


# AvailabilityException:
1. Classification: Firestore subcollection
2. Firestore:
tutors/{tutorId}/availabilityExceptions/{exceptionId}
3. Relationships:
Tutor
  ├── AvailabilityRule
  └── AvailabilityException
            ↓
       BookableSlot
4. Authority:
Tutor: creates/updates exceptions
Backend: validates and applies them
Student: read-only
5. Drift: No authoritative storage.
6. Decision: Exceptions handle blocked dates/times and special availability without modifying the recurring schedule.


# TutorRating:
1. Classification: Derived Firestore document
2. Firestore:
tutors/{tutorId}/rating/summary
3. Relationships:
Review  1:N
   ↓
TutorRating  1:1
   ↓
Tutor Profile + Discovery
4. Authority:
Backend: calculates and updates everything
Student: read-only
Tutor: read-only
5. Drift: No authoritative storage. Optional cache.
6. Decision: Review is the source of truth. TutorRating is a read-optimized aggregate for fast discovery and profile display.

# TutorReliability:
1. Classification: Derived Firestore document
2. Firestore:
tutors/{tutorId}/reliability/summary
3. Relationships:
Bookings
Sessions
Attendance
Cancellations
      ↓
TutorReliability
      ↓
TutorMatch
4. Authority:
Backend: calculates and updates
Tutor: read-only summary
Student: read-only relevant metrics
5. Drift: No authoritative storage.
6. Decision: Never let tutors manually edit reliability metrics. These are calculated from actual marketplace events.


# BookableSlot:
1. Classification: Domain/calculated object — not a Firestore document
2. Storage:
Calculated at request time
3. Relationships:
AvailabilityRule
      +
AvailabilityException
      +
Existing Bookings
      +
TutorOffering
      ↓
BookableSlot
      ↓
Booking
4. Authority:
Backend: calculates and validates
Student: can request/view
Tutor: does not directly create slots
5. Drift: No.
6. Decision: Never pre-create millions of slot documents. Generate candidate slots and revalidate availability transactionally when booking.


# TutorSearchCriteria:
1. Classification: Domain/query object — not a Firestore document
2. Storage:
Temporary in-memory query
3. Relationships:
Student Input
      ↓
TutorSearchCriteria
      ↓
Discovery / Matching
4. Authority:
Student: defines search criteria
Backend: validates supported filters and performs discovery
5. Drift: No.
6. Decision: Do not persist every search. If we later introduce saved searches, that becomes a separate feature/entity.


# TutorMatch:
1. Classification: Domain/calculated object — not a Firestore document
2. Storage:
Calculated at request time
3. Relationships:
TutorSearchCriteria
        +
Tutor Profile
TutorOffering
TutorLocation
Availability
TutorRating
TutorReliability
        ↓
    TutorMatch
4. Authority:
Backend: calculates match score/ranking
Student: read-only result
Tutor: cannot manipulate ranking
5. Drift: No.
6. Decision: matchScore is never permanently stored. This allows the matching algorithm to evolve without migrating tutor records.


# Booking:
1. Classification: Core Firestore document
2. Firestore:
bookings/{bookingId}
3. Relationships:
Student
  ↓
Booking
  ├── tutorId
  ├── offeringId
  ├── topicId
  └── session
        ↓
     Payment
4. Authority:
Student: requests/cancels according to policy
Tutor: accepts/rejects where applicable
Backend: validates slot, price, status, permissions
Admin: intervention when required
3. Status:
requested
pending_payment
confirmed
in_progress
completed
cancelled
rejected
expired
no_show
5. Drift:  Yes — cache upcoming and recent bookings for offline viewing.
6. Decision: Booking is the central transactional record. Payment, session, cancellation, rescheduling, disputes and reviews reference it.


# TutoringSession:
1. Classification: Core Firestore document
2. Firestore:
tutoringSessions/{sessionId}
3. Relationships:
Booking
  ↓
TutoringSession
  ├── Attendance
  ├── VideoSession
  ├── Payment settlement
  └── Review eligibility
4. Authority:
Backend: session lifecycle
Student/Tutor: limited session actions
Admin: intervention
5. Status:
scheduled
in_progress
completed
cancelled
no_show
6. Drift: Yes — cache upcoming/recent sessions for offline viewing.
7. Decision: Keep Booking and TutoringSession separate.


# Attendance:
1. Classification: Core Firestore subcollection
2. Firestore:
tutoringSessions/{sessionId}/attendance/{attendanceId}
For masterclasses, the same concept will attach to MasterclassSession.
3. Relationships:
TutoringSession / MasterclassSession
        ↓
    Attendance
        ↓
Session outcome
4. Authority:
Backend: determines attendance from session/video events
Student/Tutor: limited participation actions
Admin: correction/intervention
5. Status:
present
late
absent
no_show
6. Drift: No authoritative storage.
7. Decision: Attendance should be based primarily on actual session participation, not a client-controlled present = true


# Payment:
1. Classification: Core Firestore document
2. Firestore:
payments/{paymentId}
3. Relationships:
Booking / MasterclassEnrollment
          ↓
        Payment
          ↓
     TutorEarning
4. Authority:
Student: initiates payment
Payment provider: processes transaction
Backend/webhook: authoritative payment state
Admin: limited intervention
5. Status:
pending
processing
successful
failed
refunded
partially_refunded
6. Drift: No authoritative storage. Do not rely on cached payment state for financial decisions.
7. Decision: Flutter can request payment; only the payment provider + trusted backend can establish that payment actually succeeded.


# Refund:
1. Classification: Core Firestore document
2. Firestore:
refunds/{refundId}
Relationships:
Payment
   ↓
Refund
   ↓
TutorEarning adjustment
3. Authority:
Student: may request where policy allows
Tutor: may request/trigger review where applicable
Backend: determines eligibility and amount
Payment provider: executes refund
Admin: handles exceptional cases
4. Status:
requested
processing
successful
failed
5. Drift: No.
6. Decision: Refunds are separate financial records. Never overwrite the original payment to represent the entire refund history.


# TutorEarning:
1. lassification: Core financial Firestore document.
2. Firestore:
tutorEarnings/{earningId}
3. Relationships:
Payment
   +
Booking / MasterclassEnrollment
   +
Session outcome
   ↓
TutorEarning
   ↓
TutorPayout
4. Authority:
Backend: calculates and controls
Tutor: read-only
Admin: controlled adjustments
5. Status:
pending
available
processing
paid
reversed
6. Drift: No.
7. Decision: TutorEarning represents money owed to the tutor, not money the student paid. Commission, refunds, disputes and adjustments are accounted for here.


# TutorPayout:
1. Classification: Core financial Firestore document
2. Firestore:
tutorPayouts/{payoutId}
3. Relationships:
TutorEarning
      ↓
  TutorPayout
      ↓
Payment Provider
4. Authority:
Backend: creates/calculates payout
Payment provider: executes payout
Tutor: read-only
Admin: controlled intervention
5. Status:
pending
processing
paid
failed
reversed
6. Drift: No.
7. Decision: A payout can contain multiple earnings, allowing us to batch tutor payments efficiently instead of sending one transaction per tutoring session


# Cancellation:
1. Classification: Immutable Firestore event record
2. Firestore:
cancellations/{cancellationId}
3. Relationships:
Booking / MasterclassEnrollment
          ↓
     Cancellation
          ↓
        Refund
4. Authority:
Student/Tutor: can request cancellation
Backend: determines whether cancellation is allowed and applies policy
Admin: handles exceptions
5. Status: None — cancellation is an event, while the related Booking/Enrollment carries the current status.
6. Core data:
cancellationId
bookingId?
enrollmentId?
cancelledBy
reason
cancelledAt
refundAmount
refundId?
7. Drift: No.
8. Decision: Keep cancellation history immutable. Never lose who cancelled, when, and why.


# Reschedule:
1. Classification: Immutable Firestore event record
2. Firestore:
reschedules/{rescheduleId}
3. Relationships:
Booking
   ↓
Reschedule
   ↓
Availability
   ↓
New session time
4. Authority:
Student/Tutor: request reschedule
Backend: validates availability, permissions and policy
Admin: handles exceptions
5. Status:
requested
approved
rejected
cancelled
6. Drift: No.
7. Decision: Preserve the original booking time and record every reschedule as an immutable event. This gives us a complete audit trail.


# Review:
1. Classification: Core Firestore subcollection.
2. Firestore:
tutors/{tutorId}/reviews/{reviewId}
3. Relationships:
Completed TutoringSession
          ↓
        Review
          ↓
     TutorRating
4. Authority:
Student: creates their own review after an eligible session
Backend: validates eligibility, ownership and rating
Admin: moderation/removal
Tutor: can respond later, but cannot edit the student's review
5. Status:
published
hidden
removed
6. Drift: No authoritative storage. Optional cache for displayed reviews.
7. Decision: One completed session → one review. The review is the source of truth for tutor reputation.


# Masterclass:
1. Classification: Core Firestore document
2. Firestore:
masterclasses/{masterclassId}
3. Relationships:
Tutor
  ↓
Masterclass
  ├── subjectId
  ├── topicIds[]
  ├── examPaperId?
  ├── MasterclassSession  1:N
  └── MasterclassEnrollment 1:N
4. Authority:
Tutor: creates/manages masterclass content
Backend: validates tutor eligibility, pricing, capacity and curriculum references
Student: read-only + enroll
Admin: moderation
5. Status:
draft
published
full
in_progress
completed
cancelled
6. Drift: No authoritative storage. Optional cache for discovery/upcoming masterclasses.
7. Decision: Masterclass is the product/event, while MasterclassSession represents each actual occurrence.


# MasterclassSession:
1. Classification: Core Firestore document
2. Firestore:
masterclasses/{masterclassId}/sessions/{sessionId}
3. Relationships:
Masterclass
     ↓
MasterclassSession
     ├── Attendance
     └── VideoSession
4. Authority:
Tutor: limited session-management actions
Backend: schedule/status/attendance authority
Student: read-only + join when authorized
Admin: intervention
5. Status:
scheduled
live
completed
cancelled
6. Drift: No authoritative storage. Optional cache for enrolled students.
7. Decision: A masterclass can contain multiple sessions, allowing us to support multi-session exam preparation later without redesigning the entity.


# MasterclassEnrollment:
1. Classification: Core Firestore document
2. Firestore:
masterclassEnrollments/{enrollmentId}
3. Relationships:
Student
   ↓
MasterclassEnrollment
   ↓
Masterclass
   ↓
MasterclassSession 1:N
4. Authority:
Student: enroll/cancel according to policy
Backend: validates capacity, eligibility and payment
Tutor: read-only enrollment information
Admin: intervention
5. Status:
pending_payment
confirmed
cancelled
completed
no_show
refunded
6. Drift: Yes — cache the student's active/upcoming enrollments.
7. Decision: Enrollment represents the student's seat, not the masterclass itself. Capacity is enforced by the backend.

# VideoSession:
1. Classification: Core Firestore document
2. Firestore:
videoSessions/{videoSessionId}
Relationships:
TutoringSession ──────┐
                      ├── VideoSession
MasterclassSession ───┘
3. Authority:
Backend: creates/manages session access
Video provider: handles video infrastructure
Student/Tutor: join only when authorized
4. Status:
scheduled
live
ended
cancelled
5. Drift: No. Video session state must remain network-authoritative.
6. Decision: MathMatric owns authorization and session lifecycle; the video provider owns WebRTC/video transport and infrastructure


# VideoAccess:
1. Classification: Short-lived backend authorization record
2. Firestore:
videoSessions/{videoSessionId}/access/{userId}
3. Relationships:
Booking / Enrollment
        ↓
    VideoSession
        ↓
     VideoAccess
        ↓
 Temporary provider credentials
4. Authority:
Backend: creates/revokes access
Student/Tutor: request access
Video provider: validates issued credentials
5. Status:
pending
active
revoked
expired
6. Drift: No.
7. Decision: Never give users permanent room credentials. Access should be time-limited and session-specific.


# PaymentMethod:
1. Classification: Provider-linked Firestore document
2. Firestore:
students/{studentId}/paymentMethods/{paymentMethodId}
3. Relationships:
Student
   ↓
PaymentMethod
   ↓
Payment
4. Authority:
Student: adds/removes/selects payment methods
Payment provider: owns sensitive card/payment details
Backend: stores only safe provider references
Admin: No access to raw payment credentials
Status: None required for our domain model.
5. Core data:
id
provider
providerMethodId
type
brand?
last4?
isDefault
createdAt
6. Drift: No.
7. Decision: Never store card numbers, CVVs, PINs or sensitive payment credentials in MathMatric. Store only the payment provider's token/reference and display-safe metadata.


# Notification:
1. Classification: Core Firestore document
2. Firestore:
users/{userId}/notifications/{notificationId}
3. Relationships:
Booking / Payment / Session / Masterclass
        ↓
    Notification
        ↓
Student / Tutor
4. Authority:
Backend: creates notification
Student/Tutor: mark as read
Admin: limited moderation/debugging
5. Status:
unread
read
6. Core data:
id
type
title
body
data
createdAt
readAt?
7. Drift: Yes — cache notifications for the student's inbox/unread count.
8. Decision: Store the event notification in Firestore; FCM is the delivery mechanism, not the source of truth

# NotificationPreference:
1. Classification: Firestore document
2. Firestore:
users/{userId}/notificationPreferences/preferences
3. Relationships:
User
  ↓
NotificationPreference
  ↓
Notification delivery
3. Authority:
Student: controls own preferences
Backend: reads preferences when dispatching notifications
Tutor: controls their own preferences in the future tutor app
Status: None.
4. Core data:
bookingUpdates
sessionReminders
paymentUpdates
masterclassUpdates
reviewReminders
marketing
5. Drift: Yes — small local cache for immediate UI/preferences.
6. Decision: Preferences control delivery, not whether the underlying marketplace event/notification exists.


# Dispute:
1. Classification: Core Firestore document
2. Firestore:
disputes/{disputeId}
3. Relationships:
Booking
Payment
TutoringSession
        ↓
     Dispute
        ↓
     Resolution
4. Authority:
Student/Tutor: can raise a dispute
Backend: validates ownership and evidence
Admin/Support: investigates and resolves
Client: Cannot determine the final outcome
5. Status:
open
under_review
resolved
rejected
closed
6. Core data:
id
raisedBy
bookingId?
paymentId?
sessionId?
category
description
evidencePaths[]
resolution?
resolvedBy?
createdAt
resolvedAt?
7. Drift: No authoritative storage.
8. Decision: Disputes need an immutable evidence trail because they can affect refunds, tutor earnings, ratings and account trust.


# SupportCase:
1. Classification: Core Firestore document
2. Firestore:
supportCases/{caseId}
3. Relationships:
Student / Tutor
       ↓
  SupportCase
       ↓
Dispute / Booking / Payment
4. Authority:
Student/Tutor: create case and provide information
Backend: validates ownership/access
Support/Admin: manages and resolves
Client: Cannot resolve or alter administrative decisions
5. Status:
open
assigned
in_progress
resolved
closed
Core data:
id
openedBy
bookingId?
paymentId?
disputeId?
category
description
assignedTo?
resolution?
createdAt
closedAt?
6. Drift: No.
7. Decision: SupportCase is the human-support layer. Dispute is the formal marketplace/financial conflict; a support case can exist without a dispute.