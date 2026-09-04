import {FieldValue,Timestamp,} from "firebase-admin/firestore";
import { db } from "../shared/firebase";
import {NotificationType,} from "./notification_types";
import { notificationDeliveryService, NotificationDeliveryService } from "./notification_delivery_service";

export interface NotificationTarget {
  feature: string;
  resourceId: string;
  secondaryResourceId?: string;
}

export interface CreateNotificationRequest {
  studentId: string;
  type: NotificationType;
  title: string;
  body: string;
  target: NotificationTarget;
  expiresAt?: Date | null;
}

export class NotificationService {
  constructor(
    private readonly firestore: FirebaseFirestore.Firestore,
    private readonly delivery: NotificationDeliveryService,
  ) {}

  async create(request: CreateNotificationRequest,): Promise<string> {
    const notificationRef = this.firestore.collection("notifications").doc();

    // Create and save motification:
    await notificationRef.set({ //since set() is asyncronous
      studentId: request.studentId,
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

    // Send push
    await this.delivery.send({
      studentId: request.studentId,
      title: request.title,
      body: request.body,
      data: {
        type: request.type,
        feature: request.target.feature,
        resourceId: request.target.resourceId,
        ...(request.target.secondaryResourceId
          ? {secondaryResourceId: request.target.secondaryResourceId,}
          : {}),
      },
    });

    return notificationRef.id;
  }
}

export const notificationService = new NotificationService(db, notificationDeliveryService);
