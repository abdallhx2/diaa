import type { Metadata } from 'next';
import { Tajawal } from 'next/font/google';
import './globals.css';
import { Toaster } from 'sonner';

const tajawal = Tajawal({
  subsets: ['arabic'],
  weight: ['300', '400', '500', '700', '800', '900'],
});

export const metadata: Metadata = {
  title: 'ضياء — لوحة التحكم',
  description: 'لوحة تحكم المسؤول لمنصة ضياء التعليمية',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="ar" dir="rtl">
      <body className={tajawal.className}>
        {children}
        <Toaster position="top-center" richColors dir="rtl" />
      </body>
    </html>
  );
}
