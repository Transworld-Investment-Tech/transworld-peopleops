// next/font self-hosting. Replaces the render-blocking Google Fonts <link> that
// used to live in app/layout.tsx. The fonts are downloaded at build time and
// served from our own origin, preloaded, with size-adjusted fallbacks (no layout
// shift). The three families are exposed as CSS variables so the existing
// globals.css rules (var(--font-sans|--font-serif|--font-mono)) resolve unchanged.
import { IBM_Plex_Sans, IBM_Plex_Mono, Spectral } from "next/font/google";

export const plexSans = IBM_Plex_Sans({
  subsets: ["latin"],
  weight: ["400", "500", "600", "700"],
  variable: "--font-sans",
  display: "swap",
});

export const plexMono = IBM_Plex_Mono({
  subsets: ["latin"],
  weight: ["400", "500", "600"],
  variable: "--font-mono",
  display: "swap",
});

export const spectral = Spectral({
  subsets: ["latin"],
  weight: ["500", "600", "700"],
  variable: "--font-serif",
  display: "swap",
});

export const fontVars = `${plexSans.variable} ${plexMono.variable} ${spectral.variable}`;
