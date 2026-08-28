# ===================================================
# Entity 1: Tutor
# ===================================================
The Tutor is the marketplace identity, not the tutor's full profile.
Who is this tutor, and is this account currently allowed to participate in the marketplace?
# Core data
Tutor
├── id
├── userId                 → Firebase Auth UID
├── status
├── onlineEligible
├── inPersonEligible
├── createdAt
└── updatedAt

# ===================================================
# Entity 2: TutorProfile
# ===================================================
The public-facing identity students see when evaluating a tutor.
# Core data:
TutorProfile
├── tutorId
├── displayName
├── photoUrl
├── bio
├── experienceYears
├── languages
├── qualifications[]
├── profileStatus
├── createdAt
└── updatedAt
# Relationship:
Tutor
  │
  └── TutorProfile
        │
        ├── Qualifications
        ├── Offerings
        ├── Location
        └── Availability
# Ownership:
Tutor: editable profile information.
Backend: profileStatus, timestamps, verification badges/status.
Student: read-only.     


# ===================================================
# Entity 3: TutorOffering
# ===================================================
Defines exactly what the tutor offers and at what price.
# Core data:
TutorOffering
├── id
├── tutorId
├── subjectId
├── topicIds[]
├── teachingModes[]
├── durations[]
├── pricing
├── status
├── createdAt
└── updatedAt
# Ownership:
1. Tutor: creates/edits offering and prices.
2. Backend: validates:
valid curriculum IDs, allowed teaching modes,allowed durations,
pricing boundaries, tutor eligibility.
3. Student: read-only.


# ===================================================
# Entity 4: TutorLocation
# ===================================================
Enable nearby-tutor discovery without exposing the tutor's private address.
# Core data:
TutorLocation
├── tutorId
├── latitude
├── longitude
├── geohash
├── serviceRadiusKm
├── locationType
└── updatedAt
# locationType:
onlineOnly
inPerson
both
# Privacy:
Tutor provides a service location/area. The location stored for matching must not necessarily be the tutor's home address.
Students receive: "Approximately 4.2 km away".
# Dependencies:
Tutor
  ↓
TutorLocation
  ↓
Discovery
# Ownership:
Tutor: provides/updates service location and radius.
Backend: generates/maintains the geospatial index.
Student: provides location when requesting nearby tutors.
# Rule:
Do not query Firestore by raw latitude/longitude.
We'll use a geospatial indexing strategy (geohash or equivalent) to find candidate tutors, then calculate actual distance and apply the service-radius rules.


# ===================================================
# Entity 5: TutorAvailability
# ===================================================
Define when a tutor can accept tutoring sessions. Availability must use the tutor's timezone, while bookings store an absolute timestamp.
# Core entities: Rather than one giant TutorAvailability, separate it into two.
AvailabilityRule
├── id
├── tutorId
├── dayOfWeek
├── startTime
├── endTime
├── timezone
└── active
And:
AvailabilityException
├── id
├── tutorId
├── date
├── type
├── startTime
├── endTime
└── reason
# Dependencies:
Tutor
  +
TutorOffering
  ↓
Availability
  ↓
Slot Selection
  ↓
Booking
# Ownership
Tutor: manages rules/exceptions.
Backend: validates and calculates availability.
Student: read-only.


# ===================================================
# Entity 6: BookableSlot
# ===================================================
It's a calculated domain object. This tutor can accept this exact session at this exact time.
# Data:
BookableSlot
├── tutorId
├── offeringId
├── startAt
├── endAt
├── duration
└── teachingMode
# Created from:
Availability Rules
      +
Exceptions
      +
Existing Bookings
      +
Offering Duration
      ↓
BookableSlot
# Dependencies:
TutorOffering + TutorAvailability + Existing Bookings
                    ↓
                BookableSlot
                    ↓
                  Booking
Do not create millions of slot documents.
Calculate slots when needed and use the booking system as the authoritative source of reservations.


# ===================================================
# Entity 7: Booking
# ===================================================
Represents the student's formal reservation with a tutor.
# Core data:
Booking
├── id
├── studentId
├── tutorId
├── offeringId
├── topicId
├── startAt
├── endAt
├── duration
├── teachingMode
├── price
├── currency
├── status
├── createdAt
└── updatedAt
# Status:
Keep the lifecycle explicit:
requested
pending_payment
confirmed
in_progress
completed
cancelled
rejected
expired
no_show
# Booking snapshot
This is critical. The booking stores the agreed terms at the moment of booking. If the tutor later changes their price to R450, the existing booking remains R350.
# Authority:
The client can request:
1. Create booking
2. Cancel booking
3. Reschedule booking
# Dependencies:
Student
Tutor
Offering
Availability
BookableSlot
        ↓
     Booking
        ↓
 ┌──────┼────────┐
 ↓      ↓        ↓
