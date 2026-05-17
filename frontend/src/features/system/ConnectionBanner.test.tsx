import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { act, render, screen, waitFor } from "@testing-library/react";
import { afterEach, expect, it, vi } from "vitest";

import ConnectionBanner from "@/features/system/ConnectionBanner";
import { useSessionStore } from "@/shared/state/sessionStore";

function renderConnectionBanner() {
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: {
        retry: false,
        refetchOnWindowFocus: false,
      },
    },
  });

  render(
    <QueryClientProvider client={queryClient}>
      <ConnectionBanner disableAutoRefetch />
    </QueryClientProvider>,
  );

  return queryClient;
}

afterEach(() => {
  vi.unstubAllEnvs();
  vi.restoreAllMocks();
  useSessionStore.getState().reset();
});

it("mostra desconectado quando o health check falha depois de uma conexão anterior", async () => {
  vi.stubEnv("VITE_FOM_ORACLE_API_BASE_URL", "http://localhost:5000");

  vi.spyOn(globalThis, "fetch")
    .mockResolvedValueOnce({
      ok: true,
      json: async () => ({
        status: "ok",
        appVersion: "0.1.0",
        coreVersion: "0.1.0",
      }),
    } as Response)
    .mockRejectedValueOnce(new Error("Network failure"))
    .mockRejectedValue(new Error("Network failure"));

  const queryClient = renderConnectionBanner();

  await waitFor(() => {
    expect(screen.getByText("Conectado")).toBeInTheDocument();
  });

  await act(async () => {
    await queryClient.refetchQueries({ queryKey: ["health", "http://localhost:5000"] });
  });

  await waitFor(() => {
    expect(screen.getByText("Desconectado")).toBeInTheDocument();
  });

  queryClient.clear();
});
