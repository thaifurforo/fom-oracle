import type { RouteObject } from "react-router-dom";

import AppShell from "@/app/layout/AppShell";
import ComingSoonPage from "@/features/coming-soon/ComingSoonPage";
import HomePage from "@/features/home/HomePage";

export const appRoutes: RouteObject[] = [
  {
    path: "/",
    element: <AppShell />,
    children: [
      {
        index: true,
        element: <HomePage />,
      },
      {
        path: "inventario",
        element: (
          <ComingSoonPage
            title="Inventário completo"
            description="Esta tela vai organizar mochila, baús e usos recomendados por item."
          />
        ),
      },
      {
        path: "presentes",
        element: (
          <ComingSoonPage
            title="Presentes de NPCs"
            description="Esta tela vai reunir preferências, disponibilidade e racional de presente."
          />
        ),
      },
      {
        path: "configuracoes",
        element: (
          <ComingSoonPage
            title="Configurações"
            description="Esta tela vai concentrar preferências locais, restauração e ajustes do shell."
          />
        ),
      },
    ],
  },
];