Payment Session Review


# ===================================================
# Entity 8: TutoringSession
# ===================================================
Represents the actual lesson, separate from the reservation.
# Core data:
TutoringSession
├── id
├── bookingId
├── scheduledStartAt
├── scheduledEndAt
├── actualStartedAt
├── actualEndedAt
├── status
├── studentAttendance
├── tutorAttendance
└── completedAt
# Status:
scheduled
in_progress
completed
cancelled
no_show
# Example:
Booking
confirmed
   ↓
Tutor doesn't arrive
   ↓
Session
no_show
# Dependencies:
Booking
   ↓
TutoringSession
   ↓
Payment settlement
Review eligibility
Tutoring history
# Authority:
Session state and attendance should be controlled by the backend, using defined rules; not arbitrary client writes.


# ===================================================
# Entity 9: Payment
# ===================================================
Track the financial transaction for a booking. (Payment ≠ TutorEarning.z)
# Core data:
Payment
├── id
├── bookingId
├── studentId
├── amount
├── currency
├── status
├── provider
├── providerTransactionId
├── paidAt
└── createdAt
# Status:
pending
processing
successful
failed
refunded
partially_refunded
# Payment Provider, not Flutter:
Payment status is never controlled by Flutter:
Student App
    ↓
Payment Provider
    ↓
Webhook (The webhook is what tells MathMatric: The money actuallymoved.)
    ↓
Trusted Backend
    ↓
Payment status
# Dependencies
Booking
   ↓
Payment
   ↓
Booking confirmation
   ↓
Session completion
   ↓
Tutor settlement

# ===================================================
# Entity 10: Notification
# ===================================================
Record important marketplace events for the student (and eventually the tutor). Notification ≠ FCM message. Notification is our persistent application record. FCM is simply the delivery mechanism.
# Core data:
Notification
├── id
├── recipientId
├── type
├── title
├── body
├── data
├── readAt
└── createdAt
# Data can contain references such as:
bookingId
sessionId
paymentId
# Examples:
BOOKING_CONFIRMED
PAYMENT_SUCCESSFUL
SESSION_REMINDER
SESSION_STARTING
BOOKING_CANCELLED
REFUND_PROCESSED
REVIEW_AVAILABLE
# Flow:
Marketplace Event
      ↓
Backend
      ↓
Notification
      ↓
FCM Push
      ↓
Student
# Authority:
The backend creates notifications.


# ===================================================
# Entity 11: Review
# ===================================================
Create a trusted reputation record after a genuine tutoring session.
# Core data:
Review
├── id
├── bookingId
├── sessionId
├── studentId
├── tutorId
├── rating
├── comment
├── status
└── createdAt
# Rules:
A review is valid only when:
Booking belongs to student
        ↓
Session completed
        ↓
No existing review
        ↓
Review created
# Status:
published
hidden
removed
# Dependencies:
Booking
    ↓
TutoringSession
    ↓
Review
    ↓
Tutor reputation
# Authority:
Student can submit the review.
Backend determines:
eligibility
ownership
valid rating range
duplicate prevention
publication/removal
aggregate rating
# Product-wise:
I actually like the idea for MathMatric.
After a great session:
⭐ Rate your tutor
“How was your session?”
Leave a tip (optional)


# ===================================================
# Entity 12: MasterClass
# ===================================================
This is our group tutoring product, separate from one-on-one bookings. This entity represents a tutor-led session that multiple students can enroll in.
# Core data:
Masterclass
├── id
├── tutorId
├── title
├── description
├── subjectId
├── topicIds[]
├── examPaperId? 
├── teachingMode
├── startAt
├── endAt
├── capacity
├── price
├── status
└── createdAt
# Example:
June Paper 1 Masterclass

Mathematics
Paper 1
Functions + Algebra

Saturday
10:00–12:00

20 seats
R150
# Dependencies:
Tutor
  +
TutorOffering
  +
Availability
  +
MathMatric Curriculum
  +
Exam Papers
      ↓
  Masterclass
      ↓
 Enrollment


# ===================================================
# Entity 13: MasterclassEnrollment
# ===================================================
Represents a student's seat in a specific masterclass.
Masterclass
      ↓
