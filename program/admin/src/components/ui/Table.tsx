'use client';

import React from 'react';

interface Column<T> {
  key: string;
  header: string;
  render?: (row: T) => React.ReactNode;
}

interface TableProps<T> {
  columns: Column<T>[];
  data: T[];
  onEdit?: (row: T) => void;
  onDelete?: (row: T) => void;
}

export default function Table<T>({ columns, data, onEdit, onDelete }: TableProps<T>) {
  const hasActions = onEdit || onDelete;

  return (
    <div style={{ overflowX: 'auto', width: '100%' }}>
      <table
        style={{
          width: '100%',
          borderCollapse: 'collapse',
          fontFamily: 'Tajawal, sans-serif',
        }}
      >
        <thead>
          <tr>
            {columns.map((col) => (
              <th
                key={col.key}
                style={{
                  padding: '11px 20px',
                  textAlign: 'right',
                  fontSize: '0.72rem',
                  fontWeight: 700,
                  color: '#7A6E90',
                  background: '#F4F2F8',
                  borderBottom: '1px solid #DDD6EE',
                  textTransform: 'uppercase',
                  letterSpacing: '0.5px',
                  whiteSpace: 'nowrap',
                }}
              >
                {col.header}
              </th>
            ))}
            {hasActions && (
              <th
                style={{
                  padding: '11px 20px',
                  textAlign: 'right',
                  fontSize: '0.72rem',
                  fontWeight: 700,
                  color: '#7A6E90',
                  background: '#F4F2F8',
                  borderBottom: '1px solid #DDD6EE',
                  textTransform: 'uppercase',
                  letterSpacing: '0.5px',
                }}
              >
                الإجراءات
              </th>
            )}
          </tr>
        </thead>
        <tbody>
          {data.map((row, rowIndex) => (
            <tr
              key={rowIndex}
              style={{
                borderBottom: '1px solid rgba(221,214,238,0.5)',
                transition: 'background 0.13s',
              }}
              onMouseEnter={(e) => {
                e.currentTarget.style.background = 'rgba(244,242,248,0.8)';
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.background = 'transparent';
              }}
            >
              {columns.map((col) => (
                <td
                  key={col.key}
                  style={{
                    padding: '13px 20px',
                    fontSize: '0.86rem',
                    verticalAlign: 'middle',
                    color: '#2E1A50',
                  }}
                >
                  {col.render
                    ? col.render(row)
                    : (row as Record<string, unknown>)[col.key] as React.ReactNode}
                </td>
              ))}
              {hasActions && (
                <td
                  style={{
                    padding: '13px 20px',
                    verticalAlign: 'middle',
                  }}
                >
                  <div style={{ display: 'flex', gap: '6px' }}>
                    {onEdit && (
                      <ActionButton
                        type="edit"
                        onClick={() => onEdit(row)}
                      />
                    )}
                    {onDelete && (
                      <ActionButton
                        type="delete"
                        onClick={() => onDelete(row)}
                      />
                    )}
                  </div>
                </td>
              )}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

function ActionButton({ type, onClick }: { type: 'edit' | 'delete'; onClick: () => void }) {
  const isEdit = type === 'edit';
  const baseBg = isEdit ? 'rgba(74,143,224,0.12)' : 'rgba(226,86,86,0.12)';
  const baseColor = isEdit ? '#4A8FE0' : '#E25656';
  const hoverBg = isEdit ? '#4A8FE0' : '#E25656';

  return (
    <button
      onClick={onClick}
      style={{
        width: '28px',
        height: '28px',
        borderRadius: '7px',
        background: baseBg,
        color: baseColor,
        border: 'none',
        cursor: 'pointer',
        display: 'inline-flex',
        alignItems: 'center',
        justifyContent: 'center',
        transition: 'all 0.15s',
        fontSize: '13px',
      }}
      onMouseEnter={(e) => {
        e.currentTarget.style.background = hoverBg;
        e.currentTarget.style.color = '#ffffff';
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.background = baseBg;
        e.currentTarget.style.color = baseColor;
      }}
    >
      {isEdit ? (
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
          <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
        </svg>
      ) : (
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <polyline points="3 6 5 6 21 6" />
          <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
        </svg>
      )}
    </button>
  );
}
