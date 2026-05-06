export interface SystemLog {
  id: string;
  user_id?: string | null;
  user_name?: string;
  action: string;
  details: Record<string, unknown> | null;
  status: string;
  created_at: string;
}

export interface LogsFilter {
  action?: string;
  user_id?: string;
}
