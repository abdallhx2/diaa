'use client';

import React, { useState } from 'react';

interface TextareaProps extends React.TextareaHTMLAttributes<HTMLTextAreaElement> {
  label?: string;
}

export default function Textarea({ label, style, ...props }: TextareaProps) {
  const [focused, setFocused] = useState(false);

  const textareaStyle: React.CSSProperties = {
    width: '100%',
    background: focused ? '#ffffff' : '#F4F2F8',
    border: `1.5px solid ${focused ? '#7C4DBC' : '#DDD6EE'}`,
    borderRadius: '9px',
    padding: '10px 13px',
    fontSize: '0.86rem',
    fontFamily: 'Tajawal, sans-serif',
    color: '#2E1A50',
    direction: 'rtl',
    outline: 'none',
    transition: 'all 0.18s',
    boxSizing: 'border-box',
    resize: 'vertical',
    minHeight: '80px',
    ...style,
  };

  return (
    <div style={{ width: '100%' }}>
      {label && (
        <label
          style={{
            display: 'block',
            fontSize: '0.8rem',
            fontWeight: 700,
            color: '#2E1A50',
            marginBottom: '6px',
            fontFamily: 'Tajawal, sans-serif',
          }}
        >
          {label}
        </label>
      )}
      <textarea
        style={textareaStyle}
        onFocus={(e) => {
          setFocused(true);
          props.onFocus?.(e);
        }}
        onBlur={(e) => {
          setFocused(false);
          props.onBlur?.(e);
        }}
        {...props}
      />
    </div>
  );
}
