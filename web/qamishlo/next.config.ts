import type { NextConfig } from "next";
import createNextIntlPlugin from 'next-intl/plugin';

const nextConfig: NextConfig = {
  experimental: {
    serverActions: {
      bodySizeLimit: "10mb",
    }
  },
  images: {
    // domains: ["admin.taxiwaar.com"],
    unoptimized: true,
    remotePatterns: [
      {
        protocol: 'http',
        hostname: '76.13.251.215',
        port: '3040',
        pathname: '/**',
      },
      {
        protocol: "http",
        hostname: "187.124.47.155",
        port: "3040",
        pathname: "/images/**",
      },
      {
        protocol: "https",
        hostname: "admin.taxiwaar.com",
        pathname: "/**",
      },
      {
        protocol: "https",
        hostname: "api.taxiwaar.com",
        pathname: "/**",
      }
    ],
  },
};

const withNextIntl = createNextIntlPlugin();
export default withNextIntl(nextConfig);
