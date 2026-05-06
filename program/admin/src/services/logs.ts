import api from '@/services/api';
import { SystemLog, LogsFilter } from '@/types/log';

export async function getLogs(
  filters?: LogsFilter & { page?: number; per_page?: number }
): Promise<{ data: SystemLog[]; total: number }> {
  const response = await api.get('/admin/logs', { params: filters });
  const payload = response.data.data || response.data;
  return {
    data: payload.logs || [],
    total: payload.total || 0,
  };
}
