Student: "I need help with quadratic functions tomorrow at 15:00." Or "I have a June examination of paper 1."

# MathMatrics Turns Student Intent To:
        Student intent
            ↓
        Topic identification
            ↓
        Session requirements
            ↓
        Tutor candidate discovery
            ↓
        Qualification/topic matching
            ↓
        Availability matching
            ↓
        Location / teaching-mode matching
            ↓
        Price filtering
            ↓
        Tutor ranking
            ↓
        Student chooses
            ↓
        Secure booking
            ↓
        Payment
            ↓
        Confirmation
            ↓
        Session
            ↓
        Completion
            ↓
        Review


# Tutor Marketplace: Feature Build Order.

| #      | Feature                           | What it needs                                                            | Depends on                                    |
| **1**  | **Tutor Identity & Verification** | Tutor account, verification status, public/private profile boundary                                                 | Firebase Auth                                 |
| **2**  | **Tutor Profile**                 | Bio, photo, qualifications, experience, subjects, topics, teaching modes | Tutor Identity                                |
| **3**  | **Tutor Offerings & Pricing**     | What they teach, curriculum/topic coverage, session types, pricing       | Tutor Profile                                 |
| **4**  | **Tutor Location**                | Online/in-person, approximate location, service radius, geospatial index | Tutor Profile                                 |
| **5**  | **Tutor Availability**            | Recurring hours, exceptions, timezone, availability rules                | Tutor Profile                                 |
| **6**  | **Tutor Discovery/Search**        | Search, filters, ranking, location, topic matching                       | Profile + Offerings + Location + Availability |
| **7**  | **Tutor Profile View**            | Public tutor information, rating, pricing, availability                  | Discovery + Profile                           |
| **8**  | **Slot/Session Selection**        | Date, time, duration, topic, teaching mode                               | Availability + Offerings                      |
| **9**  | **Booking**                       | Validation, conflict prevention, reservation, lifecycle                  | Slot Selection + Identity                     |
| **10** | **My Bookings**                   | Upcoming, active, completed, cancelled bookings                          | Booking                                       |
| **11** | **Session Lifecycle**             | Start, attendance, completion, no-show                                   | Booking                                       |
| **12** | **Payments**                      | Payment, confirmation, refunds, commission                               | Booking                                       |
| **13** | **Notifications**                 | Booking/payment/session events                                           | Booking + Payments + Session                  |
| **14** | **Reviews & Ratings**             | Eligibility, review, aggregation, moderation                             | Completed Session                             |
| **15** | **Student Tutoring History**      | History, statistics, tutor relationships                                 | Bookings + Sessions + Reviews                 |

# ================================================
# Step 1: Tutor Identity & Verification
# ================================================
Establishes who the tutor is and whether they are trusted/allowed to operate on the marketplace.
# Requires:
Firebase Auth account
Tutor role/capability
Tutor profile status
Identity verification status (The client can never make itself verified.)
Qualification verification status
Account suspension/deactivation status
# Core states:
pending_verification
verified
suspended
rejected
deactivated
# Dependencies/Flow:
Firebase Authentication
        ↓
Tutor Identity
        ↓
Verification
        ↓
Tutor Profile
# Ownership
Tutor app/backend: submits information.
Backend/admin: verifies and changes verification status.
Student app: only reads the public verified state.
# Tutor verification:
Online tutoring:                        In-person tutoring:
Identity document / ID verification     Everything from online-tutoring.
NSC verification                        Background/safety check
Basic account verification              Additional identity/address verification. Any other legally required safety checks


# ==================================================
# Step 2: Tutor Profile
# ==================================================
Gives students enough trusted, relevant information to decide whether a tutor is suitable.
# Required:
Display name, Profile photo, Short bio, Teaching experience, Qualifications, Subjects, Topics,Teaching modes, Languages, 
Online/in-person eligibility, Pricing summary,Rating/review count, Verification badges, Profile status
# Public Data Vs Private Data:
Tutor
├── Public Profile (Students only see this section)
│   ├── name
│   ├── photo
│   ├── bio
│   ├── experience
│   ├── qualifications
│   └── teaching information
│
└── Private Data
    ├── ID
    ├── verification documents
    ├── background check
    ├── exact address
    └── financial information
# Dependencies/Flow:
Tutor Identity & Verification
              ↓
        Tutor Profile
              ↓
       Tutor Offerings
