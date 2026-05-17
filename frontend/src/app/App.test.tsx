import { render, screen } from "@testing-library/react";
import { HashRouter } from "react-router-dom";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { afterEach, describe, expect, it, vi } from "vitest";

import App from "@/app/App";
import { useSessionStore } from "@/shared/state/sessionStore";

afterEach(() => {
  vi.unstubAllEnvs();
  useSessionStore.getState().reset();
});

describe("App shell", () => {
  afterEach(() => {
    window.location.hash = "";
  });

  it("mostra o shell do assistente estratégico e a home inicial", () => {
    vi.stubEnv("VITE_FOM_ORACLE_API_BASE_URL", "");

    const queryClient = new QueryClient({
      defaultOptions: {
        queries: {
          retry: false,
        },
      },
    });

    render(
      <QueryClientProvider client={queryClient}>
        <HashRouter>
          <App />
        </HashRouter>
      </QueryClientProvider>,
    );

    expect(
      screen.getByRole("heading", { name: /FOM Oracle/i }),
    ).toBeInTheDocument();
    expect(
      screen.getByRole("heading", {
        name: /O shell já abre pronto para interpretar o contexto do save\./i,
      }),
    ).toBeInTheDocument();
    expect(
      screen.getByRole("heading", { name: "Resumo do save" }),
    ).toBeInTheDocument();
  });

  it("mostra fallback para rota desconhecida", () => {
    vi.stubEnv("VITE_FOM_ORACLE_API_BASE_URL", "");
    window.location.hash = "#/rota-invalida";

    const queryClient = new QueryClient({
      defaultOptions: {
        queries: {
          retry: false,
        },
      },
    });

    render(
      <QueryClientProvider client={queryClient}>
        <HashRouter>
          <App />
        </HashRouter>
      </QueryClientProvider>,
    );

    expect(screen.getByRole("heading", { name: "Página não encontrada" })).toBeInTheDocument();
    expect(
      screen.getByText(/Não encontramos essa rota\. Use a navegação lateral para voltar ao assistente\./i),
    ).toBeInTheDocument();
  });
});
