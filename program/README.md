# Edu Smart Assistant

مساعد تعليمي ذكي لدعم التعليم المبكر — المنهج السعودي

---

## هيكل المشروع

```
Edu/
├── mobile/     → تطبيق الجوال Flutter (الطالب + ولي الأمر)
├── backend/    → الخادم الخلفي FastAPI + PostgreSQL
├── admin/      → لوحة تحكم المسؤول Next.js
└── docs/       → المستندات
```

---

# الخطوة 0: تثبيت الأدوات الأساسية على جهازك

هذه الأدوات لازم تكون مثبتة على جهازك قبل ما تبدأي بأي شي.

---

## 0.1 تثبيت Git (نظام إدارة الكود)

Git يخلينا نشتغل كفريق على نفس المشروع بدون ما نضيع شغل بعض.

**Windows:**

1. حمّلي Git من: https://git-scm.com/download/win
2. شغّلي الملف المحمّل واضغطي **Next** على كل الخطوات (الإعدادات الافتراضية كافية)
3. بعد التثبيت، افتحي **Command Prompt** أو **PowerShell** وجرّبي:

```bash
git --version
```

اذا طلع رقم الإصدار مثل `git version 2.44.0` يعني مثبت بنجاح.

**Mac:**

```bash
# افتحي Terminal واكتبي:
xcode-select --install
# هذا الأمر يثبت Git تلقائياً

# تأكدي:
git --version
```

**إعداد Git (مرة واحدة فقط):**

بعد التثبيت، عرّفي نفسك:

```bash
git config --global user.name "اسمك بالانجليزي"
git config --global user.email "بريدك@email.com"
```

---

## 0.2 تثبيت VS Code (محرر الكود)

محرر الكود اللي بنستخدمه كلنا.

1. حمّلي من: https://code.visualstudio.com/download
2. ثبّتيه بالضغط على **Next** لآخر خطوة
3. بعد التثبيت، ثبّتي هذي الإضافات من داخل VS Code (اضغطي على أيقونة المربعات في الشريط الجانبي):
   - **Flutter** (لفريق التطبيق)
   - **Python** (لفريق Backend + AI)
   - **ES7+ React Snippets** (لفريق Admin)
   - **Arabic Language Pack** (اختياري)

---

## 0.3 تثبيت Python (لفريق Backend + AI)

**Windows:**

1. حمّلي من: https://www.python.org/downloads/
2. **مهم جداً:** عند التثبيت، ضعي علامة ✅ على **"Add Python to PATH"** في أول شاشة
3. اضغطي **Install Now**
4. تأكدي:

```bash
python --version
# المتوقع: Python 3.11 أو أحدث

pip --version
# المتوقع: pip 23.x أو أحدث
```

**Mac:**

```bash
# ثبّتي Homebrew أولاً (مدير الحزم):
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# ثم ثبّتي Python:
brew install python

# تأكدي:
python3 --version
pip3 --version
```

> **ملاحظة Mac:** استخدمي `python3` و `pip3` بدل `python` و `pip`

---

## 0.4 تثبيت PostgreSQL (لفريق Backend)

**Windows:**

1. حمّلي من: https://www.postgresql.org/download/windows/
2. شغّلي المثبّت واضغطي **Next**
3. حطّي كلمة مرور (احفظيها! مثلاً: `postgres123`)
4. خلّي المنفذ الافتراضي **5432**
5. تأكدي:

```bash
psql --version
```

**Mac:**

```bash
brew install postgresql@15
brew services start postgresql@15

# تأكدي:
psql --version
```

---

## 0.5 تثبيت Node.js + npm (لفريق Admin)

**Windows:**

1. حمّلي **LTS** من: https://nodejs.org/
2. شغّلي المثبّت واضغطي **Next** على كل شي
3. تأكدي:

```bash
node --version
# المتوقع: v18 أو أحدث

npm --version
# المتوقع: 9 أو أحدث
```

**Mac:**

```bash
brew install node

# تأكدي:
node --version
npm --version
```

---

## 0.6 تثبيت Flutter + Android Studio (لفريق التطبيق)

**Windows:**

1. حمّلي Flutter SDK من: https://docs.flutter.dev/get-started/install/windows
2. فكّي الضغط في مجلد مثل `C:\flutter`
3. أضيفي Flutter لـ PATH:
   - ابحثي عن "Environment Variables" في قائمة Start
   - في **Path** أضيفي: `C:\flutter\bin`
4. حمّلي **Android Studio** من: https://developer.android.com/studio
5. ثبّتي Android Studio → افتحيه → اذهبي لـ **SDK Manager** → ثبّتي **Android SDK**
6. تأكدي:

```bash
flutter doctor
```

اذا طلعت علامات ✅ خضراء يعني كل شي تمام. اذا طلعت ✗ حمراء، اتبعي التعليمات اللي تظهر.

**Mac:**

