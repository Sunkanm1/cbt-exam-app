import 'dart:math';

import 'package:cbt_exam/exam_controller.dart';
import 'package:cbt_exam/models.dart';
import 'package:cbt_exam/question_bank.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final exam = exams.first;

  test('every question bank answer index points at a real option', () {
    for (final e in exams) {
      for (final q in e.questions) {
        expect(q.answer, inInclusiveRange(0, q.options.length - 1), reason: q.prompt);
        expect(q.options.toSet().length, q.options.length, reason: 'duplicate option in ${q.prompt}');
      }
    }
  });

  test('paper contains every question once with options shuffled consistently', () {
    final c = ExamController(exam, random: Random(1));
    expect(c.paper.map((p) => p.question).toSet(), exam.questions.toSet());
    for (final p in c.paper) {
      expect(p.displayedOptions[p.correctPosition], p.question.options[p.question.answer]);
    }
  });

  test('answering every question correctly scores 100% and A1', () {
    final c = ExamController(exam, random: Random(2));
    for (var i = 0; i < c.paper.length; i++) {
      c.goTo(i);
      c.select(c.paper[i].correctPosition);
    }
    c.submit();
    expect(c.result!.correct, exam.questions.length);
    expect(c.result!.percent, 100);
    expect(c.result!.grade, 'A1');
    expect(c.result!.timedOut, isFalse);
  });

  test('selecting the same option again clears the answer', () {
    final c = ExamController(exam, random: Random(3));
    c.select(0);
    expect(c.answers[0], 0);
    c.select(0);
    expect(c.answers[0], isNull);
  });

  test('time running out submits automatically and freezes the paper', () {
    final c = ExamController(exam, random: Random(4));
    c.select(c.currentQuestion.correctPosition);
    c.tick(exam.duration);
    expect(c.isSubmitted, isTrue);
    expect(c.result!.timedOut, isTrue);
    expect(c.result!.correct, 1);
    expect(c.result!.unanswered, exam.questions.length - 1);
    expect(c.result!.timeTaken, exam.duration);

    c.next();
    c.select(0);
    expect(c.result!.unanswered, exam.questions.length - 1);
  });

  test('navigation stays within the paper', () {
    final c = ExamController(exam, random: Random(5));
    c.previous();
    expect(c.current, 0);
    c.goTo(c.paper.length - 1);
    c.next();
    expect(c.current, c.paper.length - 1);
  });

  test('WAEC grade boundaries', () {
    expect(waecGrade(75), 'A1');
    expect(waecGrade(74.9), 'B2');
    expect(waecGrade(50), 'C6');
    expect(waecGrade(49), 'D7');
    expect(waecGrade(40), 'E8');
    expect(waecGrade(39), 'F9');
  });
}
