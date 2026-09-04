Booking Lifecycle:
PENDING
   │
   ├── Student cancels ──────→ CANCELLED
   │
   ├── Tutor declines ───────→ DECLINED
   │
   └── Tutor accepts ────────→ CONFIRMED
                                  │
                                  ├── Student cancels → CANCELLED
                                  ├── Tutor cancels   → CANCELLED
                                  │
                                  └── Session occurs → COMPLETED
                                  