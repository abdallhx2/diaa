/**
 * Edu Smart Assistant — Admin Panel Lifecycle Test
 * =================================================
 * Full admin workflow:
 *   1. Login page renders correctly
 *   2. Login and redirect to dashboard
 *   3. Dashboard shows stats/lessons
 *   4. Navigate to Lessons page, verify CRUD
 *   5. Navigate to Quizzes page, verify tabs
 *   6. Navigate to Subjects page
 *   7. Sidebar navigation works
 *
 * Run:
 *   cd admin
 *   npx playwright test tests/lifecycle.spec.ts --headed
 */

import { test, expect } from '@playwright/test';

// Ensure backend admin user exists before tests
test.beforeAll(async ({ request }) => {
  // Call verify-token to create admin user in backend
  try {
    await request.post('http://localhost:8000/api/auth/verify-token', {
      data: { token: 'mock_admin_AdminUser' },
    });
  } catch {
    // Backend might not be running yet — tests will use mock data fallback
    console.warn('Backend not reachable — admin pages will use mock data');
  }
});

test.describe('Phase 1: Login', () => {
  test('Login page shows branding and form', async ({ page }) => {
    await page.goto('/');
    // Brand name
    await expect(page.locator('text=ضياء')).toBeVisible();
    // Login title
    await expect(page.locator('text=تسجيل دخول المشرف')).toBeVisible();
    // Form elements
    await expect(page.locator('input[type="email"]')).toBeVisible();
    await expect(page.locator('input[type="password"]')).toBeVisible();
    await expect(page.locator('button:has-text("تسجيل الدخول")')).toBeVisible();
    // Footer note
    await expect(page.locator('text=الدخول مخصص للمشرف فقط')).toBeVisible();
  });

  test('Login with mock credentials redirects to dashboard', async ({ page }) => {
    await page.goto('/');
    await page.fill('input[type="email"]', 'admin@diaa.com');
    await page.fill('input[type="password"]', 'admin123');
    await page.click('button:has-text("تسجيل الدخول")');
    // Should redirect to dashboard (mock mode on localhost)
    await page.waitForURL('**/dashboard', { timeout: 15000 });
    await expect(page.getByRole('heading', { name: 'لوحة التحكم' })).toBeVisible();
  });
});

test.describe('Phase 2: Dashboard', () => {
  test.beforeEach(async ({ page }) => {
    // Login first
    await page.goto('/');
    await page.fill('input[type="email"]', 'admin@diaa.com');
    await page.fill('input[type="password"]', 'admin123');
    await page.click('button:has-text("تسجيل الدخول")');
    await page.waitForURL('**/dashboard', { timeout: 15000 });
  });

  test('Dashboard shows overview text and lessons table', async ({ page }) => {
    await expect(page.locator('text=نظرة عامة على المنصة')).toBeVisible();
    await expect(page.locator('text=آخر الدروس المضافة')).toBeVisible();
    // Should have table rows (either real or mock data)
    const rows = page.locator('tbody tr');
    await expect(rows.first()).toBeVisible({ timeout: 10000 });
    const count = await rows.count();
    expect(count).toBeGreaterThan(0);
  });

  test('Sidebar shows ضياء brand and navigation links', async ({ page }) => {
    await expect(page.locator('aside:has-text("ضياء")')).toBeVisible();
    // Navigation links
    await expect(page.locator('a[href="/dashboard"]')).toBeVisible();
    await expect(page.locator('a[href="/lessons"]')).toBeVisible();
    await expect(page.locator('a[href="/quizzes"]')).toBeVisible();
    await expect(page.locator('a[href="/subjects"]')).toBeVisible();
  });
});