MasterclassEnrollment
      ↓
Student
# Core data:
MasterclassEnrollment
├── id
├── masterclassId
├── studentId
├── price
├── status
├── enrolledAt
└── cancelledAt?
# Status:
pending_payment
confirmed
cancelled
attended
no_show
refunded
# Price agreed at enrollment.
If the masterclass later changes from R150 → R200:
Existing students remain at R150.
# Capacity:
The backend controls:
capacity = 20
confirmed enrollments = 20
        ↓
FULL
# Dependencies:
Masterclass
     ↓
Enrollment
     ↓
Payment
     ↓
Attendance
# Masterclass:
Student → Enrollment → Masterclass → Tutor


# ===================================================
# Entity 14: VideoSession 
# ===================================================
Represent the digital classroom where a tutoring session actually takes place.
It supports both:
1-on-1 tutoring
Masterclasses
# Core data:
VideoSession
├── id
├── sessionType
├── sessionId
├── provider
├── providerSessionId
├── status
├── startedAt
├── endedAt
└── recordingId?
# Relationship:
TutoringSession ──────┐
                      ├── VideoSession
MasterclassSession ───┘
# Critical architecture:
1. MathMatric owns:
who is allowed in
when they can enter
session lifecycle
access permissions
recording entitlement

2. The video provider handles:
WebRTC/video transport
audio
camera
screen sharing
streaming infrastructure
recording infrastructure
# Security:
Students should never receive permanent/public video URLs or provider credentials.
Instead:
Student
   ↓
MathMatric
   ↓
"Is this student allowed?"
   ↓
Temporary video access
   ↓
Video provider
# Dependencies:
Booking → TutoringSession → VideoSession
Masterclass → Enrollment → MasterclassSession → VideoSession


# ===================================================
# Entity 15: MasterclassSession 
# ===================================================
The MasterclassSession is the actual scheduled class.
Masterclass
     ↓
MasterclassSession
     ↓
VideoSession
# Core data:
MasterclassSession
├── id
├── masterclassId
├── startAt
├── endAt
├── status
├── capacity
└── createdAt
# Example:
Masterclass:
"June Paper 1 Preparation"
        ↓
Session 1:
Saturday 10:00–12:00

Session 2:
Sunday 10:00–12:00
# Status:
scheduled
live
completed
cancelled
Dependencies
Masterclass
    ↓
MasterclassSession
    ↓
Enrollment
    ↓
VideoSession
# Important:
Enrollment should ultimately be tied to the masterclass, while attendance is tied to the specific session.


# ===================================================
# Entity 16: Attendance
# ===================================================
Record whether the student and tutor actually participated in a session.
# Core data:
Attendance
├── id
├── sessionId
├── userId
├── role
├── status
├── joinedAt
├── leftAt
└── duration
# Status:
present
late
absent
no_show
# Relationship:
For one-on-one:
TutoringSession
   ├── Student Attendance
   └── Tutor Attendance
For a masterclass:
MasterclassSession
   ├── Student Attendance × many
   └── Tutor Attendance
# Dependencies:
TutoringSession / MasterclassSession
              ↓
          Attendance
# Security:
Attendance should be derived primarily from actual video-session participation, with backend rules handling edge cases. The student should not manually status = present.
# Notes:
For example:
Joined for 47 minutes
       ↓
Present

versus:

Never joined
       ↓
No-show

Attendance feeds:
session completion
no-show decisions
tutor reliability
refunds
payment settlement
review eligibility
tutoring history


# ===================================================
# Entity 17: TutorVerification
# ===================================================
Store the sensitive evidence and verification state that determines what a tutor is allowed to do.
# Core data:
TutorVerification
├── tutorId
├── identityStatus
├── qualificationStatus
├── backgroundCheckStatus
├── addressStatus
├── onlineEligible
├── inPersonEligible
├── submittedAt
├── verifiedAt
└── updatedAt
# Verification states:
For each verification type:
not_submitted
pending
verified
rejected
expired
# Dependencies:
Tutor
  ↓
TutorVerification
  ↓
Booking eligibility


# ===================================================
# Entity 18: TutorQualification
# ===================================================
Represents a tutor's professional/academic qualifications, separately from the tutor's general profile.
# Core data:
TutorQualification
├── id
├── tutorId
├── qualificationType
├── institution
├── fieldOfStudy
├── year
├── documentPath?
├── verificationStatus
└── verifiedAt?
# Example:
BSc
Mathematics
Wits University
2024
✓ Verified
# Contained in Tutor:
Tutor
 └── Qualifications
      ├── BSc Mathematics
      ├── PGCE
      └── Teaching Certificate
