import Card from "@/shared/ui/Card";
import SectionHeader from "@/shared/ui/SectionHeader";

type ComingSoonPageProps = {
  title: string;
  description: string;
};

export default function ComingSoonPage({ title, description }: ComingSoonPageProps) {
  return (
    <Card className="border-white/10 bg-white/5">
      <SectionHeader
        eyebrow="Em breve"
        title={title}
        description={description}
      />
      <p className="mt-6 max-w-2xl text-sm leading-7 text-slate-300">
        Esta área vai consumir os contratos do sidecar local quando o núcleo de leitura e
        recomendação estiver disponível.
      </p>
    </Card>
  );
}
