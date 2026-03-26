// ============================================================
// File: logs/page.tsx
// Purpose: صفحة سجلات النظام - عرض وتصفية سجلات الإجراءات
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 3 — السجلات والإعدادات
// ============================================================

'use client';

import { useEffect, useState } from 'react';
import DashboardLayout from '@/components/layout/DashboardLayout';
import Table from '@/components/ui/Table';
import Button from '@/components/ui/Button';
import { getLogs } from '@/services/logs';
import { SystemLog, LogsFilter } from '@/types/log';
import { format } from 'date-fns';
import { ar } from 'date-fns/locale';

export default function LogsPage() {

  // Step 1: State Variables
  const [logs, setLogs] = useState<SystemLog[]>([]);
  const [loading, setLoading] = useState(false);
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [filters, setFilters] = useState<LogsFilter>({
    date_from: '',
    date_to: '',
    action_type: '',
    user_id: '',
  });

  // Step 2: جلب السجلات
  const fetchLogs = async () => {
    setLoading(true);
    try {
      const res = await getLogs({ ...filters, page: currentPage, limit: 20 });
      setLogs(res.logs);
      setTotalPages(res.totalPages);
    } catch {
      console.error('خطأ في جلب السجلات');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchLogs();
  }, [filters, currentPage]);

  // Step 3: أعمدة الجدول
  const columns = [
    {
      key: 'user_name',
      label: 'اسم المستخدم',
    },
    {
      key: 'action',
      label: 'الإجراء',
    },
    {
      key: 'details',
      label: 'التفاصيل',
      render: (log: SystemLog) => (
        <span className="text-xs text-gray-500 truncate max-w-[200px] block">
          {typeof log.details === 'object'
            ? JSON.stringify(log.details).substring(0, 50) + '...'
            : log.details}
        </span>
      ),
    },
    {
      key: 'created_at',
      label: 'التاريخ والوقت',
      render: (log: SystemLog) => (
        <span>
          {log.created_at
            ? format(new Date(log.created_at), 'dd/MM/yyyy HH:mm', { locale: ar })
            : '—'}
        </span>
      ),
    },
  ];

  return (
    <DashboardLayout>
      <div className="p-6">

        <h1 className="text-2xl font-bold text-gray-800 mb-6">سجلات النظام</h1>

        {/* Step 4: شريط التصفية */}
        <div className="flex gap-4 items-end mb-6 flex-wrap">

          {/* تاريخ من */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">من تاريخ</label>
            <input
              type="date"
              value={filters.date_from}
              onChange={(e) => setFilters((prev) => ({ ...prev, date_from: e.target.value }))}
              className="px-3 py-2 border border-gray-300 rounded-lg text-gray-700"
            />
          </div>

          {/* تاريخ إلى */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">إلى تاريخ</label>
            <input
              type="date"
              value={filters.date_to}
              onChange={(e) => setFilters((prev) => ({ ...prev, date_to: e.target.value }))}
              className="px-3 py-2 border border-gray-300 rounded-lg text-gray-700"
            />
          </div>

          {/* نوع الإجراء */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">نوع الإجراء</label>
            <select
              value={filters.action_type}
              onChange={(e) => setFilters((prev) => ({ ...prev, action_type: e.target.value }))}
              className="px-3 py-2 border border-gray-300 rounded-lg text-gray-700"
            >
              <option value="">الكل</option>
              <option value="login">تسجيل دخول</option>
              <option value="create">إنشاء</option>
              <option value="update">تعديل</option>
              <option value="delete">حذف</option>
            </select>
          </div>

          {/* زر إعادة تعيين */}
          <Button
            variant="secondary"
            onClick={() => setFilters({ date_from: '', date_to: '', action_type: '', user_id: '' })}
          >
            إعادة تعيين
          </Button>

        </div>

        {/* Step 5: جدول السجلات */}
        {loading ? (
          <div className="text-center py-8 text-gray-400">جاري التحميل...</div>
        ) : (
          <Table columns={columns} data={logs} />
        )}

        {/* Step 6: Pagination */}
        {totalPages > 1 && (
          <div className="flex justify-center items-center gap-2 mt-6">
            <Button
              variant="secondary"
              size="sm"
              onClick={() => setCurrentPage((p) => Math.max(p - 1, 1))}
              disabled={currentPage === 1}
            >
              السابق
            </Button>
            {Array.from({ length: totalPages }, (_, i) => i + 1).map((page) => (
              <Button
                key={page}
                variant={page === currentPage ? 'primary' : 'secondary'}
                size="sm"
                onClick={() => setCurrentPage(page)}
              >
                {page}
              </Button>
            ))}
            <Button
              variant="secondary"
              size="sm"
              onClick={() => setCurrentPage((p) => Math.min(p + 1, totalPages))}
              disabled={currentPage === totalPages}
            >
              التالي
            </Button>
          </div>
        )}

      </div>
    </DashboardLayout>
  );
}