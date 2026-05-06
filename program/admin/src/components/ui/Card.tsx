import React from 'react';

interface CardProps {
  title?: string;
  headerAction?: React.ReactNode;
  children: React.ReactNode;
  className?: string;
}

export default function Card({ title, headerAction, children, className }: CardProps) {
  return (
    <div
      className={className}
      style={{
        background: '#ffffff',
        borderRadius: '14px',
        boxShadow: '0 2px 16px rgba(90,46,154,0.09)',
        overflow: 'hidden',
      }}
    >
      {title && (
        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            padding: '16px 20px',
            borderBottom: '1px solid #DDD6EE',
          }}
        >
          <h3
            style={{
              fontSize: '0.92rem',
              fontWeight: 800,
              color: '#2E1A50',
              margin: 0,
              fontFamily: 'Tajawal, sans-serif',
            }}
          >
            {title}
          </h3>
          {headerAction && <div>{headerAction}</div>}
        </div>
      )}
      <div>{children}</div>
    </div>
  );
}
