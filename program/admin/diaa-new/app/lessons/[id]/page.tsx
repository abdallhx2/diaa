// ============================================================
// File: lessons/[id]/page.tsx
// Purpose: صفحة عرض وتعديل درس محدد
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 2 — صفحات المحتوى التعليمي
// ============================================================

'use client';

import { useEffect, useState } from 'react';
import { useParams, useRouter } from 'next/navigation';
import DashboardLayout from '@/components/layout/DashboardLayout';
import LessonForm from '@/components/lessons/LessonForm';
import Button from '@/components/ui/Button';
import Modal from '@/components/ui/Modal';
import { getLessonById, updateLesson, deleteLesson } from '@/services/lessons';
import { Lesson } from '@/types/lesson';
import { Trash2, ArrowRight } from 'lucide-react';
import { toast } from 'sonner';

export default function EditLessonPage() {
  const params = useParams();
  const router = useRouter();
  const lessonId = params.id as string;

  // Step 2: State Variables
  const [lesson, setLesson] = useState<Lesson | null>(null);
  const [loading, setLoading] = useState(true);
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);
  const [deleteLoading, setDeleteLoading] = useState(false);

  // Step 3: جلب بيانات الدرس
  useEffect(() => {
    const fetchLesson = async () => {
      try {
        const res = await getLessonById(lessonId);
        setLesson(res);
      } catch {
        toast.error('حدث خطأ أثناء جلب بيانات الدرس');
        router.push('/lessons');
      } finally {
        setLoading(false);
      }
    };
    fetchLesson();
  }, [lessonId]);

  // Step 5: معالجة التعديل
  const handleUpdate = async (data: any) => {
    try {
      await updateLesson(lessonId, data);
      toast.success('تم تحديث الدرس بنجاح');
      router.push('/lessons');
    } catch {
      toast.error('حدث خطأ أث