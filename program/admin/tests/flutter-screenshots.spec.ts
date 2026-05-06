/**
 * Flutter App — Chrome Screenshots
 * Takes screenshots of every major screen for testing documentation.
 */

import { test, expect } from '@playwright/test';

const FLUTTER_URL = 'http://localhost:5000';
const SCREENSHOT_DIR = 'test-results/flutter-screenshots';

test.use({
  baseURL: FLUTTER_URL,
  viewport: { width: 420, height: 900 },
});

test.describe('Flutter App Screenshots', () => {

  test('01 - Splash Screen', async ({ page }) => {
    await page.goto('/');
    // Wait for Flutter to render
    await page.waitForTimeout(3000);
    await page.screenshot({ path: `${SCREENSHOT_DIR}/01-splash.png`, fullPage: true });
  });

  test('02 - Role Selection / Login', async ({ page }) => {
    await page.goto('/');
    await page.waitForTimeout(4000);
    // Flutter web routes — try clicking or wait for navigation
    // Take screenshot of whatever screen is showing after splash
    await page.screenshot({ path: `${SCREENSHOT_DIR}/02-role-selection.png`, fullPage: true });
  });

  test('03 - Navigate through app', async ({ page }) => {
    await page.goto('/');
    await page.waitForTimeout(5000);

    // Screenshot current state
    await page.screenshot({ path: `${SCREENSHOT_DIR}/03-current-screen.png`, fullPage: true });

    // Try to interact with visible elements
    // Look for any buttons or tappable elements
    const buttons = page.locator('flt-semantics-placeholder, [role="button"], button');
    const count = await buttons.count();

    // Take screenshot after a short wait for any animations
    await page.waitForTimeout(2000);
    await page.screenshot({ path: `${SCREENSHOT_DIR}/04-after-wait.png`, fullPage: true });

    // Try clicking in common areas where Flutter buttons might be
    // Student login area (center of screen)
    try {
      await page.mouse.click(210, 450);
      await page.waitForTimeout(2000);
      await page.screenshot({ path: `${SCREENSHOT_DIR}/05-after-click-center.png`, fullPage: true });
    } catch { /* ignore */ }

    // Try tapping different areas
    try {
      await page.mouse.click(210, 600);
      await page.waitForTimeout(2000);
      await page.screenshot({ path: `${SCREENSHOT_DIR}/06-after-click-lower.png`, fullPage: true });
    } catch { /* ignore */ }
  });

  test('04 - Full page captures at different points', async ({ page }) => {
    await page.goto('/');
    await page.waitForTimeout(6000);

    // Capture at multiple intervals to see transitions
    for (let i = 0; i < 3; i++) {
      await page.waitForTimeout(2000);
      await page.screenshot({ path: `${SCREENSHOT_DIR}/07-interval-${i}.png`, fullPage: true });
    }
  });

});
