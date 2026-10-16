# CBT Exam Practice

A Flutter app for timed, JAMB-style computer-based test practice. It runs on the web, Android and iOS from one codebase.

**Live demo:** https://cbt-exam-app.vercel.app

## Features

- Mathematics, English Language and Physics papers, each with 10 questions and a 15 minute timer
- Questions and options shuffled for every attempt
- Question navigator showing answered, flagged and current questions
- Flag questions to review later; tap an answer again to clear it
- Paper submitted automatically when time runs out
- Instant marking with a WAEC-style grade (A1 to F9), plus a review of every question with the correct answer and a worked explanation
- Keyboard shortcuts on desktop: A–D to answer, N / P (or arrow keys) to move, F to flag
- Responsive layout (side navigator on wide screens, bottom navigator on phones) and light/dark theme

## Structure

| File | What it does |
|---|---|
| `lib/models.dart` | Question, Exam, shuffled paper question, result and WAEC grading |
| `lib/exam_controller.dart` | State of one attempt: answers, flags, navigation, countdown, submission. The clock is driven through `tick()`, so tests can run time forward instantly |
| `lib/question_bank.dart` | The exam papers |
| `lib/screens/` | Exam list, exam screen and result screen |

## Run

```bash
flutter pub get
flutter run -d chrome     # or an Android/iOS device
flutter test              # controller unit tests and a full exam widget test
flutter build web         # static build in build/web
```
