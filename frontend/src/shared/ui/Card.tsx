import type { PropsWithChildren } from "react";

type CardProps = PropsWithChildren<{
  className?: string;
}>;

export default function Card({ children, className = "" }: CardProps) {
  return <article className={`rounded-[1.5rem] border p-5 shadow-panel ${className}`.trim()}>{children}</article>;
}
