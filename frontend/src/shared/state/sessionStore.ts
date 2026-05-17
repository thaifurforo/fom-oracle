import { create } from "zustand";

export type ConnectionState = "idle" | "connecting" | "connected" | "disconnected" | "error";

type SessionState = {
  selectedSaveId: string | null;
  selectedPriorityProfileId: string | null;
  connectionState: ConnectionState;
  setSelectedSaveId: (selectedSaveId: string | null) => void;
  setSelectedPriorityProfileId: (selectedPriorityProfileId: string | null) => void;
  setConnectionState: (connectionState: ConnectionState) => void;
  reset: () => void;
};

const initialState = {
  selectedSaveId: null,
  selectedPriorityProfileId: null,
  connectionState: "idle" as ConnectionState,
};

export const useSessionStore = create<SessionState>((set) => ({
  ...initialState,
  setSelectedSaveId: (selectedSaveId) => set({ selectedSaveId }),
  setSelectedPriorityProfileId: (selectedPriorityProfileId) =>
    set({ selectedPriorityProfileId }),
  setConnectionState: (connectionState) => set({ connectionState }),
  reset: () => set(initialState),
}));
