                         MATHMATRIC
                             │
              ┌──────────────┴──────────────┐
              │                             │
       LEARNING PLATFORM              TUTOR MARKETPLACE
              │                             │
      Curriculum / Progress         Discovery / Matching
      Questions / Exams             Availability
      Study Sessions                Booking
              │                     Payments
              │                     Reviews
              │                     Notifications
              │                             │
              └──────────────┬──────────────┘
                             │
                       SHARED IDENTITY
                       Firebase Auth
                             │
                    ┌────────┴────────┐
                    │                 │
              STUDENT APP         TUTOR APP
              Flutter             Flutter/Web?
                    │                 │
                    └────────┬────────┘
                             │
                       MARKETPLACE
                         BACKEND
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
    Firestore          Cloud Functions       Firebase Storage
        │                    │                    │
        │               Business logic           │
        │               Transactions             │
        │               Notifications             │
        │               Payments                  │
        │               Matching                  │
        │
        └────────────── Firebase Cloud Messaging
        

# The major boundaries:
CURRICULUM
    ↓
STUDENTS ─────────── TUTORS
    │                   │
    │                   │
    └──── BOOKING ──────┘
             │
             ↓
          SESSION
             │
       ┌─────┴─────┐
       ↓           ↓
    PAYMENT    VIDEO
       │
       ↓
   SETTLEMENT    
