import { describe, expect, it, vi } from "vitest";
import { Request, Response } from "express";
import { PaymentProvider, PaymentWebhookEvent } from "../../provider/payment_provider";
import { MasterclassPaymentWebhookHandler } from "../../webhooks/masterclass_payment_webhook_handler";
import { handleMasterclassPaymentWebhookRequest } from "../../webhooks/masterclass_payment_webhook_request_handler";

describe("handleMasterclassPaymentWebhookRequest", () => {
  const event: PaymentWebhookEvent = {
    providerPaymentId: "mock-masterclass-1_student-1",
    bookingId: "masterclass-1_student-1",
    status: "paid",
    failureReason: null,
    eventId: "event-1",
    occurredAt: new Date("2026-02-01T15:00:00.000Z"),
  };

  function createRequest(
    overrides: Partial<Request> = {},
  ): Request {
    return {
      method: "POST",
      headers: { "x-payment-signature": "valid-signature" },
      rawBody: Buffer.from(JSON.stringify(event)),
      ...overrides,
    } as unknown as Request;
  }

  function createResponse(): Response {
    const response = { status: vi.fn(), send: vi.fn() };
    response.status.mockReturnValue(response);
    return response as unknown as Response;
  }

  function createDependencies() {
    const paymentProvider = {
      name: "mock",
      verifyWebhook: vi.fn().mockReturnValue(event),
    } as unknown as PaymentProvider;

    const masterclassPaymentWebhookHandler = {
      handle: vi.fn().mockResolvedValue({
        statusCode: 200,
        message: "Webhook processed.",
      }),
    } as unknown as MasterclassPaymentWebhookHandler;

    return { paymentProvider, masterclassPaymentWebhookHandler };
  }

  it("processes a valid POST webhook", async () => {
    const { paymentProvider, masterclassPaymentWebhookHandler } =
      createDependencies();

    const request = createRequest();
    const response = createResponse();

    await handleMasterclassPaymentWebhookRequest(
      request,
      response,
      paymentProvider,
      masterclassPaymentWebhookHandler,
    );

    expect(paymentProvider.verifyWebhook).toHaveBeenCalledWith(
      request.rawBody!.toString("utf8"),
      "valid-signature",
    );

    expect(masterclassPaymentWebhookHandler.handle).toHaveBeenCalledWith(
      event,
    );

    expect(response.status).toHaveBeenCalledWith(200);
    expect(response.send).toHaveBeenCalledWith("Webhook processed.");
  });

  it("rejects non-POST requests", async () => {
    const { paymentProvider, masterclassPaymentWebhookHandler } =
      createDependencies();

    const request = createRequest({ method: "GET" });
    const response = createResponse();

    await handleMasterclassPaymentWebhookRequest(
      request,
      response,
      paymentProvider,
      masterclassPaymentWebhookHandler,
    );

    expect(response.status).toHaveBeenCalledWith(405);
    expect(response.send).toHaveBeenCalledWith("Method Not Allowed");
    expect(paymentProvider.verifyWebhook).not.toHaveBeenCalled();
  });

  it("rejects a missing webhook signature", async () => {
    const { paymentProvider, masterclassPaymentWebhookHandler } =
      createDependencies();

    const request = createRequest({ headers: {} });
    const response = createResponse();

    await handleMasterclassPaymentWebhookRequest(
      request,
      response,
      paymentProvider,
      masterclassPaymentWebhookHandler,
    );

    expect(response.status).toHaveBeenCalledWith(401);
    expect(response.send).toHaveBeenCalledWith(
      "Missing webhook signature.",
    );
  });

  it("rejects a missing webhook body", async () => {
    const { paymentProvider, masterclassPaymentWebhookHandler } =
      createDependencies();

    const request = createRequest({ rawBody: undefined });
    const response = createResponse();

    await handleMasterclassPaymentWebhookRequest(
      request,
      response,
      paymentProvider,
      masterclassPaymentWebhookHandler,
    );

    expect(response.status).toHaveBeenCalledWith(400);
    expect(response.send).toHaveBeenCalledWith("Missing webhook body.");
  });

  it("returns 500 when webhook verification fails", async () => {
    const { paymentProvider, masterclassPaymentWebhookHandler } =
      createDependencies();

    vi.mocked(paymentProvider.verifyWebhook).mockImplementation(() => {
      throw new Error("Invalid webhook signature.");
    });

    const response = createResponse();

    await handleMasterclassPaymentWebhookRequest(
      createRequest(),
      response,
      paymentProvider,
      masterclassPaymentWebhookHandler,
    );

    expect(response.status).toHaveBeenCalledWith(500);
    expect(response.send).toHaveBeenCalledWith(
      "Webhook processing failed.",
    );

    expect(masterclassPaymentWebhookHandler.handle).not.toHaveBeenCalled();
  });

  it("returns 500 when the webhook handler fails", async () => {
    const { paymentProvider, masterclassPaymentWebhookHandler } =
      createDependencies();

    vi.mocked(masterclassPaymentWebhookHandler.handle).mockRejectedValue(
      new Error("Masterclass payment processing failed."),
    );

    const response = createResponse();

    await handleMasterclassPaymentWebhookRequest(
      createRequest(),
      response,
      paymentProvider,
      masterclassPaymentWebhookHandler,
    );

    expect(response.status).toHaveBeenCalledWith(500);
    expect(response.send).toHaveBeenCalledWith(
      "Webhook processing failed.",
    );
  });
});
