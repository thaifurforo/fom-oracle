import type { Config } from "tailwindcss";

export default {
  content: ["./index.html", "./src/**/*.{ts,tsx}"],
  theme: {
    extend: {
      boxShadow: {
        panel: "0 24px 60px -32px rgba(15, 23, 42, 0.65)",
      },
      colors: {
        ink: {
          950: "#070b14",
          900: "#0b1220",
          800: "#11192c",
          700: "#1f2a44",
          500: "#64748b",
          300: "#cbd5e1",
          100: "#f8fafc",
        },
        accent: {
          500: "#7dd3fc",
          600: "#38bdf8",
          700: "#0ea5e9",
        },
        warm: {
          500: "#f59e0b",
        },
      },
      fontFamily: {
        sans: [
          "Inter",
          "ui-sans-serif",
          "system-ui",
          "-apple-system",
          "BlinkMacSystemFont",
          "Segoe UI",
          "sans-serif",
        ],
      },
    },
  },
  plugins: [],
} satisfies Config;
