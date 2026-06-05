import { markdownToHtml } from "@/lib/learning";

// Renders trusted, HR-authored markdown reading material. The conversion in
// lib/learning.ts escapes HTML first, so author content can't inject markup;
// only a small markdown subset (headings, lists, bold/italic, code, http links)
// is emitted.
export default function MarkdownView({ source }: { source: string | null | undefined }) {
  const html = markdownToHtml(source);
  if (!html) {
    return <p className="faint">No reading content has been added yet.</p>;
  }
  return <div className="lesson ln-body" dangerouslySetInnerHTML={{ __html: html }} />;
}
