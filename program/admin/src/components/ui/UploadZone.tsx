'use client';

import React, { useState } from 'react';

interface UploadZoneProps {
  icon: string;
  title: string;
  subtitle: string;
  onClick?: () => void;
}

export default function UploadZone({ icon, title, subtitle, onClick }: UploadZoneProps) {
  const [hovered, setHovered] = useState(false);

  return (
    <div
      onClick={onClick}
      onMouseEnter={() => setHovered(true)}
      onMouseLeave={() => setHovered(false)}
      style={{
        border: `2px dashed ${hovered ? '#7C4DBC' : '#DDD6EE'}`,
        borderRadius: '14px',
        padding: '28px 20px',
        textAlign: 'center',
        background: hovered ? 'rgba(124,77,188,0.10)' : 'rgba(244,242,248,0.6)',
        cursor: 'pointer',
        transition: 'all 0.18s',
        fontFamily: 'Tajawal, sans-serif',
      }}
    >
      <div style={{ fontSize: '1.8rem', marginBottom: '8px' }}>{icon}</div>
      <div
        style={{
          fontSize: '0.88rem',
          fontWeight: 700,
          color: '#2E1A50',
          marginBottom: '4px',
        }}
      >
        {title}
      </div>
      <div
        style={{
          fontSize: '0.75rem',
          color: '#7A6E90',
        }}
      >
        {subtitle}
      </div>
    </div>
  );
}
