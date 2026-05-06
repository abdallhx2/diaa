import axios from 'axios';
import { getIdToken } from '@/services/auth';

const api = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000/api',
  headers: { 'Content-Type': 'application/json' },
  timeout: 15000,
});

api.interceptors.request.use(
  async (config) => {
    let token = await getIdToken();
    // Fallback to mock admin token in dev/mock mode
    if (!token && config.baseURL?.includes('localhost')) {
      token = 'mock_admin_AdminUser';
    }
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      if (typeof window !== 'undefined') {
        window.location.href = '/';
      }
    }
    return Promise.reject(error);
  }
);

export default api;
