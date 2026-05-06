export interface User {
  id: string;
  firebase_uid: string;
  role: 'student' | 'parent' | 'admin';
  name: string;
  email: string;
  phone?: string;
  created_at: string;
  is_active: boolean;
}

export interface UserCreateRequest {
  name: string;
  email: string;
  phone?: string;
  role: 'student' | 'parent' | 'admin';
  password: string;
  is_active?: boolean;
}

export interface UserUpdateRequest {
  name?: string;
  email?: string;
  phone?: string;
  role?: 'student' | 'parent' | 'admin';
  is_active?: boolean;
}

export interface UsersResponse {
  success: boolean;
  data: User[];
  message: string;
  total?: number;
  page?: number;
  pages?: number;
}
