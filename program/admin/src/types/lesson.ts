export interface Lesson {
  id: string;
  title: string;
  subject: string;
  grade_level: string;
  original_text: string;
  qr_code?: string;
  audio_url?: string;
  created_at: string;
}

export interface LessonCreateRequest {
  title: string;
  subject: string;
  grade_level: string;
  original_text: string;
  qr_code?: string;
}

export interface LessonUpdateRequest {
  title?: string;
  subject?: string;
  grade_level?: string;
  original_text?: string;
  qr_code?: string;
}