# Ownership
Tutor: provides/updates profile information. Their subjects/topics must come from MathMatric's curriculum taxonomy.(This will be crucial for mapping)
Backend: controls verification badges, eligibility, rating, review count, profile status.
Student: read-only.


# ==================================================
# Step 3 — Tutor Offerings & Pricing
# ==================================================
Defines what a tutor sells. This is separate from who they are.
# Required:
Subjects taught (Grade 12 Mathematics for now), Topics taught (from MathMatric curriculum),
Teaching modes: Online / In-person / Both, Session durations (30, 60, 90, 120 min), Price per duration
Service radius for in-person.
# Pricing:
Tutor-controlled pricing within MathMatric's marketplace guardrails, with reputation and market data influencing recommended pricing, not automatically determining it.
# Product decisions (lock these):
1. Topics come from the MathMatric curriculum (no free-text topics).
2. A tutor can teach only selected topics, not automatically the whole syllabus.
3. Prices are tied to duration + teaching mode (e.g. 60-minute online vs 60-minute in-person can have different prices).
# Edge cases:
1. Tutor disables in-person → only online appears in search.
2. Tutor changes prices → existing bookings keep the old agreed price (price snapshot).
# Flow:
Tutor Profile
      ↓
Tutor Offerings
      ↓
Discovery & Booking
# Ownership
Tutor: sets offerings, prices, durations, teaching modes.
Backend: validates pricing rules and stores the authoritative offering.
Student: read-only.


# ==================================================
# Step 4: Tutor Location
# ==================================================
Enables nearby-tutor discovery for in-person tutoring while protecting everyone's privacy.
# Required:
Teaching mode: online, inPerson, or both. Tutor approximate location. Geohash for discovery.
Service radius. Student location when searching nearby. Distance calculation. Location permission handling.
# Flow:
Student location
      ↓
Geospatial search
      ↓
Candidate tutors
      ↓
Actual distance calculation
      ↓
