import { afterEach, expect, it, vi } from "vitest";

import { ApiRequestError, ApiUnavailableError, getHealth } from "@/shared/api/localApi";

afterEach(() => {
  vi.unstubAllEnvs();
  vi.restoreAllMocks();
});

it("retorna erro de indisponibilidade quando a URL base não existe", async () => {
  vi.stubEnv("VITE_FOM_ORACLE_API_BASE_URL", "");

  await expect(getHealth()).rejects.toThrow(ApiUnavailableError);
});

it("retorna HealthResponse em caso de sucesso", async () => {
  vi.stubEnv("VITE_FOM_ORACLE_API_BASE_URL", "http://localhost:5000");

  const mockResponse = { status: "ok", version: "0.1.0" };
  const fetchSpy = vi.spyOn(globalThis, "fetch").mockResolvedValue({
    ok: true,
    json: async () => mockResponse,
  } as Response);

  const result = await getHealth();

  expect(fetchSpy).toHaveBeenCalledWith("http://localhost:5000/api/v1/health", expect.anything());
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

  const abortError = new Error("Aborted");
  abortError.name = "AbortError";
  vi.spyOn(globalThis, "fetch").mockRejectedValue(abortError);

  const controller = new AbortController();
  await expect(getHealth(controller.signal)).rejects.toThrow();
  try {
    await getHealth(controller.signal);
  } catch (error) {
    expect(error).toBeInstanceOf(Error);
    expect((error as Error).name).toBe("AbortError");
  }
});