```bash
brew install --cask flutter
brew install --cask android-studio

# افتحي Android Studio → SDK Manager → ثبّتي Android SDK

# تأكدي:
flutter doctor
```

---

# الخطوة 1: تحميل المشروع من GitHub

```bash
# افتحي Terminal أو Command Prompt
# روحي للمجلد اللي تبين تحفظين فيه المشروع:
cd Desktop

# حمّلي المشروع:
git clone https://github.com/abdallhx2/diaa.git

# ادخلي مجلد المشروع:
cd diaa
```


---

# الخطوة 2: تشغيل مشروعك حسب فريقك

كل فريق يشتغل على مجلد مختلف. اتبعي التعليمات الخاصة بفريقك فقط.

---

## فريق Backend + AI (مشاعل، فاطمة، رنيم، فرح، ريناد، فدوه)

### التثبيت

**Windows:**

```bash
cd backend

# إنشاء بيئة افتراضية (عشان المكتبات ما تتعارض)
python -m venv venv

# تفعيل البيئة
venv\Scripts\activate

# تثبيت المكتبات
pip install -r requirements.txt
```

**Mac:**

```bash
cd backend

python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt
```

### إعداد ملف البيئة

```bash
# Windows:
copy .env.example .env

# Mac:
cp .env.example .env
```

افتحي ملف `.env` وعدّلي القيم:

```
DATABASE_URL=postgresql://postgres:postgres123@localhost:5432/edusmart
FIREBASE_CREDENTIALS_PATH=./firebase-credentials.json
AZURE_SPEECH_KEY=ضعي_المفتاح_هنا
AZURE_SPEECH_REGION=eastus
OPENAI_API_KEY=sk-ضعي_المفتاح_هنا
```

### إنشاء قاعدة البيانات

```bash
# افتحي PostgreSQL وأنشئي قاعدة بيانات:
# Windows:
psql -U postgres
# Mac:
psql postgres

# داخل psql اكتبي:
CREATE DATABASE edusmart;
\q

# ثم شغّلي الجداول:
alembic upgrade head
```

### تشغيل السيرفر

```bash
uvicorn app.main:app --reload --port 8000
```

افتحي المتصفح على: http://localhost:8000/docs ← لازم تظهر صفحة Swagger

### اختبار الاتصال بالخدمات

```bash
python test_connections.py
```

يختبر: PostgreSQL + Firebase + EasyOCR + Azure TTS + OpenAI + FastAPI

### مسارات ملفات Backend

```
backend/
├── app/
│   ├── main.py                    ← نقطة البداية
│   ├── config.py                  ← إعدادات البيئة
│   ├── database.py                ← اتصال قاعدة البيانات
│   ├── models/                    ← جداول قاعدة البيانات
│   ├── schemas/                   ← التحقق من البيانات
│   ├── routers/                   ← نقاط الوصول API
│   ├── services/                  ← منطق الأعمال (OCR, TTS, Chat)
│   ├── middleware/                 ← التحقق من الهوية + تسجيل
│   └── utils/                     ← أدوات مساعدة
├── tests/                         ← ملفات الاختبار
├── test_connections.py            ← اختبار الاتصال
├── requirements.txt               ← قائمة المكتبات
├── Dockerfile
└── alembic.ini
```

---

## فريق Flutter (ديمة، رهف، حياة)

### التثبيت

```bash
cd mobile

# تأكدي أن Flutter مثبت:
flutter doctor

# تثبيت مكتبات المشروع:
flutter pub get
```

### تشغيل التطبيق

```bash
# اذا عندك جوال متصل أو محاكي مشغّل:
flutter run

# لتشغيل على Chrome (للاختبار السريع):
flutter run -d chrome
```

### اختبار أساسي

عدّلي `lib/main.dart` مؤقتاً:

```dart
import 'test_main.dart' as test;
void main() => test.main();
```

ثم `flutter run` — ستظهر شاشة تختبر الاتصال بالخدمات.

> **مهم: أرجعي `main.dart` لوضعه الأصلي بعد الاختبار**

### إعداد Firebase

1. ادخلي https://console.firebase.google.com
2. أنشئي مشروع جديد
3. أضيفي تطبيق Android → حمّلي `google-services.json` → ضعيه في `mobile/android/app/`
4. أضيفي تطبيق iOS → حمّلي `GoogleService-Info.plist` → ضعيه في `mobile/ios/Runner/`

### مسارات ملفات Flutter

الملفات اللي تشتغلين عليها كلها داخل `lib/`:

```
mobile/
├── lib/
│   ├── main.dart                  ← نقطة البداية
│   ├── app.dart                   ← إعداد التطبيق
│   ├── config/                    ← الإعدادات (ألوان، ثوابت، مسارات)
│   ├── models/                    ← كلاسات البيانات
│   ├── services/                  ← اتصال بالـ API
│   ├── providers/                 ← إدارة الحالة
│   ├── screens/                   ← الشاشات
│   │   ├── splash/
│   │   ├── auth/                  ← تسجيل دخول
│   │   ├── student/               ← شاشات الطالب
│   │   ├── quiz/                  ← شاشات الاختبارات
│   │   └── parent/                ← شاشات ولي الأمر
│   └── widgets/                   ← المكونات المشتركة (أزرار، حقول...)
├── pubspec.yaml                   ← قائمة المكتبات
└── assets/                        ← صور وخطوط
```

