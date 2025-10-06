import path from 'node:path'
import { fileURLToPath } from 'node:url'

import react from '@vitejs/plugin-react'
import { defineConfig, UserConfig } from 'vite'
import tsconfigPaths from 'vite-tsconfig-paths'

import { version } from './package.json'

const __dirname = path.dirname(fileURLToPath(import.meta.url))

// https://vitejs.dev/config/

const viteConfig: UserConfig = {
  plugins: [
    tsconfigPaths(),
    react(),
  ],
  optimizeDeps: { exclude: ['node_modules/.cache'] },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
    extensions: ['.tsx', '.ts', '.mts', '.mjs', '.jsx', '.js', '.json'],
  },
  envDir: path.resolve(__dirname, './'),
  build: {
    sourcemap: true,
    outDir: 'dist',
  },
  define: {
    APP_VERSION: JSON.stringify(version),
    APP_ENVIRONMENT: JSON.stringify(process.env.VITE_ENV),
  },
  server: {
    host: '0.0.0.0',
    port: 3000,
    hmr: {
      overlay: false,
    },
    allowedHosts: [
      'c7d00ac52676.ngrok-free.app',
      'localhost',
      '.ngrok-free.app', // Permet tous les sous-domaines ngrok
    ],
  },
}

export default defineConfig(viteConfig)