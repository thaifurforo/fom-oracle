import { getApiBaseUrl } from "@/shared/config/env";
import type { HealthResponse } from "@/shared/api/contracts";

export class ApiUnavailableError extends Error {
  constructor(message: string, options?: ErrorOptions) {
    super(message, options);
    this.name = "ApiUnavailableError";
  }
}

export class ApiRequestError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "ApiRequestError";
  }
}

function isAbortError(error: unknown): boolean {
  return (
    typeof error === "object" &&
    error !== null &&
    "name" in error &&
    error.name === "AbortError"
  );
}

export async function getHealth(signal?: AbortSignal): Promise<HealthResponse> {
  const baseUrl = getApiBaseUrl();

  if (!baseUrl) {
    throw new ApiUnavailableError("URL base da API local não configurada.");
  }

  let response: Response;

  try {
    response = await fetch(`${baseUrl}/api/v1/health`, {
      method: "GET",
      headers: {
        Accept: "application/json",
      },
      signal,
    });
  } catch (error: unknown) {
    if (isAbortError(error)) {
      throw error;
    }
    throw new ApiUnavailableError("API local indisponível.", { cause: error });
  }

  if (!response.ok) {
    throw new ApiRequestError(`Falha ao consultar health: ${response.status}`);
  }

  return (await response.json()) as HealthResponse;
}
