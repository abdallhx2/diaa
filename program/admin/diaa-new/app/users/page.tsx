// ============================================================
// File: users/page.tsx
// Purpose: صفحة قائمة المستخدمين - عرض وبحث وتصفية المستخدمين
// Owner: جود — Admin Lead
// Branch: feature/admin-core
// Week: 2 — صفحات لوحة التحكم والمستخدمين
// ============================================================

'use client';

// Step 1: الاستيرادات
import { useEffect, useState } from 'react';
import DashboardLayout from '@/components/layout/DashboardLayout';
import UserTable from '@/components/users/UserTable';
import Button from '@/components/ui/Button';
import Input from '@/components/ui/Input';
import Modal from '@/components/ui/Modal';
import UserForm from '@/components/users/UserForm';
import { getUsers, createUser } from '@/services/users';
import { User } from '@/types/user';
import { UserPlus, Search } from 'lucide-react';
import { toast } from 'sonner';

// Step 2: تعريف State Variables
export default function UsersPage() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [roleFilter, setRoleFilter] = useState('all');
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);

  // Step 3: جلب المستخدمين
  const fetchUsers = async () => {
    setLoading(true);
    try {
      const res = await getUsers({
        search: searchQuery,
        role: roleFilter,
        page: currentPage,
      });
      setUsers(res.users);
      setTotalPages(res.totalPages);
    } catch (error) {
      toast.error('حدث خطأ أثناء جلب المستخدمين');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    const timer = setTimeout(() => {
      fetchUsers();
    }, 300); // debounce 300ms
    return () => clearTimeout(timer);
  }, [searchQuery, roleFilter, currentPage]);

  // Step 4: إضافة مستخدم جديد
  const handleCreateUser = async (data: Partial<User>) => {
    try {
      await createUser(data);
      toast.success('تم إضافة المستخدم بنجاح');
      setIsModalOpen(false);
      fetchUsers();
    } catch (error) {
      toast.error('حدث خطأ أثناء إضافة المستخدم');
    }
  };

  return (
    <DashboardLayout>
      <div className="p-6">

        {/* Step 5: شريط البحث والتصفية */}
        <div className="flex justify-between items-center gap-4 mb-6">
          <div className="flex gap-3 flex-1">
            <div className="relative flex-1">
              <Search className="absolute right-3 top-2.5 h-4 w-4 text-gray-400" />
              <Input
                placeholder="البحث بالاسم..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="pr-9"
              />
            </div>
            <select
              value={roleFilter}
              onChange={(e) => setRoleFilter(e.target.value)}
              className="px-3 py-2 border border-gray-300 rounded-lg text-sm text-gray-700"
            >
              <option value="all">الكل</option>
              <option value="student">طالب</option>
              <option value="parent">ولي أمر</option>
              <option value="admin">مسؤول</option>
            </select>
          </div>
          <Button onClick={() => setIsModalOpen(true)}>
            <UserPlus className="ml-2 h-4 w-4" />
            إضافة مستخدم
          </Button>
        </div>

        {/* Step 6: جدول المستخدمين */}
        {loading ? (
          <div className="text-center py-8 text-gray-400">جاري التحميل...</div>
        ) : (
          <UserTable users={users} onRefresh={fetchUsers} />
        )}

        {/* Step 7: ترقيم الصفحات */}
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

        {/* Step 8: Modal إضافة مستخدم */}
        <Modal
          isOpen={isModalOpen}
          onClose={() => setIsModalOpen(false)}
          title="إضافة مستخدم جديد"
        >
          <UserForm onSubmit={handleCreateUser} />
        </Modal>

      </div>
    </DashboardLayout>
  );
}