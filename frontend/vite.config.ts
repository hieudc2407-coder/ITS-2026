import { defineConfig } from 'vite';

export default defineConfig({
  server: {
    port: 5173,
    open: '/dashboard.html',
  },
  build: {
    target: 'ES2020',
    minify: 'terser',
  },
});
