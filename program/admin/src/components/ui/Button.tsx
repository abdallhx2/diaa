'use client';

import React from 'react';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'ghost';
  size?: 'default' | 'sm';
  isLoading?: boolean;
  children: React.ReactNode;
}

export default function Button({
  variant = 'primary',
  size = 'default',
  isLoading = false,
  children,
  disabled,
  style,
  ...props
}: ButtonProps) {
  const baseStyle: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '6px',
    borderRadius: '9px',
    fontWeight: 700,
    fontSize: size === 'sm' ? '0.78rem' : '0.85rem',
    padding: size === 'sm' ? '6px 13px' : '9px 18px',
    fontFamily: 'Tajawal, sans-serif',
    cursor: disabled || isLoading ? 'not-allowed' : 'pointer',
    opacity: isLoading ? 0.7 : 1,
    transition: 'all 0.18s ease',
    border: 'none',
    outline: 'none',
    ...(variant === 'primary'
      ? {
          background: '#7C4DBC',
          color: '#ffffff',
          boxShadow: '0 3px 12px rgba(124,77,188,0.22)',
        }
      : {
          background: 'transparent',
          color: '#7A6E90',
          border: '1.5px solid #DDD6EE',
        }),
    ...style,
  };

  const handleMouseEnter = (e: React.MouseEvent<HTMLButtonElement>) => {
    if (disabled || isLoading) return;
    if (variant === 'primary') {
      e.currentTarget.style.background = '#5A2E9A';
      e.currentTarget.style.transform = 'translateY(-1px)';
    } else {
      e.currentTarget.style.borderColor = '#7C4DBC';
      e.currentTarget.style.color = '#7C4DBC';
    }
  };

  const handleMouseLeave = (e: React.MouseEvent<HTMLButtonElement>) => {
    if (disabled || isLoading) return;
    if (variant === 'primary') {
      e.currentTarget.style.background = '#7C4DBC';
      e.currentTarget.style.transform = 'translateY(0)';
    } else {
      e.currentTarget.style.borderColor = '#DDD6EE';
      e.currentTarget.style.color = '#7A6E90';
    }
  };

  return (
    <button
      style={baseStyle}
      disabled={disabled || isLoading}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
      {...props}
    >
      {isLoading && (
        <svg
          width="14"
          height="14"
          viewBox="0 0 24 24"
          fill="none"
          style={{ animation: 'spin 1s linear infinite' }}
        >
          <circle
            cx="12"
            cy="12"
            r="10"
            stroke="currentColor"
            strokeWidth="3"
            strokeDasharray="32"
            strokeLinecap="round"
            opacity={0.3}
          />
          <path
            d="M12 2a10 10 0 0 1 10 10"
            stroke="currentColor"
            strokeWidth="3"
            strokeLinecap="round"
          />
        </svg>
      )}
      {children}
    </button>
  );
}
