import api from '@/services/api';
import { User, UserCreateRequest, UserUpdateRequest, UsersResponse } from '@/types/user';

export async function getUsers(filters?: {
  search?: string;
  role?: string;
  page?: number;
  limit?: number;
}): Promise<UsersResponse> {
  const response = await api.get('/admin/users', {
    params: {
      ...filters,
      per_page: filters?.limit,
    },
  });
  const body = response.data;
  // Backend يرجع: { success: bool, data: any, message: str }
  const items = body.data?.items || body.data?.users || body.data || [];
  return {
    success: body.success,
    data: items,
    message: body.message,
    total: body.data?.total,
    page: body.data?.page,
    pages: body.data?.total ? Math.ceil(body.data.total / (filters?.limit || 20)) : 1,
  };
}

export async function getUserById(id: string): Promise<User> {
  const response = await api.get(`/admin/users/${id}`);
  return response.data.data;
}

export async function createUser(data: UserCreateRequest): Promise<User> {
  const response = await api.post('/admin/users', data);
  return response.data.data;
}

export async function updateUser(id: string, data: UserUpdateRequest): Promise<User> {
  const response = await api.put(`/admin/users/${id}`, data);
  return response.data.data;
}

export async function deleteUser(id: string): Promise<void> {
  await api.delete(`/admin/users/${id}`);
}
