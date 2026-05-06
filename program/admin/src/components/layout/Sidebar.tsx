'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';

const navItems = [
  { label: 'لوحة التحكم', icon: '\u229E', href: '/dashboard' },
  { label: 'المواد', icon: '\uD83D\uDCDA', href: '/subjects' },
  { label: 'الدروس', icon: '\uD83D\uDCD6', href: '/lessons' },
  { label: 'الاختبارات', icon: '\u270F\uFE0F', href: '/quizzes' },
];

export default function Sidebar() {
  const pathname = usePathname();

  const isActive = (href: string) => pathname.startsWith(href);

  return (
    <aside
      className="fixed right-0 top-0 h-screen z-50 flex flex-col"
      style={{
        width: 'var(--sidebar-w)',
        background: '#2D1B4E',
      }}
    >
      {/* Brand */}
      <div className="flex items-center justify-center py-7">
        <span
          className="text-white select-none"
          style={{ fontSize: '1.8rem', fontWeight: 900 }}
        >
          ضياء
        </span>
      </div>

      {/* Navigation */}
      <nav className="flex flex-col gap-1 px-3 mt-2">
        {navItems.map((item) => {
          const active = isActive(item.href);
          return (
            <Link
              key={item.href}
              href={item.href}
              className="relative flex items-center gap-[10px] rounded-[9px] transition-colors duration-200"
              style={{
                padding: '11px 18px',
                color: active ? '#FFFFFF' : 'rgba(255,255,255,0.55)',
                background: active
                  ? 'rgba(124,77,188,0.45)'
                  : 'transparent',
              }}
              onMouseEnter={(e) => {
                if (!active) {
                  e.currentTarget.style.background = 'rgba(255,255,255,0.07)';
                  e.currentTarget.style.color = 'rgba(255,255,255,0.9)';
                }
              }}
              onMouseLeave={(e) => {
                if (!active) {
                  e.currentTarget.style.background = 'transparent';
                  e.currentTarget.style.color = 'rgba(255,255,255,0.55)';
                }
              }}
            >
              {/* Active indicator bar */}
              {active && (
                <span
                  className="absolute right-0 top-1/2 -translate-y-1/2 rounded-l-sm"
                  style={{
                    width: '3px',
                    height: '60%',
                    background: '#9D6FD4',
                  }}
                />
              )}
              <span className="text-lg leading-none">{item.icon}</span>
              <span className="text-sm font-medium">{item.label}</span>
            </Link>
          );
        })}
      </nav>
    </aside>
  );
}
