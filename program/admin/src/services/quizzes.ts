import api from '@/services/api';
import { Quiz, QuizCreateRequest } from '@/types/quiz';

export async function getQuizzes(filters?: {
  quiz_type?: string;
  lesson_id?: string;
}): Promise<Quiz[]> {
  const response = await api.get('/admin/quizzes', { params: filters });
  const body = response.data;
  // Backend يرجع: { success: bool, data: any, message: str }
  const items = body.data?.items || body.data?.quizzes || body.data || [];
  return items;
}

export async function createQuiz(data: QuizCreateRequest): Promise<Quiz> {
  const response = await api.post('/admin/quizzes', data);
  return response.data.data;
}

export async function updateQuiz(id: string, data: Partial<QuizCreateRequest>): Promise<Quiz> {
  const response = await api.put(`/admin/quizzes/${id}`, data);
  return response.data.data;
}

export async function deleteQuiz(id: string): Promise<void> {
  await api.delete(`/admin/quizzes/${id}`);
}
