import type { ElementType, PropsWithChildren } from "react";

type CardProps = PropsWithChildren<{
  as?: ElementType;
  className?: string;
}>;

export default function Card({ as: Component = "div", children, className = "" }: CardProps) {
  return <Component className={`rounded-[1.5rem] border border-white/10 p-5 shadow-panel ${className}`.trim()}>{children}</Component>;
}
