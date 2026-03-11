// ============================================================
// File: settings/page.tsx
// Purpose: صفحة إعدادات النظام - إدارة الإعدادات العامة
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 3 — السجلات والإعدادات
// ============================================================

'use client';

// Step 1: الاستيرادات
import { useEffect, useState } from 'react';
import DashboardLayout from '@/components/layout/DashboardLayout';
import Card from '@/components/ui/Card';
import Button from '@/components/ui/Button';
import Input from '@/components/ui/Input';
import api from '@/services/api';
import { toast } from 'sonner';
import { Settings, Save } from 'lucide-react';

// Step 2: تعريف interface الإعدادات
interface SystemSettings {
  language: string;
  content_toggles: Record<string, boolean>;
  notifications: {
    email: boolean;
    in_app: boolean;
  };
}

// Step 3: بناء الصفحة
export default function SettingsPage() {

  const [settings, setSettings] = useState<SystemSettings | null>(null);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);

  // Step 4: جلب الإعدادات
  useEffect(() => {
    const fetchSettings = async () => {
      setLoading(true);
      try {
        const res = await api.get('/api/admin/settings');
        setSettings(res.data);
      } catch {
        toast.error('حدث خطأ أثناء جلب الإعدادات');
      } finally {
        setLoading(false);
      }
    };
    fetchSettings();
  }, []);

  // Step 5: حفظ الإعدادات
  const handleSave = async () => {
    setSaving(true);
    try {
      await api.put('/api/admin/settings', settings);
      toast.success('تم حفظ الإعدادات بنجاح');
    } catch {
      toast.error('حدث خطأ أثناء حف
