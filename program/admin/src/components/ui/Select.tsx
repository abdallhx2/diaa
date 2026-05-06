'use client';

import React, { useState } from 'react';

interface SelectProps extends React.SelectHTMLAttributes<HTMLSelectElement> {
  label?: string;
  options: { value: string; label: string }[];
}

export default function Select({ label, options, style, ...props }: SelectProps) {
  const [focused, setFocused] = useState(false);

  const selectStyle: React.CSSProperties = {
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
    cursor: 'pointer',
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
      <select
        style={selectStyle}
        onFocus={(e) => {
          setFocused(true);
          props.onFocus?.(e);
        }}
        onBlur={(e) => {
          setFocused(false);
          props.onBlur?.(e);
        }}
        {...props}
      >
        {options.map((opt) => (
          <option key={opt.value} value={opt.value}>
            {opt.label}
          </option>
        ))}
      </select>
    </div>
  );
}
