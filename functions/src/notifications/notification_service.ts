import {FieldValue,Timestamp,} from "firebase-admin/firestore";
import { db } from "../shared/firebase";
import {NotificationType,} from "./notification_types";

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
  ) {}

  async create(request: CreateNotificationRequest,): Promise<string> {
    const notificationRef = this.firestore.collection("notifications").doc();

    notificationRef.set({
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

    return notificationRef.id;
  }
}

export const notificationService = new NotificationService(db);
