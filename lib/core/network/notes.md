ConnectivityService
    ↓
"Network connection changed"

InternetChecker
    ↓
"Internet actually works"

SyncManager
    ↓
"Should I sync right now?"

SyncCoordinator
    ↓
"Sync these repositories"

Repositories
    ↓
"Here's how I synchronize my data"


We're not checking Firestore to see whether the user is online.

That matters for your Firebase-cost requirement.

The only Firestore operations should happen when SyncManager has decided that an actual sync is warranted.
