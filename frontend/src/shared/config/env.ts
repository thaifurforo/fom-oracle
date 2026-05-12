export function getApiBaseUrl() {
  const apiBaseUrl = import.meta.env.VITE_FOM_ORACLE_API_BASE_URL;

  if (typeof apiBaseUrl !== "string") {
    return null;
  }

  const trimmed = apiBaseUrl.trim();
  return trimmed.length > 0 ? trimmed.replace(/\/+$/, "") : null;
}
