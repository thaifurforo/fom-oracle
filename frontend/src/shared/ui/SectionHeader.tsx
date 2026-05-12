type SectionHeaderProps = {
  eyebrow: string;
  title: string;
  description: string;
};

export default function SectionHeader({ eyebrow, title, description }: SectionHeaderProps) {
  return (
    <header className="space-y-2">
      <p className="text-xs uppercase tracking-[0.28em] text-slate-400">{eyebrow}</p>
      <h3 className="text-xl font-semibold tracking-tight text-white">{title}</h3>
      <p className="max-w-2xl text-sm leading-7 text-slate-300">{description}</p>
    </header>
  );
}
