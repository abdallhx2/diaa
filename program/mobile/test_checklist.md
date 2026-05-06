# Flutter App — Chrome Test Checklist

Backend must be running at localhost:8000 before testing.
Run: `cd mobile && flutter run -d chrome`

## Phase 1: App Launch & Auth
- [ ] Splash screen shows with ضياء branding
- [ ] Navigates to role selection screen
- [ ] Student/Parent tab switcher works
- [ ] Student login form renders (email + password fields)
- [ ] Parent login form renders
- [ ] Parent register form renders

## Phase 2: Student Dashboard
- [ ] After login, student dashboard loads
- [ ] Bottom navigation shows 3 tabs (home, results, account)
- [ ] Home tab shows menu cards (subjects, scan, practice)
- [ ] Results tab shows quiz history
- [ ] Account tab shows student info
- [ ] RTL layout is correct (right-to-left)
- [ ] Purple theme and Tajawal font visible

## Phase 3: Learning Flow
- [ ] Subject selection screen lists subjects (لغتي, رياضيات, علوم, etc.)
- [ ] Tapping a subject shows lesson list
- [ ] Lesson list shows available lessons for that subject
- [ ] Lesson detail screen opens with 4 tabs
- [ ] Summary tab shows lesson text
- [ ] Quiz tab shows questions
- [ ] AI Chat tab allows sending messages

## Phase 4: Quiz Flow
- [ ] Practice selection screen shows quiz types (reading, writing, comprehension)
- [ ] Reading quiz screen loads with questions
- [ ] Writing quiz screen loads
- [ ] Comprehension quiz screen loads
- [ ] Selecting an answer highlights it
- [ ] Quiz result screen shows score after submission

## Phase 5: Parent Flow
- [ ] Parent dashboard loads after login
- [ ] My children screen lists children
- [ ] Child progress screen shows stats
- [ ] Reports screen shows weekly/monthly data

## Phase 6: UI Quality
- [ ] All text is in Arabic
- [ ] Touch targets are at least 48dp
- [ ] Colors match purple palette (#8B5FBF, #61398F)
- [ ] Loading states show spinners
- [ ] Error states show Arabic messages
- [ ] Navigation back buttons work correctly
