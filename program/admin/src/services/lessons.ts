import api from '@/services/api';
import { Lesson, LessonCreateRequest, LessonUpdateRequest } from '@/types/lesson';

export async function getLessons(filters?: {
  search?: string;
  subject?: string;
  grade?: string;
  page?: number;
  limit?: number;
}): Promise<Lesson[]> {
  const response = await api.get('/admin/lessons', { params: filters });
  const body = response.data;
  // Backend يرجع: { success: bool, data: any, message: str }
  const items = body.data?.items || body.data?.lessons || body.data || [];
  return items;
}

export async function getLessonById(id: string): Promise<Lesson> {
  const response = await api.get(`/admin/lessons/${id}`);
  return response.data.data;
}

export async function createLesson(data: LessonCreateRequest): Promise<Lesson> {
  const response = await api.post('/admin/lessons', data);
  return response.data.data;
}

export async function updateLesson(id: string, data: LessonUpdateRequest): Promise<Lesson> {
  const response = await api.put(`/admin/lessons/${id}`, data);
  return response.data.data;
}

export async function deleteLesson(id: string): Promise<void> {
  await api.delete(`/admin/lessons/${id}`);
}