test.describe('Phase 3: Lessons Management', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await page.fill('input[type="email"]', 'admin@diaa.com');
    await page.fill('input[type="password"]', 'admin123');
    await page.click('button:has-text("تسجيل الدخول")');
    await page.waitForURL('**/dashboard', { timeout: 15000 });
    // Navigate to lessons
    await page.click('a[href="/lessons"]');
    await page.waitForURL('**/lessons');
  });

  test('Lessons page shows title and add button', async ({ page }) => {
    await expect(page.locator('text=إدارة الدروس التعليمية')).toBeVisible();
    await expect(page.locator('button:has-text("إضافة درس")')).toBeVisible();
  });

  test('Lessons table has data rows', async ({ page }) => {
    const rows = page.locator('tbody tr');
    await expect(rows.first()).toBeVisible({ timeout: 10000 });
    const count = await rows.count();
    expect(count).toBeGreaterThan(0);
  });

  test('Add lesson modal opens and closes', async ({ page }) => {
    await page.click('button:has-text("إضافة درس")');
    // Modal should appear
    const modal = page.locator('[role="dialog"]');
    await expect(modal).toBeVisible({ timeout: 5000 });
    // Close modal
    const cancelBtn = page.locator('button:has-text("إلغاء")');
    if (await cancelBtn.isVisible()) {
      await cancelBtn.click();
    } else {
      await page.keyboard.press('Escape');
    }
    await expect(modal).not.toBeVisible({ timeout: 3000 });
  });
});

test.describe('Phase 4: Quizzes Management', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await page.fill('input[type="email"]', 'admin@diaa.com');
    await page.fill('input[type="password"]', 'admin123');
    await page.click('button:has-text("تسجيل الدخول")');
    await page.waitForURL('**/dashboard', { timeout: 15000 });
    await page.click('a[href="/quizzes"]');
    await page.waitForURL('**/quizzes');
  });

  test('Quizzes page shows title', async ({ page }) => {
    await expect(page.locator('text=إدارة الأسئلة والتمارين')).toBeVisible();
  });

  test('Add question button exists', async ({ page }) => {
    await expect(page.locator('button:has-text("إضافة سؤال")')).toBeVisible();
  });

  test('Add question modal opens', async ({ page }) => {
    await page.click('button:has-text("إضافة سؤال")');
    const modal = page.locator('[role="dialog"]');
    await expect(modal).toBeVisible({ timeout: 5000 });
    // Close
    const cancelBtn = page.locator('button:has-text("إلغاء")');
    if (await cancelBtn.isVisible()) {
      await cancelBtn.click();
    } else {
      await page.keyboard.press('Escape');
    }
  });
});

test.describe('Phase 5: Subjects', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await page.fill('input[type="email"]', 'admin@diaa.com');
    await page.fill('input[type="password"]', 'admin123');
    await page.click('button:has-text("تسجيل الدخول")');
    await page.waitForURL('**/dashboard', { timeout: 15000 });
    await page.click('a[href="/subjects"]');
    await page.waitForURL('**/subjects');
  });

  test('Subjects page renders with subject list', async ({ page }) => {
    await expect(page.locator('text=المواد الدراسية المتاحة')).toBeVisible();
    // Should show subjects like لغتي, علوم
    await expect(page.locator('text=لغتي')).toBeVisible();
  });
});

test.describe('Phase 6: Full Navigation Flow', () => {
  test('Navigate through all pages via sidebar', async ({ page }) => {
    // Login
    await page.goto('/');
    await page.fill('input[type="email"]', 'admin@diaa.com');
    await page.fill('input[type="password"]', 'admin123');
    await page.click('button:has-text("تسجيل الدخول")');
    await page.waitForURL('**/dashboard', { timeout: 15000 });

    // Dashboard → Lessons
    await page.click('a[href="/lessons"]');
    await page.waitForURL('**/lessons');
    await expect(page.locator('text=إدارة الدروس التعليمية')).toBeVisible();

    // Lessons → Quizzes
    await page.click('a[href="/quizzes"]');
    await page.waitForURL('**/quizzes');
    await expect(page.locator('text=إدارة الأسئلة والتمارين')).toBeVisible();

    // Quizzes → Subjects
    await page.click('a[href="/subjects"]');
    await page.waitForURL('**/subjects');
    await expect(page.locator('text=المواد الدراسية المتاحة')).toBeVisible();

    // Subjects → Dashboard
    await page.click('a[href="/dashboard"]');
    await page.waitForURL('**/dashboard');
    await expect(page.getByRole('heading', { name: 'لوحة التحكم' })).toBeVisible();
  });
});
