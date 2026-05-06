import type { Config } from 'tailwindcss';

const config: Config = {
  content: ['./src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        purple: {
          DEFAULT: '#7C4DBC',
          dk: '#5A2E9A',
          lt: '#9D6FD4',
          dim: 'rgba(124,77,188,0.10)',
          glow: 'rgba(124,77,188,0.22)',
        },
        diaa: {
          bg: '#F4F2F8',
          bg2: '#EAE6F3',
          text: '#2E1A50',
          'text-sm': '#7A6E90',
          border: '#DDD6EE',
          sidebar: '#2D1B4E',
        },
        green: '#3EBD85',
        amber: '#F0A500',
        red: '#E25656',
        blue: '#4A8FE0',
      },
      borderRadius: {
        diaa: '14px',
        'diaa-sm': '9px',
      },
      boxShadow: {
        diaa: '0 2px 16px rgba(90,46,154,0.09)',
        'diaa-md': '0 6px 28px rgba(90,46,154,0.15)',
      },
      fontFamily: {
        tajawal: ['Tajawal', 'sans-serif'],
      },
    },
  },
  plugins: [],
};

export default config;
