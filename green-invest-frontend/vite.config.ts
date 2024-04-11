//green-invest

import { defineConfig } from 'vite';
import path from 'path';

export default defineConfig({
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './'),
    },
    preserveSymlinks: true,
  },
  optimizeDeps: {
    include: ['@wagmi/core']
  },
});
