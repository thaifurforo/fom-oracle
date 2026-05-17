export type StatusTone = "neutral" | "info" | "success" | "warning" | "danger";

type StatusPillProps = {
  tone?: StatusTone;
  children: string;
};

const toneClasses: Record<StatusTone, string> = {
  neutral: "border-white/10 bg-white/5 text-slate-200",
  info: "border-sky-400/30 bg-sky-400/10 text-sky-100",
  success: "border-emerald-400/30 bg-emerald-400/10 text-emerald-100",
  warning: "border-amber-400/30 bg-amber-400/10 text-amber-100",
  danger: "border-rose-400/30 bg-rose-400/10 text-rose-100",
};

export default function StatusPill({ tone = "neutral", children }: StatusPillProps) {
  return (
    <span
      className={`inline-flex items-center rounded-full border px-3 py-1 text-xs font-medium uppercase tracking-[0.22em] ${toneClasses[tone]}`}
    >
      {children}
    </span>
  );
}
