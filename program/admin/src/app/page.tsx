'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { signIn } from '@/services/auth';
import api from '@/services/api';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const router = useRouter();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      try {
        await signIn(email, password);
      } catch {
        // Firebase sign-in failed — allow mock mode on localhost
        if (!window.location.hostname.includes('localhost')) {
          throw new Error('auth-failed');
        }
      }

      // Verify admin role
      try {
        const response = await api.get('/auth/me');
        if (response.data.data?.role !== 'admin') {
          setError('ليس لديك صلاحية الوصول للوحة التحكم');
          setLoading(false);
          return;
        }
      } catch {
        if (window.location.hostname !== 'localhost') {
          setError('فشل التحقق من صلاحيات المسؤول');
          return;
        }
        // في localhost: تابع (mock mode)
      }

      router.push('/dashboard');
    } catch {
      setError('البريد الإلكتروني أو كلمة المرور غير صحيحة');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div
      dir="rtl"
      style={{
        minHeight: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        background: '#F4F2F8',
        position: 'relative',
        overflow: 'hidden',
        fontFamily: 'Tajawal, sans-serif',
      }}
    >
      {/* Decorative gradients */}
      <div
        style={{
          position: 'absolute',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          background:
            'radial-gradient(circle at 80% 10%, rgba(124,77,188,0.15) 0%, transparent 50%), radial-gradient(circle at 10% 90%, rgba(124,77,188,0.1) 0%, transparent 50%)',
          pointerEvents: 'none',
        }}
      />

      <div style={{ position: 'relative', zIndex: 1, width: '100%', maxWidth: 400, padding: '0 16px' }}>
        {/* Brand */}
        <div style={{ textAlign: 'center', marginBottom: 32 }}>
          <h1
            style={{
              fontSize: '2.8rem',
              fontWeight: 900,
              color: '#2D1B4E',
              margin: 0,
              lineHeight: 1.2,
            }}
          >
            ضياء
          </h1>
          <p style={{ color: '#7A6E90', fontSize: '0.95rem', marginTop: 8 }}>
            منصة تعليمية للأطفال
          </p>
        </div>

        {/* Login Card */}
        <div
          style={{
            background: '#fff',
            borderRadius: 20,
            boxShadow: '0 8px 32px rgba(124,77,188,0.1)',
            padding: '36px 32px',
          }}
        >
          <h2
            style={{
              fontSize: '1.25rem',
              fontWeight: 800,
              color: '#2E1A50',
              margin: 0,
              textAlign: 'center',
            }}
          >
            تسجيل دخول المشرف
          </h2>

          {/* Purple divider */}
          <div
            style={{
              width: 40,
              height: 3,
              background: 'linear-gradient(90deg, #7C4DBC, #9D6FD4)',
              borderRadius: 2,
              margin: '12px auto 24px',
            }}
          />

          {/* Error message */}
          {error && (
            <div
              style={{
                background: 'rgba(220,38,38,0.06)',
                border: '1px solid rgba(220,38,38,0.2)',
                borderRadius: 10,
                padding: '10px 14px',
                marginBottom: 18,
              }}
            >
              <p style={{ color: '#dc2626', fontSize: '0.85rem', margin: 0, textAlign: 'center' }}>
                {error}
              </p>
            </div>
          )}

          <form onSubmit={handleSubmit}>
            {/* Email */}
            <div style={{ marginBottom: 18 }}>
              <label
                style={{
                  display: 'block',
                  fontSize: '0.85rem',
                  fontWeight: 600,
                  color: '#2E1A50',
                  marginBottom: 6,
                }}
              >
                البريد الإلكتروني
              </label>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="admin@diaa.com"
                required
                style={{
                  width: '100%',
                  padding: '11px 14px',
                  border: '1.5px solid #E8E4F0',
                  borderRadius: 10,
                  fontSize: '0.9rem',
                  outline: 'none',
                  transition: 'border-color 0.2s',
                  boxSizing: 'border-box',
                  fontFamily: 'Tajawal, sans-serif',
                }}
                onFocus={(e) => (e.target.style.borderColor = '#7C4DBC')}
                onBlur={(e) => (e.target.style.borderColor = '#E8E4F0')}
              />
            </div>

            {/* Password */}
            <div style={{ marginBottom: 24 }}>
              <label
                style={{
                  display: 'block',
                  fontSize: '0.85rem',
                  fontWeight: 600,
                  color: '#2E1A50',
                  marginBottom: 6,
                }}
              >
                كلمة المرور
              </label>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="••••••••"
                required
                style={{
                  width: '100%',
                  padding: '11px 14px',
                  border: '1.5px solid #E8E4F0',
                  borderRadius: 10,
                  fontSize: '0.9rem',
                  outline: 'none',
                  transition: 'border-color 0.2s',
                  boxSizing: 'border-box',
                  fontFamily: 'Tajawal, sans-serif',
                }}
                onFocus={(e) => (e.target.style.borderColor = '#7C4DBC')}
                onBlur={(e) => (e.target.style.borderColor = '#E8E4F0')}
              />
            </div>

            {/* Login button */}
            <button
              type="submit"
              disabled={loading}
              style={{
                width: '100%',
                padding: '12px',
                background: 'linear-gradient(135deg, #7C4DBC, #5A2E9A)',
                color: '#fff',
                border: 'none',
                borderRadius: 10,
                fontSize: '1rem',
                fontWeight: 800,
                cursor: loading ? 'not-allowed' : 'pointer',
                opacity: loading ? 0.7 : 1,
                transition: 'opacity 0.2s',
                fontFamily: 'Tajawal, sans-serif',
              }}
            >
              {loading ? 'جاري الدخول...' : 'تسجيل الدخول'}
            </button>
          </form>

          {/* Note */}
          <p
            style={{
              textAlign: 'center',
              fontSize: '0.78rem',
              color: '#7A6E90',
              marginTop: 18,
              marginBottom: 0,
            }}
          >
            الدخول مخصص للمشرف فقط
          </p>
        </div>
      </div>
    </div>
  );
}
