import { useRoutes } from "react-router-dom";

import { appRoutes } from "@/app/routes";

export default function App() {
  return useRoutes(appRoutes);
}
