import { render, screen } from "@testing-library/react";
import { HashRouter } from "react-router-dom";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { describe, expect, it } from "vitest";

import App from "@/app/App";

describe("App shell", () => {
  it("mostra o shell do assistente estrategico e a home inicial", () => {
    const queryClient = new QueryClient();

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
});
