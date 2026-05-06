import { test, expect } from '@playwright/test';

test.describe('ضياء Admin Panel', () => {

  test('Login page renders with ضياء branding', async ({ page }) => {
    await page.goto('/');
    // Check brand name
    await expect(page.locator('text=ضياء')).toBeVisible();
    // Check login title
    await expect(page.locator('text=تسجيل دخول المشرف')).toBeVisible();
    // Check email input
    await expect(page.locator('input[type="email"]')).toBeVisible();
    // Check password input
    await expect(page.locator('input[type="password"]')).toBeVisible();
    // Check login button
    await expect(page.locator('button:has-text("تسجيل الدخول")')).toBeVisible();
    // Check note text
    await expect(page.locator('text=الدخول مخصص للمشرف فقط')).toBeVisible();
  });

  test('Login and redirect to dashboard', async ({ page }) => {
    await page.goto('/');
    // Fill login form
    await page.fill('input[type="email"]', 'admin@diaa.com');
    await page.fill('input[type="password"]', 'admin123');
    // Submit
    await page.click('button:has-text("تسجيل الدخول")');
    // Should redirect to dashboard (localhost mock mode)
    await page.waitForURL('**/dashboard', { timeout: 10000 });
    await expect(page.getByRole('heading', { name: 'لوحة التحكم' })).toBeVisible();
  });

  test('Dashboard page shows recent lessons', async ({ page }) => {
    await page.goto('/dashboard');
    // Wait for content
    await expect(page.locator('text=نظرة عامة على المنصة')).toBeVisible();
    // Check table
    await expect(page.locator('text=آخر الدروس المضافة')).toBeVisible();
    await expect(page.locator('text=الحروف الهجائية')).toBeVisible();
  });

  test('Sidebar navigation works', async ({ page }) => {
    await page.goto('/dashboard');
    // Check sidebar brand
    await expect(page.locator('aside:has-text("ضياء")')).toBeVisible();
    // Navigate to subjects
    await page.click('a[href="/subjects"]');
    await page.waitForURL('**/subjects');
    await expect(page.locator('text=المواد الدراسية المتاحة')).toBeVisible();
    // Navigate to lessons
    await page.click('a[href="/lessons"]');
    await page.waitForURL('**/lessons');
    await expect(page.locator('text=إدارة الدروس التعليمية')).toBeVisible();
    // Navigate to quizzes
    await page.click('a[href="/quizzes"]');
    await page.waitForURL('**/quizzes');
    await expect(page.locator('text=إدارة الأسئلة والتمارين')).toBeVisible();
  });

  test('Subjects page displays subject list', async ({ page }) => {
    await page.goto('/subjects');
    await expect(page.locator('text=لغتي')).toBeVisible();
    await expect(page.locator('text=علوم')).toBeVisible();
  });

  test('Lessons page with add button', async ({ page }) => {
    await page.goto('/lessons');
    await expect(page.locator('text=إدارة الدروس التعليمية')).toBeVisible();
    // Check add button exists
    await expect(page.locator('button:has-text("إضافة درس")')).toBeVisible();
    // Check lesson data
    await expect(page.locator('text=الحروف الهجائية')).toBeVisible();
  });

  test('Quizzes page tab switching', async ({ page }) => {
    await page.goto('/quizzes');
    // Default tab: اختبر بالدرس
    await expect(page.locator('text=ما هو الحرف الأول في الأبجدية؟')).toBeVisible();
    // Switch to reading tab
    await page.click('button:has-text("تمرن قراءة")');
    await expect(page.getByRole('cell', { name: 'اقرأ الكلمة: "كِتَابٌ"' })).toBeVisible();
    // Switch to writing tab
    await page.click('button:has-text("تمرن كتابة")');
    await expect(page.getByRole('cell', { name: 'اكتب كلمة "مَدْرَسَةٌ"' })).toBeVisible();
  });

  test('Quiz add question modal opens', async ({ page }) => {
    await page.goto('/quizzes');
    // Click add button
    await page.click('button:has-text("إضافة سؤال")');
    // Modal should appear - title is "إضافة سؤال"
    await expect(page.locator('[role="dialog"] >> text=إضافة سؤال')).toBeVisible({ timeout: 3000 });
    // Close modal
    await page.click('button:has-text("إلغاء")');
    // Modal should disappear
    await expect(page.locator('[role="dialog"]')).not.toBeVisible();
  });

});
