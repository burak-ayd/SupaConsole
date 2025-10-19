/** @type {import('next').NextConfig} */
const nextConfig = {
  // ✅ Turbopack ve Webpack arasında otomatik geçişi destekler
  experimental: {
    turbo: {
      // Turbopack için özel build optimizasyonları (loader gerektirmez)
      resolveAlias: {
        '@supabase-core': false,
        '@supabase-projects': false,
      },
    },
    externalDir: true,
  },

  typescript: {
    // Derleme hatalarını durdurmasını istemiyorsan true yap
    ignoreBuildErrors: false,
  },

  webpack: (config, { isServer }) => {
    // ✅ Webpack modunda Supabase klasörlerini hariç tut
    config.module.rules.push({
      test: /\.tsx?$/,
      exclude: [/supabase-core/, /supabase-projects/],
    });
    return config;
  },
};

module.exports = nextConfig;