# Dependencies:
Tutor
  ↓
TutorQualification
  ↓
TutorVerification  


# ===================================================
# Entity 19: TutorSearchCriteria
# ===================================================
Represents what the student is looking for, rather than storing anything about the tutor.
# Core data:
TutorSearchCriteria
├── topicIds[]
├── dateTime?
├── duration?
├── teachingMode?
├── latitude?
├── longitude?
├── maxDistanceKm?
├── minRating?
├── maxPrice?
└── sortBy?
# Example:
Topic: Quadratic Functions
Date: Tomorrow
Time: 15:00
Duration: 60 min
Mode: In-person
Location: Student location
Max distance: 15 km
Max price: R350
# Dependencies:
Uses:
Tutor
Profile
Offerings
Location
Availability
Curriculum


# ===================================================
# Entity 20: TutorMatch
# ===================================================
Represents a candidate tutor returned by the matching engine.
This is a calculated result, not permanent marketplace data.
# Core data:
TutorMatch
├── tutorId
├── matchScore
├── distanceKm?
├── topicMatch
├── availabilityMatch
├── priceMatch
└── reasons[]
# Example:
Tutor: Thabo M.
Match: 94%

✓ Teaches Quadratic Functions
✓ Available at 15:00
✓ 3.8 km away
✓ 4.9 ★
✓ Within budget
# Dependencies:
SearchCriteria
      +
Tutor Profile
      +
Offering
      +
Location
      +
Availability
      +
Reputation
      ↓
TutorMatch


# ===================================================
# Entity 21: TutorRating
# ===================================================
A calculated reputation summary for fast display and ranking.
It is derived from Review records.
# Core data:
TutorRating
├── tutorId
├── averageRating
├── reviewCount
├── ratingDistribution
└── updatedAt
# Example:
4.8 ★
127 reviews

5 ★  → 109
4 ★  → 12
3 ★  → 4
2 ★  → 1
1 ★  → 1
# Relationship:
         Reviews
            ↓
        TutorRating
            ↓
 Discovery + Tutor Profile
# Dependencies:
Review
  ↓
TutorRating
  ↓
TutorMatch 


# ===================================================
# Entity 22: TutorEarning
# ===================================================
Track what the tutor is entitled to receive from completed tutoring.
# Core data:
TutorEarning
├── id
├── tutorId
├── bookingId?
├── masterclassEnrollmentId?
├── grossAmount
├── platformFee
├── adjustments
├── netAmount
├── status
├── currency
├── availableAt
├── paidOutAt?
└── createdAt
# Status:
pending
available
processing
paid
reversed
# Example:
Student paid             R350
Platform commission      R52.50
Tutor earning            R297.50
# Dependencies:
Payment
   +
Booking / Enrollment
   +
Session outcome
   ↓
TutorEarning
   ↓
Tutor payout


# ===================================================
# Entity 23: Refund
# ===================================================
Track money returned to a student without modifying the original Payment.
# Core data:
Refund
├── id
├── paymentId
├── bookingId?
├── enrollmentId?
├── amount
├── reason
├── status
├── providerRefundId
├── requestedAt
├── processedAt?
└── createdAt
# Status:
requested
processing
successful
failed
# Flow:
Cancellation / dispute
        ↓
Refund eligibility check
        ↓
Backend
        ↓
Payment provider
        ↓
Webhook
        ↓
Refund confirmed
# Dependencies:
Payment
   ↓
Refund
   ↓
TutorEarning adjustment


# ===================================================
# Entity 24: NotificationPreference
# ===================================================
Control which marketplace notifications the student wants to receive and how.
# Core data:
NotificationPreference
├── userId
├── bookingUpdates
├── sessionReminders
├── paymentUpdates
├── masterclassUpdates
├── reviewReminders
└── marketing
# Example:
Booking updates       ✓
Session reminders     ✓
Payment updates       ✓
Masterclasses         ✓
Review reminders      ✓
Marketing             ✗
# For example:
Booking confirmed
      ↓
Notification created ✓
      ↓
Preference checked
      ↓
Push notification → yes/no
# Dependencies:
User
  ↓
NotificationPreference
  ↓
Notification delivery


