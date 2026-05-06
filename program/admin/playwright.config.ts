import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  timeout: 30000,
  use: {
    baseURL: 'http://localhost:3099',
    headless: true,
  },
  webServer: {
    command: 'npx next dev -p 3099',
    port: 3099,
    reuseExistingServer: true,
  },
});
