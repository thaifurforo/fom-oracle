import { getApiBaseUrl } from "@/shared/config/env";
import type { HealthResponse } from "@/shared/api/contracts";

export class ApiUnavailableError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "ApiUnavailableError";
  }
}

export class ApiRequestError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "ApiRequestError";
  }
}

export async function getHealth(signal?: AbortSignal): Promise<HealthResponse> {
  const baseUrl = getApiBaseUrl();

  if (!baseUrl) {
    throw new ApiUnavailableError("Base URL da API local nao configurada.");
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
  } catch {
    throw new ApiUnavailableError("API local indisponivel.");
  }

  if (!response.ok) {
    throw new ApiRequestError(`Falha ao consultar health: ${response.status}`);
  }

  return (await response.json()) as HealthResponse;
}