---

## فريق Admin (جود، جود2)

### التثبيت

```bash
cd admin

# تثبيت المكتبات:
npm install
```

### إعداد ملف البيئة

```bash
# Windows:
copy .env.local.example .env.local

# Mac:
cp .env.local.example .env.local
```

افتحي `.env.local` وعدّلي:

```
NEXT_PUBLIC_API_URL=http://localhost:8000/api
NEXT_PUBLIC_FIREBASE_API_KEY=ضعي_المفتاح
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=your-project-id
```

### تشغيل السيرفر

```bash
npm run dev
```

افتحي المتصفح على: http://localhost:3000

### اختبار أساسي

بعد التشغيل، افتحي في المتصفح:

```
http://localhost:3000/test
```

تظهر صفحة تختبر: Next.js + Backend API + Firebase

> **احذفي مجلد `src/app/test/` بعد الاختبار**

### مسارات ملفات Admin

الملفات اللي تشتغلين عليها كلها داخل `src/`:

```
admin/
├── src/
│   ├── app/                       ← الصفحات
│   │   ├── layout.tsx             ← الهيكل العام
│   │   ├── page.tsx               ← تسجيل الدخول
│   │   ├── dashboard/             ← لوحة المعلومات
│   │   ├── users/                 ← إدارة المستخدمين
│   │   ├── lessons/               ← إدارة الدروس
│   │   ├── quizzes/               ← إدارة الاختبارات
│   │   ├── logs/                  ← السجلات
│   │   └── settings/              ← الإعدادات
│   ├── components/                ← المكونات (أزرار، جداول، نماذج...)
│   ├── services/                  ← اتصال بالـ API
│   └── types/                     ← تعريفات TypeScript
├── package.json                   ← قائمة المكتبات
├── tailwind.config.js
└── .env.local.example
```

---

# الخطوة 3: طريقة العمل مع Git

## أول مرة: إنشاء Branch خاص فيك

```bash
# أنشئي branch باسم واضح:
git checkout -b feature/اسم-الفيتشر

# مثال:
git checkout -b feature/auth-router
git checkout -b feature/student-dashboard
git checkout -b feature/admin-users
```

## كل ما تخلصي شغل: ارفعيه

```bash
# شوفي الملفات اللي تغيرت:
git status

# أضيفي الملفات:
git add .

# سجّلي التغيير:
git commit -m "وصف قصير لشغلك بالعربي أو الانجليزي"

# ارفعيه على GitHub:
git push origin feature/اسم-الفيتشر
```

## دمج شغلك مع المشروع الرئيسي

1. ادخلي GitHub في المتصفح
2. اضغطي **Pull Requests** → **New Pull Request**
3. اختاري branch الخاص فيك
4. اكتبي وصف لشغلك
5. اضغطي **Create Pull Request**

## جلب آخر تحديثات الفريق

```bash
# روحي للبرانش الرئيسي:
git checkout main

# حمّلي آخر التحديثات:
git pull origin main

# ارجعي لبرانشك:
git checkout feature/اسم-الفيتشر

# ادمجي التحديثات:
git merge main
```

---

# الفرق

| القسم | الأعضاء | التقنيات |
|-------|---------|----------|
| Backend + DB | مشاعل، فاطمة، رنيم | FastAPI + PostgreSQL |
| AI Core | فرح، ريناد، فدوه | EasyOCR + Azure TTS + OpenAI |
| Flutter | ديمة، رهف، حياة | Flutter + Provider + Firebase |
| Admin | جود، جود2 | Next.js + Tailwind + Firebase |

---

# مشاكل شائعة

| المشكلة | الحل |
|---------|------|
| `python` أو `flutter` أو `node` غير معروف | ما انضاف للـ PATH — أعيدي التثبيت مع تفعيل خيار PATH |
| `pip install` يعطي خطأ صلاحيات | على Mac استخدمي `pip3`، على Windows شغّلي CMD كمسؤول |
| `flutter doctor` يظهر أخطاء | اتبعي التعليمات اللي تظهر واحدة واحدة |
| `npm install` بطيء جداً | الإنترنت بطيء أو استخدمي `npm install --legacy-peer-deps` |
| `psql` غير معروف | PostgreSQL ما انضاف للـ PATH — أعيدي التثبيت |
| `git push` يطلب كلمة مرور | استخدمي GitHub Desktop أو سوّي SSH Key |
| الملف `.env` مو موجود | لازم تنشئيه يدوياً — راجعي قسم "إعداد ملف البيئة" |