Tutor service-radius check (Do not reveal the Tutor's exact location, just show that the Tutor is within the service-radius.)
      ↓
Available in-person tutors
# Dependencies:
Tutor Profile
      ↓
Teaching Mode
      ↓
Tutor Location
      ↓
Discovery
# Ownership:
Tutor: chooses whether to offer in-person and their service radius.
Student: controls whether/where location is used for discovery.
Backend: handles geospatial matching and distance validation.


# =======================================================
# Step 5: Tutor Availability
# =======================================================
Know when a tutor can actually accept a session, without relying on manual calendars or creating double bookings.
# Required:
Tutor timezone. Recurring weekly availability. Specific-date availability/overrides. Blocked periods.
Minimum/maximum session duration. Existing bookings. Buffer time between sessions, if tutor wants it.
# Dependencies:
Tutor Profile
      ↓
Tutor Offerings
      ↓
Tutor Availability
      ↓
Slot Selection
# Flow:
Recurring availability
        +
Date exceptions
        +
Existing bookings
        +
Session duration
        +
Buffer
        ↓
Availability Engine
        ↓
Bookable slots
# Availability is not a promise that a booking will succeed:
A slot can disappear between viewing and booking. The backend must re-check it during booking.
Use recurring availability + date-specific overrides rather than tutors manually creating every available slot.
# Ownership:
Tutor: sets their availability.
Backend: calculates/validates actual availability.
Student: only sees bookable slots.

# =====================================================
# Step 6: Tutor Discovery & Matching.
# =====================================================
Finds the best suitable tutors, not simply a list of tutors.
# Student provides:
Topic/problem
Date/time
Duration
Online/in-person
Location (if in-person)
Optional price/rating preferences
# System considers:
Topic expertise + Availability + Teaching mode + Distance + Price + Rating + Experience + Verification + Tutor reliability
Then ranks the candidates.
# Flow:
Student request
      ↓
Find eligible tutors
      ↓
Topic match
      ↓
Availability match
      ↓
Location/mode match
      ↓
Price/rating filters
      ↓
Ranking
      ↓
Best tutors
# Dependencies: (Separate Filtering='Who Qualifies' From Ranking='Who is the best'.).
Tutor Profile + Offerings + Location + Availability
                      ↓
            Discovery & Matching
# Security. Only tutors who are:
1. Verified
2. Active
3. Eligible for the requested teaching mode
Should enter the candidate pool.


# =====================================================
# Step 7: Tutor Profile View
# =====================================================
Gives the student enough trusted information to confidently choose a tutor.
# Student sees:
Profile photo + name
Verification badges
Bio
Qualifications
Experience
Topics taught
Online/in-person options
Pricing
Rating + review count
Relevant reviews
Distance/service area
Available times
# Student should NOT see:
ID documents
Exact home address
Private contact details
Internal verification information
Payment/banking information
# Dependencies:
Tutor Profile
     +
Offerings
     +
Location
     +
Availability
     +
Reviews
     ↓
Tutor Profile View
# Rule:
The profile shows the tutor's current information, but once the student proceeds to with the booking, we create a booking snapshot of the agreed:
1. tutor identity
2. offering/topic
3. duration
4. teaching mode
5. price
So later profile changes don't alter historical bookings. Theb create the receipt.


# ===========================================================
# Step 8: Slot & Session Selection
# ===========================================================
Turn a tutor's availability into a specific tutoring appointment the student wants to book.
# Student selects:
Topic
Teaching mode
Date
Available start time
Duration
# Example:
Quadratic Functions
Online
Tomorrow
15:00
60 minutes
R250
# System validates:
Tutor teaches that topic
Tutor supports that teaching mode
Slot is currently available
Requested duration is supported
Price matches the selected offering
In-person distance/location is valid
# Dependencies:
Tutor Profile + Offerings + Availability + Student requirements
                            ↓
                        Slot Selection
                            ↓
                          Booking
# Selecting a slot ≠ booking it:
The slot is only reserved when the backend successfully creates the booking. 
This protects us against two students selecting the same slot.
# Student sees only valid combinations.
For example, don't show:
90 minutes
if that tutor only offers 60-minute sessions.
The UI should make invalid states difficult or impossible to create.                       


# ============================================================
# Step 9: Booking
# ============================================================
Creates a trusted, conflict-free commitment between student and tutor.
The client never controls booking status, price, payment status, or tutor earnings. The backend does.
# Student submits:
Tutor, Topic, Date/time, Duration, Teaching mode.
Then backend determines/validates:
1. Tutor eligibility
2. Topic eligibility
3. Availability
4. Price
5. Student eligibility
6. Cancellation policy
7. Conflicts
# Flow:
Student confirms
      ↓
Backend validates EVERYTHING
      ↓
Atomic reservation
      ↓
Booking created
      ↓
Payment process
      ↓
Confirmed
# Dependencies:
Identity + Offering + Availability + Slot Selection
                    ↓
                  Booking
# Concurrency: Never two confirmed bookings.
If two students attempt the same slot:
Student A ──→ SUCCESS
Student B ──→ SLOT NO LONGER AVAILABLE


# ===========================================
# Step 10: My Bookings
# ===========================================
Gives the student one reliable place to see everything they have scheduled or completed.
# Student sees:
1. Upcoming:
Tutor
Topic
Date/time
Duration
Teaching mode
Price
Booking status
2. Past:
Completed
Cancelled
No-show
# UI:
Upcoming
Past
Cancelled
# Actions In The Students Booked Session:
Depending on status/policy: The student can request an action, but the backend decides whether it's allowed.
View booking
Cancel session
Reschedule session
Join online session
View meeting/location information
Review completed session
# Drift:
This is a good candidate for local caching.The student can still see their upcoming/past bookings without internet, but anything requiring a state change must reconnect to the backend.


# ===========================================
# Step 11:
# ===========================================
Tracks what happens after a booking exist.
# Lifecycle:
CONFIRMED
    ↓
IN_PROGRESS
    ↓
COMPLETED
# Exception paths:
CONFIRMED
 ├── CANCELLED
 ├── NO_SHOW
 └── EXPIRED
# Required:
Scheduled start/end
Session start
Session completion
Student attendance
Tutor attendance
No-show handling
Session notes later, if needed
# Dependencies:
Booking
   ↓
Session
   ↓
Payment settlement
   ↓
Review eligibility
# The client shouldn't just mark a session completed:
We need trusted rules around:
who can start
who can mark attendance
when completion becomes possible
what happens if one party doesn't attend


# ============================================
# Step 12: Payments
# ============================================
Safely collect the student's payment and settle the tutor's earnings.
# Required:
Payment provider
Payment initiation
Payment status
Booking ↔ payment relationship
Platform commission
Tutor earnings
Refunds
Payment webhook
Payment/audit records
# Flow:
Booking created
      ↓
Payment initiated
      ↓
Provider processes payment
      ↓
Webhook → Backend
      ↓
Payment confirmed
      ↓
Booking confirmed
      ↓
Session completed
      ↓
Tutor earnings settled
# Authority:
1. Never trust Flutter for:
paid
amount paid
refund
commission
tutor earnings
2. Those come from the payment provider + trusted backend.
# Dependencies"
Booking
   ↓
Payment
   ↓
Session completion
   ↓
Settlement
# MathMatric Payment Model:
Student pays MathMatric → MathMatric holds/records the transaction → tutor receives their earnings minus commission.
Investigate the appropriate South African payment/payout architecture and regulatory implications before implementation.


# =============================================
# Step 13: Notifications
# =============================================
Keep the student and tutor informed about important marketplace events.
# Required:
Push notifications via Firebase Cloud Messaging
In-app notification history
Notification preferences
Device/token management
Deep links to the relevant booking/session
Scheduled reminders
# Important marketplace events:
Booking confirmed
Payment successful
Booking cancelled
Booking rescheduled
Session reminder
Session starting
Session completed
Review available
Refund processed
# Flow:
Marketplace event
      ↓
Backend
      ↓
Create notification record
      ↓
Send FCM push
      ↓
Student/Tutor
# Dependencies:
Booking
Payment
Session
Review
    ↓
Notifications
# Rule:
Treat notifications as event-driven infrastructure(backend), not as a feature where every BLoC manually sends notifications.


# =============================================
# Step 15: Reviews & Ratings
# =============================================
Create a trusted reputation system for tutors.
# Student can review only when:
Student
  ↓
Owns booking
  ↓
Booking completed
  ↓
Session occurred
  ↓
Hasn't already reviewed it
  ↓
Eligible
# Review contains:
Rating
Written review
Booking/session reference
Tutor reference
Student reference
Created timestamp
# Backend controls: (Reviews must automatically be rquested after the tutoring session.)
Eligibility
One review per session
Rating validity
Review ownership
Rating aggregation
Moderation/removal
# Dependencies:
Booking
   ↓
Completed Session
   ↓
Review
   ↓
Tutor Rating


# =================================================================
# Step 15: Student Tutoring History & Integration with MathMatric.
# =================================================================
Connect tutoring activity back into the student's MathMatric learning journey.
# Student sees:
Upcoming tutoring
Past sessions
Tutors they've worked with
Topics studied
Spending history
Ratings/reviews given
# Completed tutoring session can be associated with MathMatric's existing curriculum:
Student struggles with
Quadratic Functions
       ↓
Tutor session
       ↓
Session completed
       ↓
MathMatric progress
       ↓
Mastery can be reassessed
# Dependencies:
Bookings
   ↓
Sessions
   ↓
Student Progress
# Data ownership: Don't merge these responsibilities.
The marketplace records: "The student received tutoring on Quadratic Functions."
The existing learning system remains responsible for: "How well does the student understand Quadratic Functions?"
# Rule:
Link tutoring sessions to existing MathMatric topicIds, rather than creating a second tutoring-specific topic system.
That gives us one curriculum truth across the entire platform.


# ==============================================
# Step 16: Masterclasses
# ==============================================
Do not force it into Tutor Discovery or Tutor Offerings. It is a distinct marketplace product.
# Masterclasses will reuse several earlier systems:
Masterclasses
├── Tutors & verification
├── Tutor expertise
├── Curriculum / Exam Papers
├── Availability
├── Booking
├── Payments
├── Notifications
└── Reviews
# It deserves its own feature
1. A normal tutoring booking is:
Student → Tutor → Private session
2. A masterclass is:
Tutor → Specific learning objective → Multiple students → Scheduled session
# Example:
June Paper 1 Masterclass
Functions • Algebra • Calculus
Saturday 10:00
20 students
R150
# This introduces new concepts:
group capacity
minimum/maximum participants
masterclass schedule
enrollment
potentially waiting lists
group pricing
tutor-led sessions
exam/paper targeting

# ==========================================================
# Step 17: Video Tutoring & Live Masterclass Infrastructure
# ==========================================================
1-to-1 video provider
masterclass streaming provider
recording
screen sharing
whiteboard
chat
access control
session recording retention
moderation/safety
# MathMatric Video Model:
              MathMatric Video
                    │
          ┌─────────┴─────────┐
          │                   │
     1-on-1 Lessons      Masterclasses
          │                   │
     Real-time video      Live streaming
          │                   │
          └─────────┬─────────┘
                    ↓
             Video Provider
