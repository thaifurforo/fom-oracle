import Card from "@/shared/ui/Card";
import SectionHeader from "@/shared/ui/SectionHeader";

const nextSteps = [
  "Conectar a API local do sidecar",
  "Ler o save ativo e atualizar o painel",
  "Introduzir prioridades dinâmicas",
];

export default function HomePage() {
  return (
    <div className="space-y-6">
      <section className="grid gap-4 xl:grid-cols-[1.35fr_0.9fr]">
        <Card className="border-sky-400/20 bg-gradient-to-br from-sky-500/12 via-white/5 to-transparent">
          <div className="space-y-4">
            <div className="inline-flex rounded-full border border-sky-300/30 bg-sky-400/10 px-3 py-1 text-xs font-medium uppercase tracking-[0.24em] text-sky-100">
              Assistente estratégico
            </div>
            <div className="space-y-3">
              <h2 className="text-3xl font-semibold tracking-tight text-white sm:text-4xl">
                O shell já abre pronto para interpretar o contexto do save.
              </h2>
              <p className="max-w-2xl text-sm leading-7 text-slate-300 sm:text-base">
                Esta tela é o ponto de entrada da v1: resumo do save no topo, leitura
                consolidada no corpo e recomendações explicáveis quando o core estiver ativo.
              </p>
            </div>
          </div>
        </Card>

        <Card className="border-white/8 bg-white/5">
          <SectionHeader
            eyebrow="Pronto para a próxima etapa"
            title="Resumo do save"
            description="Ainda sem dados reais, mas com a estrutura pronta para receber o snapshot do core."
          />
          <div className="mt-5 space-y-3">
            {nextSteps.map((step, index) => (
              <div
                key={step}
                className="flex items-center gap-3 rounded-2xl border border-white/8 bg-slate-950/45 px-4 py-3"
              >
                <span className="flex h-7 w-7 items-center justify-center rounded-full bg-sky-400/15 text-sm font-semibold text-sky-100">
                  {index + 1}
                </span>
                <span className="text-sm text-slate-200">{step}</span>
              </div>
            ))}
          </div>
        </Card>
      </section>

      <section className="grid gap-4 lg:grid-cols-3">
        <Card className="border-white/8 bg-white/5">
          <SectionHeader
            eyebrow="Leitura"
            title="Painel de contexto"
            description="Dia, estação, dinheiro, progresso da mina e relacionamentos entram aqui quando o backend estiver conectado."
          />
        </Card>
        <Card className="border-white/8 bg-white/5">
          <SectionHeader
            eyebrow="Decisão"
            title="Recomendações do dia"
            description="As ações serão exibidas em ordem de importância, com explicações legíveis e sem score técnico exposto."
          />
        </Card>
        <Card className="border-white/8 bg-white/5">
          <SectionHeader
            eyebrow="Escopo"
            title="Shell sem regra de negócio"
            description="Inventário, presentes e heurísticas continuam no core .NET; a UI só orquestra a experiência."
          />
        </Card>
      </section>
    </div>
  );
}
