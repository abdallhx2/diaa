'use client';

import { useRouter } from 'next/navigation';

interface HeaderProps {
  title?: string;
}

export default function Header({ title }: HeaderProps) {
  const router = useRouter();

  const handleLogout = () => {
    router.push('/');
  };

  return (
    <header
      className="sticky top-0 z-[100] flex items-center"
      style={{
        height: 'var(--topbar-h)',
        background: '#FFFFFF',
        borderBottom: '1px solid var(--border)',
        paddingInline: '24px',
        marginRight: 'var(--sidebar-w)',
      }}
    >
      {/* Left side: logo + page title */}
      <div className="flex items-center gap-3">
        <span className="text-purple font-bold text-base">ضياء</span>
        {title && (
          <>
            <span className="text-diaa-border">|</span>
            <span className="font-bold text-diaa-text text-sm">{title}</span>
          </>
        )}
      </div>

      {/* Right side (margin-right auto pushes to left in RTL) */}
      <div className="mr-auto flex items-center gap-4">
        {/* Logout button */}
        <button
          onClick={handleLogout}
          className="flex items-center gap-2 px-3 py-1.5 rounded-diaa-sm text-red hover:bg-red/10 transition-colors text-sm font-medium"
        >
          خروج
        </button>

        {/* Admin avatar pill */}
        <div
          className="flex items-center gap-2 px-3 py-1.5 rounded-full"
          style={{ background: 'var(--purple-dim)' }}
        >
          <div
            className="w-7 h-7 rounded-full flex items-center justify-center text-white text-xs font-bold"
            style={{ background: 'var(--purple)' }}
          >
            م
          </div>
          <span className="text-sm font-medium text-diaa-text">المدير</span>
        </div>
      </div>
    </header>
  );
}
