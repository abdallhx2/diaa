'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import Sidebar from '@/components/layout/Sidebar';
import Header from '@/components/layout/Header';
import { onAuthStateChanged } from '@/services/auth';

interface DashboardLayoutProps {
  children: React.ReactNode;
  title?: string;
}

export default function DashboardLayout({ children, title }: DashboardLayoutProps) {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [loading, setLoading] = useState(true);
  const router = useRouter();

  useEffect(() => {
    let resolved = false;

    // Timeout fallback so auth check doesn't hang forever
    const timeout = setTimeout(() => {
      if (!resolved) {
        resolved = true;
        // في localhost فقط: سمح بالدخول (mock mode)
        if (window.location.hostname === 'localhost') {
          setIsAuthenticated(true);
        } else {
          router.push('/');
        }
        setLoading(false);
      }
    }, 3000);

    const unsubscribe = onAuthStateChanged((user) => {
      if (resolved) return;
      resolved = true;
      clearTimeout(timeout);
      if (!user) {
        const isMockMode = process.env.NEXT_PUBLIC_API_URL?.includes('localhost');
        if (isMockMode || window.location.hostname === 'localhost') {
          setIsAuthenticated(true);
        } else {
          router.push('/');
        }
      } else {
        setIsAuthenticated(true);
      }
      setLoading(false);
    });

    return () => {
      clearTimeout(timeout);
      unsubscribe();
    };
  }, [router]);

  if (loading) {
    return (
      <div
        className="min-h-screen flex items-center justify-center"
        style={{ background: 'var(--bg)' }}
      >
        <div className="text-center">
          <div className="inline-block h-8 w-8 animate-spin rounded-full border-4 border-purple border-t-transparent" />
          <p className="mt-4 text-diaa-text-sm">جاري التحميل...</p>
        </div>
      </div>
    );
  }

  if (!isAuthenticated) return null;

  return (
    <div className="min-h-screen" style={{ background: 'var(--bg)' }}>
      <Sidebar />
      <Header title={title} />
      <main
        style={{
          marginRight: 'var(--sidebar-w)',
          padding: '24px',
        }}
      >
        {children}
      </main>
    </div>
  );
}
