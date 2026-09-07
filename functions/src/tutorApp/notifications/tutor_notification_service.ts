import {FieldValue,Timestamp,} from "firebase-admin/firestore";
import {db} from "../../shared/firebase";
import {TutorNotificationType,} from "./tutor_notification_types";
import {tutorNotificationDeliveryService,TutorNotificationDeliveryService,} from "./tutor_notification_delivery_service";

export interface TutorNotificationTarget {
  feature: string;
  resourceId: string;
  secondaryResourceId?: string;
}

export interface CreateTutorNotificationRequest {
  tutorId: string;
  type: TutorNotificationType;
  title: string;
  body: string;
  target: TutorNotificationTarget;
  expiresAt?: Date | null;
}

export class TutorNotificationService {
  constructor(
    private readonly firestore: FirebaseFirestore.Firestore,
    private readonly delivery: TutorNotificationDeliveryService,
  ) {}

  async create(
    request: CreateTutorNotificationRequest,
  ): Promise<string> {
    const notificationRef = this.firestore
      .collection("tutorNotifications")
      .doc();

    // Create and save notification
    await notificationRef.set({
      tutorId: request.tutorId,
      type: request.type,
      title: request.title,
      body: request.body,
      target: request.target,
      createdAt: FieldValue.serverTimestamp(),
      readAt: null,
      expiresAt: request.expiresAt
        ? Timestamp.fromDate(request.expiresAt)
        : null,
    });

    // Send push notification
    await this.delivery.send({
      tutorId: request.tutorId,
      title: request.title,
      body: request.body,
      data: {
        type: request.type,
        feature: request.target.feature,
        resourceId: request.target.resourceId,
        ...(request.target.secondaryResourceId
          ? {
              secondaryResourceId:
                request.target.secondaryResourceId,
            }
          : {}),
      },
    });

    return notificationRef.id;
  }
}

export const tutorNotificationService =new TutorNotificationService(db,tutorNotificationDeliveryService,);
