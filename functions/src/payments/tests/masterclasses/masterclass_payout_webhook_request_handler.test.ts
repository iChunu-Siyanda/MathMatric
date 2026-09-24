import { describe, expect, it, vi } from "vitest";
import { Request, Response } from "express";
import { PayoutProvider, PayoutWebhookEvent } from "../../provider/payout_provider";
import { MasterclassPayoutWebhookHandler } from "../../webhooks/masterclass_payout_webhook_handler";
import { handleMasterclassPayoutWebhookRequest } from "../../webhooks/masterclass_payout_webhook_request_handler";

describe("handleMasterclassPayoutWebhookRequest", () => {
  const event: PayoutWebhookEvent = {
    providerPayoutId: "mock-payout-masterclass-1_student-1",
    payoutId: "masterclass-payout-masterclass-1_student-1",
    status: "succeeded",
    failureReason: null,
    eventId: "event-1",
    occurredAt: new Date("2026-02-01T15:00:00.000Z"),
  };

  function createRequest(
    overrides: Partial<Request> = {},
  ): Request {
    return {
      method: "POST",
      headers: { "x-payout-signature": "valid-signature" },
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
    const payoutProvider = {
      name: "mock",
      verifyWebhook: vi.fn().mockReturnValue(event),
    } as unknown as PayoutProvider;

    const masterclassPayoutWebhookHandler = {
      handle: vi.fn().mockResolvedValue({
        statusCode: 200,
        message: "Webhook processed.",
      }),
    } as unknown as MasterclassPayoutWebhookHandler;

    return { payoutProvider, masterclassPayoutWebhookHandler };
  }

  it("processes a valid POST webhook", async () => {
    const { payoutProvider, masterclassPayoutWebhookHandler } =
      createDependencies();

    const request = createRequest();
    const response = createResponse();

    await handleMasterclassPayoutWebhookRequest(
      request,
      response,
      payoutProvider,
      masterclassPayoutWebhookHandler,
    );

    expect(payoutProvider.verifyWebhook).toHaveBeenCalledWith(
      request.rawBody!.toString("utf8"),
      "valid-signature",
    );

    expect(masterclassPayoutWebhookHandler.handle).toHaveBeenCalledWith(
      event,
    );

    expect(response.status).toHaveBeenCalledWith(200);
    expect(response.send).toHaveBeenCalledWith("Webhook processed.");
  });

  it("rejects non-POST requests", async () => {
    const { payoutProvider, masterclassPayoutWebhookHandler } =
      createDependencies();

    const request = createRequest({ method: "GET" });
    const response = createResponse();

    await handleMasterclassPayoutWebhookRequest(
      request,
      response,
      payoutProvider,
      masterclassPayoutWebhookHandler,
    );

    expect(response.status).toHaveBeenCalledWith(405);
    expect(payoutProvider.verifyWebhook).not.toHaveBeenCalled();
  });

  it("rejects a missing webhook signature", async () => {
    const { payoutProvider, masterclassPayoutWebhookHandler } =
      createDependencies();

    const request = createRequest({ headers: {} });
    const response = createResponse();

    await handleMasterclassPayoutWebhookRequest(
      request,
      response,
      payoutProvider,
      masterclassPayoutWebhookHandler,
    );

    expect(response.status).toHaveBeenCalledWith(401);
    expect(response.send).toHaveBeenCalledWith(
      "Missing webhook signature.",
    );
  });

  it("rejects a missing webhook body", async () => {
    const { payoutProvider, masterclassPayoutWebhookHandler } =
      createDependencies();

    const request = createRequest({ rawBody: undefined });
    const response = createResponse();

    await handleMasterclassPayoutWebhookRequest(
      request,
      response,
      payoutProvider,
      masterclassPayoutWebhookHandler,
    );

    expect(response.status).toHaveBeenCalledWith(400);
    expect(response.send).toHaveBeenCalledWith("Missing webhook body.");
  });

  it("returns 500 when webhook verification fails", async () => {
    const { payoutProvider, masterclassPayoutWebhookHandler } =
      createDependencies();

    vi.mocked(payoutProvider.verifyWebhook).mockImplementation(() => {
      throw new Error("Invalid webhook signature.");
    });

    const response = createResponse();

    await handleMasterclassPayoutWebhookRequest(
      createRequest(),
      response,
      payoutProvider,
      masterclassPayoutWebhookHandler,
    );

    expect(response.status).toHaveBeenCalledWith(500);
    expect(masterclassPayoutWebhookHandler.handle).not.toHaveBeenCalled();
  });

  it("returns 500 when the webhook handler fails", async () => {
    const { payoutProvider, masterclassPayoutWebhookHandler } =
      createDependencies();

    vi.mocked(masterclassPayoutWebhookHandler.handle).mockRejectedValue(
      new Error("Masterclass payout processing failed."),
    );

    const response = createResponse();

    await handleMasterclassPayoutWebhookRequest(
      createRequest(),
      response,
      payoutProvider,
      masterclassPayoutWebhookHandler,
    );

    expect(response.status).toHaveBeenCalledWith(500);
  });
});
