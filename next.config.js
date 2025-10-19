/** @type {import('next').NextConfig} */
const nextConfig = {
  // ✅ Yeni format (experimental.turbo yerine turbopack)
  turbopack: {
    // Alias'ları false yerine null olarak veya boş string ile yönlendir
    resolveAlias: {
      '@supabase-core': null,
      '@supabase-projects': null,
    },
  },

  experimental: {
    externalDir: true,
  },

  typescript: {
    ignoreBuildErrors: false,
  },

  webpack: (config, { isServer }) => {
    // Webpack kullanan ortamlar için exclude kuralı devam etsin
    config.module.rules.push({
      test: /\.tsx?$/,
      exclude: [/supabase-core/, /supabase-projects/],
    });
    return config;
  },
};

module.exports = nextConfig;
