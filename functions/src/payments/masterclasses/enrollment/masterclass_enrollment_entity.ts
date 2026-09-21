export const MasterclassEnrollmentStatus = {
  pendingPayment: "pending_payment",
  confirmed: "confirmed",
  cancelled: "cancelled",
  refunded: "refunded",
} as const;

export type MasterclassEnrollmentStatus =
  typeof MasterclassEnrollmentStatus[keyof typeof MasterclassEnrollmentStatus];

export interface MasterclassEnrollment {
  id: string;
  masterclassId: string;
  studentId: string;
  tutorId: string;

  /*
   * Price locked at enrollment time. Independent of any
   * later change to Masterclass.priceCents.
   */
  priceCents: number;
  currency: "ZAR";

  status: MasterclassEnrollmentStatus;

  /*
   * Set the moment a signed download URL is issued to the
   * student. This is the refund-eligibility gate AND the
   * masterclass payout trigger (alongside the 7-day window,
   * whichever comes first).
   */
  downloadedAt: Date | null;

  enrolledAt: Date;
  updatedAt: Date;
  cancelledAt: Date | null;
  refundedAt: Date | null;
}

// Storage: masterclassEnrollments/{enrollmentId}
