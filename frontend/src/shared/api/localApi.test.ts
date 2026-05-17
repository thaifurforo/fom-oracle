import { afterEach, describe, expect, it, vi } from "vitest";

import { ApiRequestError, ApiUnavailableError, getHealth } from "@/shared/api/localApi";

afterEach(() => {
  vi.unstubAllEnvs();
  vi.restoreAllMocks();
});

describe("localApi", () => {
  it("retorna erro de indisponibilidade quando a URL base não existe", async () => {
    vi.stubEnv("VITE_FOM_ORACLE_API_BASE_URL", "");

    await expect(getHealth()).rejects.toThrow(ApiUnavailableError);
  });

  it("retorna HealthResponse em caso de sucesso", async () => {
    vi.stubEnv("VITE_FOM_ORACLE_API_BASE_URL", "http://localhost:5000");

    const mockResponse = { status: "ok", appVersion: "0.1.0", coreVersion: "0.1.0" };
    const fetchSpy = vi.spyOn(globalThis, "fetch").mockResolvedValue({
      ok: true,
      json: async () => mockResponse,
    } as Response);

    const result = await getHealth();

    expect(fetchSpy).toHaveBeenCalledWith(
      "http://localhost:5000/api/v1/health",
      expect.objectContaining({
        method: "GET",
        headers: expect.any(Object),
      }),
    );
    expect(result).toEqual(mockResponse);
  });

  it("retorna ApiUnavailableError em caso de falha de rede", async () => {
    vi.stubEnv("VITE_FOM_ORACLE_API_BASE_URL", "http://localhost:5000");

    vi.spyOn(globalThis, "fetch").mockRejectedValue(new Error("Network failure"));

    await expect(getHealth()).rejects.toThrow(ApiUnavailableError);
  });

  it("retorna ApiRequestError quando a resposta não é OK", async () => {
    vi.stubEnv("VITE_FOM_ORACLE_API_BASE_URL", "http://localhost:5000");

    vi.spyOn(globalThis, "fetch").mockResolvedValue({
      ok: false,
      status: 500,
    } as Response);

    await expect(getHealth()).rejects.toThrow(ApiRequestError);
  });

  it("relança AbortError quando o sinal é abortado", async () => {
    vi.stubEnv("VITE_FOM_ORACLE_API_BASE_URL", "http://localhost:5000");

    const controller = new AbortController();

    // Simula o comportamento do fetch quando o sinal é abortado
    vi.spyOn(globalThis, "fetch").mockImplementation(async (_, options) => {
      if (options?.signal?.aborted) {
        throw new DOMException("The user aborted a request.", "AbortError");
      }
      return new Response();
    });

    controller.abort();

    const promise = getHealth(controller.signal);
    await expect(promise).rejects.toHaveProperty("name", "AbortError");
  });
});
