import { useEffect } from "react";
import { useQuery } from "@tanstack/react-query";

import { ApiUnavailableError, getHealth } from "@/shared/api/localApi";
import { useSessionStore } from "@/shared/state/sessionStore";
import StatusPill from "@/shared/ui/StatusPill";

function connectionTone(
  status: "idle" | "connecting" | "connected" | "disconnected" | "error",
) {
  switch (status) {
    case "connected":
      return "success";
    case "connecting":
      return "info";
    case "disconnected":
      return "warning";
    case "error":
      return "danger";
    default:
      return "neutral";
  }
}

export default function ConnectionBanner() {
  const setConnectionState = useSessionStore((state) => state.setConnectionState);

  const healthQuery = useQuery({
    queryKey: ["health"],
    queryFn: () => getHealth(),
    retry: false,
    refetchOnWindowFocus: false,
    staleTime: 30_000,
  });

  const status =
    healthQuery.isFetching && !healthQuery.data
      ? "connecting"
      : healthQuery.isSuccess
        ? "connected"
        : healthQuery.isError
          ? healthQuery.error instanceof ApiUnavailableError
            ? "disconnected"
            : "error"
          : "idle";

  useEffect(() => {
    setConnectionState(status);
  }, [setConnectionState, status]);

  const message =
    status === "connected"
      ? "Sidecar local acessivel"
      : status === "connecting"
        ? "Verificando a API local"
        : status === "disconnected"
          ? "API local nao configurada ou indisponivel"
          : status === "error"
            ? "Falha ao consultar a API local"
            : "Estado inicial";

  return (
    <div className="flex flex-wrap items-center gap-3 rounded-2xl border border-white/8 bg-slate-950/45 px-4 py-3">
      <StatusPill tone={connectionTone(status)}>
        {status === "connected"
          ? "Conectado"
          : status === "connecting"
            ? "Conectando"
            : status === "disconnected"
              ? "Desconectado"
              : status === "error"
                ? "Erro"
                : "Aguardando"}
      </StatusPill>
      <div className="min-w-0">
        <p className="text-sm font-medium text-white">{message}</p>
        <p className="text-xs text-slate-400">
          A UI segue operando mesmo quando o sidecar ainda nao esta disponivel.
        </p>
      </div>
    </div>
  );
}
