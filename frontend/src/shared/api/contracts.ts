export type HealthResponse = {
  status: "ok" | "disconnected" | "error";
  appVersion: string;
  coreVersion: string;
};
