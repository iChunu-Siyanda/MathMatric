import {
  FieldValue,
  Timestamp,
} from "firebase-admin/firestore";

import { db } from "../shared/firebase";
import {
  getStudentAccount,
} from "../students/student_account_service";
import {
  NotificationType,
} from "./notification_types";
import {
  notificationDeliveryService,
  NotificationDeliveryService,
} from "./notification_delivery_service";

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

  async create(
    request: CreateNotificationRequest,
  ): Promise<string> {
    // ------------------------------------------------
    // Resolve student account:
    // ------------------------------------------------
    // studentAccounts/{studentId} is the authoritative
    // source for studentType.

    const studentAccount = await getStudentAccount(
      request.studentId,
      this.firestore,
    );

    const studentType = studentAccount.studentType;

    // ------------------------------------------------
    // Create notification:
    // ------------------------------------------------

    const notificationRef = this.firestore
      .collection("notifications")
      .doc();

    await notificationRef.set({
      studentType,
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

    // ------------------------------------------------
    // Send push notification:
    // ------------------------------------------------

    await this.delivery.send({
      studentId: request.studentId,
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

export const notificationService = new NotificationService(
  db,
  notificationDeliveryService,
);