# ===================================================
# Entity 25: VideoAccess
# ===================================================
Control who can enter a MathMatric video session and when.
This is an authorization record, not the video itself.
# Core data:
VideoAccess
├── id
├── videoSessionId
├── userId
├── role
├── accessStatus
├── validFrom
├── validUntil
└── createdAt
# Flow:
Student
   ↓
"Join session"
   ↓
MathMatric backend
   ↓
Check VideoAccess
   ↓
Generate temporary provider access
   ↓
Enter classroom
# Status:
pending
active
revoked
expired
# Dependencies:
Booking / Enrollment
        ↓
TutoringSession / MasterclassSession
        ↓
VideoSession
        ↓
VideoAccess
        ↓
Video Provider


# ===================================================
# Entity 26: TutorServiceArea
# ===================================================
We need this because TutorLocation and where a tutor is willing to travel are different things.
# Purpose:
Define where a tutor is willing to provide in-person tutoring.
# Core data:
TutorServiceArea
├── id
├── tutorId
├── centerLatitude
├── centerLongitude
├── radiusKm
├── active
└── updatedAt
# Example:
Tutor location
      ↓
Welkom
      ↓
Service radius
      ↓
15 km

A student 8 km away → potentially eligible.
A student 30 km away → not eligible.

TutorLocation = where their service is anchored
TutorServiceArea = where they are willing to travel

# ===============================================
# Step 27: PaymentMethod
# ===============================================
# Core data:
PaymentMethod
├── id
├── studentId
├── provider
├── providerMethodId
├── type
├── last4
├── brand
├── isDefault
└── createdAt
# Status:
No lifecycle status needed for MVP; isDefault is enough. Provider handles the actual payment-method validity.
# Dependencies:
Student → PaymentMethod → Payment


# ===============================================
# Step 28: TutorPayout
# ===============================================
# Core data:
TutorPayout
├── id
├── tutorId
├── earningIds[]
├── amount
├── currency
├── provider
├── providerPayoutId
├── status
├── initiatedAt
└── completedAt?
# Status:
pending
processing
paid
failed
reversed
# Dependencies:
TutorEarning
      ↓
TutorPayout


# ===============================================
# Step 29: Cancellation
# ===============================================
# Core data:
Cancellation
├── id
├── bookingId?
├── enrollmentId?
├── cancelledBy
├── reason
├── cancelledAt
├── refundAmount
└── refundId?
# Status: 
None needed. The cancellation itself is an immutable event.
# Dependencies:
Booking / Enrollment
        ↓
   Cancellation
        ↓
      Refund


# ===============================================      
# Step30: Reschedule
# ===============================================
# Core data:
Reschedule
├── id
├── bookingId
├── requestedBy
├── previousStartAt
├── previousEndAt
├── newStartAt
├── newEndAt
├── reason
└── createdAt
# Status:
requested
approved
rejected
cancelled
# Dependencies:
Booking
   ↓
Reschedule
   ↓
Availability
   ↓
New booking time


# ===============================================
# Step 31: Dispute
# ===============================================
# Core data:
Dispute
├── id
├── bookingId?
├── paymentId?
├── sessionId?
├── raisedBy
├── category
├── description
├── evidencePaths[]
├── resolution
├── resolvedBy?
├── createdAt
└── resolvedAt?
# Status:
open
under_review
resolved
rejected
closed
# Dependencies:
Booking
Payment
Session
   ↓
Dispute
   ↓
Resolution


# ===============================================
# Step 32: FavouriteTutor
# ===============================================
# Core data:
FavouriteTutor
├── id
├── studentId
├── tutorId
└── createdAt
# Status: 
None.
The record exists = favourite.
Record removed = no longer favourite.
# Dependencies:
Student → FavouriteTutor → Tutor

# ===============================================
# Step 33: TutorReliability
# ===============================================
# Core data:
TutorReliability
├── tutorId
├── completedSessions
├── cancellationRate
├── noShowRate
├── attendanceRate
├── punctualityScore
└── updatedAt
# Status:
 None. This is derived data.
# Dependencies:
Bookings
Sessions
Attendance
Cancellations
      ↓
TutorReliability
      ↓
TutorMatch


# ===============================================
# Step 34: SupportCase
# ===============================================
# Core data:
SupportCase
├── id
├── openedBy
├── bookingId?
├── paymentId?
├── disputeId?
├── category
├── description
├── status
├── assignedTo?
├── resolution?
├── createdAt
└── closedAt?
# Status:
open
assigned
in_progress
resolved
closed
# Dependencies:
Student / Tutor
       ↓
 SupportCase
       ↓
Dispute / Booking / Payment
