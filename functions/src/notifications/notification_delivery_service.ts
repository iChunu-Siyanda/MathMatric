import { getMessaging, Messaging } from "firebase-admin/messaging";
import { db } from "../shared/firebase";

export interface NotificationDeliveryRequest {
  studentId: string;
  title: string;
  body: string;
  data: Record<string, string>;
}

export class NotificationDeliveryService {
  constructor(
    private readonly firestore: FirebaseFirestore.Firestore,
    private readonly messaging: Messaging,
  ) {}

  async send(request: NotificationDeliveryRequest,): Promise<void> {
    const devicesSnapshot = await this.firestore
      .collection("students")
      .doc(request.studentId)
      .collection("devices")
      .get();

    if (devicesSnapshot.empty) {return;}

    const tokens = devicesSnapshot.docs
        .map((doc) => doc.data().token)
        .filter((token): token is string => typeof token === "string" && token.length > 0,);

    if (tokens.length === 0) {return;}

    const response = await this.messaging.sendEachForMulticast({
      tokens,
      notification: {
        title: request.title,
        body: request.body,
      },
      data: request.data,
    });

    const invalidDeviceRefs = response.responses.map((result, index) => ({
        result,
        device: devicesSnapshot.docs[index],
      }))
      .filter(
        ({ result }) => !result.success &&
          (
            result.error?.code === "messaging/registration-token-not-registered" ||
            result.error?.code === "messaging/invalid-registration-token"
          ),
      )
      .map(({ device }) => device.ref);

    if (invalidDeviceRefs.length === 0) {return;}

    const batch = this.firestore.batch();

    for (const deviceRef of invalidDeviceRefs) {
      batch.delete(deviceRef); // delete invalid token
    }

    await batch.commit();
  }
}

export const notificationDeliveryService = new NotificationDeliveryService(db,getMessaging(),);
