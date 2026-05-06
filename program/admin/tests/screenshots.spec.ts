import { test, expect } from '@playwright/test';
import path from 'path';

const screenshotDir = path.join(__dirname, '..', 'screenshots');

test.describe('ضياء Admin Panel — Visual Review', () => {

  test('01 - Login Page', async ({ page }) => {
    await page.setViewportSize({ width: 1440, height: 900 });
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.screenshot({ path: path.join(screenshotDir, '01-login.png'), fullPage: true });
    // Visual checks
    await expect(page.locator('text=ضياء')).toBeVisible();
    await expect(page.locator('text=تسجيل دخول المشرف')).toBeVisible();
  });

  test('02 - Dashboard Page', async ({ page }) => {
    await page.setViewportSize({ width: 1440, height: 900 });
    await page.goto('/dashboard');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(1000);
    await page.screenshot({ path: path.join(screenshotDir, '02-dashboard.png'), fullPage: true });
    // Visual checks
    await expect(page.locator('aside')).toBeVisible();
    await expect(page.getByRole('heading', { name: 'لوحة التحكم' })).toBeVisible();
    await expect(page.locator('text=آخر الدروس المضافة')).toBeVisible();
  });

  test('03 - Subjects Page', async ({ page }) => {
    await page.setViewportSize({ width: 1440, height: 900 });
    await page.goto('/subjects');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(500);
    await page.screenshot({ path: path.join(screenshotDir, '03-subjects.png'), fullPage: true });
    // Visual checks
    await expect(page.locator('text=المواد الدراسية المتاحة')).toBeVisible();
    await expect(page.locator('text=لغتي')).toBeVisible();
    await expect(page.locator('text=علوم')).toBeVisible();
  });

  test('04 - Lessons Page', async ({ page }) => {
    await page.setViewportSize({ width: 1440, height: 900 });
    await page.goto('/lessons');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(1000);
    await page.screenshot({ path: path.join(screenshotDir, '04-lessons.png'), fullPage: true });
    // Visual checks
    await expect(page.locator('text=إدارة الدروس التعليمية')).toBeVisible();
    await expect(page.locator('button:has-text("إضافة درس")')).toBeVisible();
    await expect(page.locator('text=الحروف الهجائية')).toBeVisible();
  });

  test('05 - Quizzes Page (Tab 1: اختبر بالدرس)', async ({ page }) => {
    await page.setViewportSize({ width: 1440, height: 900 });
    await page.goto('/quizzes');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(500);
    await page.screenshot({ path: path.join(screenshotDir, '05-quizzes-tab1.png'), fullPage: true });
    await expect(page.locator('text=ما هو الحرف الأول في الأبجدية؟')).toBeVisible();
  });

  test('06 - Quizzes Page (Tab 2: تمرن قراءة)', async ({ page }) => {
    await page.setViewportSize({ width: 1440, height: 900 });
    await page.goto('/quizzes');
    await page.waitForLoadState('networkidle');
    await page.click('button:has-text("تمرن قراءة")');
    await page.waitForTimeout(300);
    await page.screenshot({ path: path.join(screenshotDir, '06-quizzes-tab2.png'), fullPage: true });
    await expect(page.getByRole('cell', { name: 'اقرأ الكلمة: "كِتَابٌ"' })).toBeVisible();
  });

  test('07 - Quizzes Page (Tab 3: تمرن كتابة)', async ({ page }) => {
    await page.setViewportSize({ width: 1440, height: 900 });
    await page.goto('/quizzes');
    await page.waitForLoadState('networkidle');
    await page.click('button:has-text("تمرن كتابة")');
    await page.waitForTimeout(300);
    await page.screenshot({ path: path.join(screenshotDir, '07-quizzes-tab3.png'), fullPage: true });
    await expect(page.getByRole('cell', { name: 'اكتب كلمة "مَدْرَسَةٌ"' })).toBeVisible();
  });

  test('08 - Add Question Modal', async ({ page }) => {
    await page.setViewportSize({ width: 1440, height: 900 });
    await page.goto('/quizzes');
    await page.waitForLoadState('networkidle');
    await page.click('button:has-text("إضافة سؤال")');
    await page.waitForTimeout(500);
    await page.screenshot({ path: path.join(screenshotDir, '08-modal-add-question.png'), fullPage: true });
    await expect(page.locator('[role="dialog"]')).toBeVisible();
  });

  test('09 - Add Lesson Modal', async ({ page }) => {
    await page.setViewportSize({ width: 1440, height: 900 });
    await page.goto('/lessons');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(1000);
    await page.click('button:has-text("إضافة درس")');
    await page.waitForTimeout(500);
    await page.screenshot({ path: path.join(screenshotDir, '09-modal-add-lesson.png'), fullPage: true });
    await expect(page.locator('[role="dialog"]')).toBeVisible();
  });

});
