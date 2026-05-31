/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  experimental: {
    // Allow document uploads (PDF / Word) to post through server actions.
    // Files are validated and capped at 10 MB in the action itself.
    serverActions: {
      bodySizeLimit: "12mb",
    },
  },
};
export default nextConfig;
