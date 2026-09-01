# Django Vs Cloud Functions:
| Django           | Cloud Functions                   |
| ---------------- | --------------------------------- |
| `views.py`       | Function handlers                 |
| `serializers.py` | Validation schemas/functions      |
| `services.py`    | Business logic                    |
| Django ORM       | Firebase Admin SDK                |
| `urls.py`        | Function exports/endpoints        |
| Django server    | Google-managed serverless runtime |

# Think of this:
functions/
    src/
        index.ts
as roughly your Django:
backend/
    urls.py
    views.py

# Example backend endpoint using TypeScript:
Cloud Functions:
export const helloMathMatric = onRequest(
  (request, response) => {
    response.send("MathMatric backend is alive.");
  },
);
Django Endpoint:
def hello_mathmatric(request):
    return HttpResponse("MathMatric backend is alive.")
        
# Create Request Type: This is equivalent to a serializer in Django:
import { HttpsError, onCall } from "firebase-functions/https";

interface CreateBookingRequest {
    tutorId: String;
    scheduledAt: String;
    durationMinutes: number;
    teachingMode: "online"|"inPerson";
}

So the client sends:

{
  "tutorId": "tutor-123",
  "scheduledAt": "2026-09-15T15:00:00.000Z",
  "durationMinutes": 60,
  "teachingMode": "online"
}

# Transport Layer: The Callable
The exported callable:
export const createBooking = onCall(
  async (request) => {
    return handleCreateBooking(request);
  },
);

That's deliberate.
Think Django:
view()
  ↓
service()

The callable is your transport layer. handleCreateBooking() contains the actual application flow.