import { NavLink, Outlet } from "react-router-dom";

import ConnectionBanner from "@/features/system/ConnectionBanner";
import Card from "@/shared/ui/Card";
import StatusPill from "@/shared/ui/StatusPill";
import { useSessionStore } from "@/shared/state/sessionStore";

const navigationItems = [
  { to: "/", label: "Assistente" },
  { to: "/inventario", label: "Inventário" },
  { to: "/presentes", label: "Presentes" },
  { to: "/configuracoes", label: "Configurações" },
];

const getLocalStateMessage = (connectionState: string): string => {
  switch (connectionState) {
    case "connected":
      return "API local conectada";
    case "connecting":
      return "Conectando ao sidecar...";
    case "disconnected":
      return "Sidecar não está disponível";
    case "error":
      return "Erro ao conectar ao sidecar";
    default:
      return "Cliente pronto";
  }
};

const staticSummaryTiles = [
  {
    label: "Save ativo",
    value: "Nenhum save carregado",
    hint: "A leitura virá do sidecar .NET.",
  },
  {
    label: "Prioridade atual",
    value: "Aguardando seleção",
    hint: "As recomendações ainda não estão ajustadas.",
  },
];

function navClassName({ isActive }: { isActive: boolean }) {
  return [
    "rounded-2xl border px-4 py-3 text-sm font-medium transition",
    isActive
      ? "border-sky-400/50 bg-sky-400/10 text-sky-100 shadow-panel"
      : "border-white/10 bg-white/5 text-slate-200 hover:border-sky-300/30 hover:bg-white/10",
  ].join(" ");
}

export default function AppShell() {
  const connectionState = useSessionStore((state) => state.connectionState);

  return (
    <div className="min-h-screen px-4 py-4 text-slate-100 sm:px-6 lg:px-8">
      <div className="mx-auto flex min-h-[calc(100vh-2rem)] w-full max-w-[1440px] flex-col gap-4">
        <header className="rounded-[2rem] border border-white/10 bg-white/5 px-5 py-4 shadow-panel backdrop-blur-xl sm:px-6">
          <div className="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
            <div className="space-y-2">
              <div className="flex flex-wrap items-center gap-3">
                <h1 className="text-2xl font-semibold tracking-tight text-white sm:text-3xl">
                  FOM Oracle
                </h1>
                <StatusPill tone="info">Shell desktop ativo</StatusPill>
              </div>
              <p className="max-w-3xl text-sm text-slate-300 sm:text-base">
                Assistente estratégico local-first para ler o save do jogador, consolidar
                o contexto e preparar recomendações explicáveis.
              </p>
            </div>
            <ConnectionBanner />
          </div>
        </header>

        <div className="grid gap-4 xl:grid-cols-[280px_minmax(0,1fr)]">
          <aside className="rounded-[2rem] border border-white/10 bg-slate-950/55 p-4 shadow-panel backdrop-blur-xl">
            <div className="mb-4">
              <p className="text-xs uppercase tracking-[0.28em] text-slate-400">
                Navegação
              </p>
              <p className="mt-2 text-lg font-semibold text-white">
                Estrutura inicial da aplicação
              </p>
            </div>

            <nav className="space-y-2" aria-label="Navegação principal">
              {navigationItems.map((item) => (
                <NavLink key={item.to} to={item.to} className={navClassName} end={item.to === "/"}>
                  {item.label}
                </NavLink>
              ))}
            </nav>

            <div className="mt-5 grid gap-3">
              <Card className="border-white/10 bg-white/5">
                <p className="text-xs uppercase tracking-[0.24em] text-slate-400">
                  Sessão local
                </p>
                <p className="mt-2 text-sm text-slate-200">
                  {getLocalStateMessage(connectionState)}
                </p>
              </Card>
              <Card className="border-white/10 bg-white/5">
                <p className="text-xs uppercase tracking-[0.24em] text-slate-400">
                  Escopo da UI
                </p>
                <p className="mt-2 text-sm text-slate-200">
                  Apenas shell, fluxo e apresentação. Regras de negócio ficam no core .NET.
                </p>
              </Card>
            </div>
          </aside>

          <main className="space-y-4">
            <section className="grid gap-4 lg:grid-cols-3">
              {staticSummaryTiles.map((tile) => (
                <Card key={tile.label} className="border-white/10 bg-white/5">
                  <p className="text-xs uppercase tracking-[0.24em] text-slate-400">
                    {tile.label}
                  </p>
                  <p className="mt-3 text-lg font-semibold text-white">{tile.value}</p>
                  <p className="mt-2 text-sm text-slate-300">{tile.hint}</p>
                </Card>
              ))}
            </section>

            <section className="rounded-[2rem] border border-white/10 bg-slate-950/55 p-4 shadow-panel backdrop-blur-xl sm:p-6">
              <Outlet />
            </section>
          </main>
        </div>
      </div>
    </div>
  );
}
