import { afterEach, expect, it, vi } from "vitest";

import { ApiUnavailableError, getHealth } from "@/shared/api/localApi";

afterEach(() => {
  vi.unstubAllEnvs();
});

it("retorna erro de indisponibilidade quando a URL base não existe", async () => {
  vi.stubEnv("VITE_FOM_ORACLE_API_BASE_URL", "");

  await expect(getHealth()).rejects.toBeInstanceOf(ApiUnavailableError);
});
