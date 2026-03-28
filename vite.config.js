import { defineConfig } from 'vite'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [tailwindcss()],
  // Change to '/' if repo is username.github.io
  base: '/portfolio/',
  build: { outDir: 'dist' }
})
