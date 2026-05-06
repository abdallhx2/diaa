import React from 'react';

interface BadgeProps {
  variant: 'purple' | 'green' | 'blue' | 'amber' | 'red';
  children: React.ReactNode;
}

const colorMap: Record<BadgeProps['variant'], { bg: string; text: string }> = {
  purple: { bg: 'rgba(124,77,188,0.12)', text: '#7C4DBC' },
  green: { bg: 'rgba(62,189,133,0.12)', text: '#3EBD85' },
  blue: { bg: 'rgba(74,143,224,0.12)', text: '#4A8FE0' },
  amber: { bg: 'rgba(240,165,0,0.12)', text: '#F0A500' },
  red: { bg: 'rgba(226,86,86,0.12)', text: '#E25656' },
};

export default function Badge({ variant, children }: BadgeProps) {
  const colors = colorMap[variant];

  return (
    <span
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        padding: '3px 9px',
        borderRadius: '20px',
        fontSize: '0.72rem',
        fontWeight: 700,
        whiteSpace: 'nowrap',
        background: colors.bg,
        color: colors.text,
        fontFamily: 'Tajawal, sans-serif',
      }}
    >
      {children}
    </span>
  );
}
