export interface Quiz {
  id: string;
  lesson_id: string;
  quiz_type: 'reading' | 'writing' | 'comprehension';
  question_text: string;
  options: string[];
  correct_answer: string;
  created_at?: string;
}

export interface QuizCreateRequest {
  lesson_id: string;
  quiz_type: 'reading' | 'writing' | 'comprehension';
  question_text: string;
  options: string[];
  correct_answer: string;
}

export interface QuizResult {
  id: string;
  student_id: string;
  quiz_id: string;
  selected_answer: string;
  is_correct: boolean;
  answered_at: string;
}
