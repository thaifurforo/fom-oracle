import { useEffect } from "react";
import { type UseQueryResult, useQuery } from "@tanstack/react-query";

import { ApiUnavailableError, getHealth } from "@/shared/api/localApi";
import type { HealthResponse } from "@/shared/api/contracts";
import { getApiBaseUrl } from "@/shared/config/env";
import type { ConnectionState } from "@/shared/state/sessionStore";
import { useSessionStore } from "@/shared/state/sessionStore";
import StatusPill from "@/shared/ui/StatusPill";

type BannerTone = "neutral" | "info" | "success" | "warning" | "danger";

type ConnectionBannerView = {
  message: string;
  pillLabel: string;
  tone: BannerTone;
};

type HealthQueryState = UseQueryResult<HealthResponse, Error>;

function deriveConnectionState(healthQuery: HealthQueryState, baseUrl: string | null): ConnectionState {
  if (!baseUrl) {
    return "disconnected";
  }

  if (healthQuery.isFetching && !healthQuery.data) {
    return "connecting";
  }

  if (healthQuery.isError || healthQuery.isRefetchError) {
    return healthQuery.error instanceof ApiUnavailableError ? "disconnected" : "error";
  }

  if (healthQuery.isSuccess) {
    return "connected";
  }

  return "idle";
}

function getConnectionBannerView(status: ConnectionState): ConnectionBannerView {
  switch (status) {
    case "connected":
      return {
        message: "Sidecar local acessível",
        pillLabel: "Conectado",
        tone: "success",
      };
    case "connecting":
      return {
        message: "Verificando a API local",
        pillLabel: "Conectando",
        tone: "info",
      };
    case "disconnected":
      return {
        message: "API local não configurada ou indisponível",
        pillLabel: "Desconectado",
        tone: "warning",
      };
    case "error":
      return {
        message: "Falha ao consultar a API local",
        pillLabel: "Erro",
        tone: "danger",
      };
    default:
      return {
        message: "Estado inicial",
        pillLabel: "Aguardando",
        tone: "neutral",
      };
  }
}

export default function ConnectionBanner() {
  const setConnectionState = useSessionStore((state) => state.setConnectionState);
  const baseUrl = getApiBaseUrl();

  const healthQuery = useQuery({
    queryKey: ["health", baseUrl],
    queryFn: ({ signal }) => getHealth(signal),
    enabled: Boolean(baseUrl),
    refetchInterval: (query) => {
      if (query.state.error) {
        return 5000;
      }

      return query.state.data ? 30_000 : 5000;
    },
    refetchIntervalInBackground: false,
  });

  const status = deriveConnectionState(healthQuery, baseUrl);

  useEffect(() => {
    setConnectionState(status);
  }, [setConnectionState, status]);

  const view = getConnectionBannerView(status);

  return (
    <div className="flex flex-wrap items-center gap-3 rounded-2xl border border-white/10 bg-slate-950/50 px-4 py-3">
      <StatusPill tone={view.tone}>{view.pillLabel}</StatusPill>
      <div className="min-w-0">
        <p className="text-sm font-medium text-white">{view.message}</p>
        <p className="text-xs text-slate-400">
          A UI segue operando mesmo quando o sidecar ainda não está disponível.
        </p>
      </div>
    </div>
  );
}
