import 'dart:math';

import 'package:flutter/foundation.dart';

import 'models.dart';

/// Holds the state of one exam attempt: the shuffled paper, the student's
/// answers and flags, the current question and the countdown.
///
/// Time is driven from outside through [tick], so the widget owns the timer
/// and tests can move the clock without waiting.
class ExamController extends ChangeNotifier {
  ExamController(this.exam, {Random? random})
      : paper = _buildPaper(exam, random ?? Random()),
        remaining = exam.duration {
    answers = List<int?>.filled(paper.length, null);
    flagged = List<bool>.filled(paper.length, false);
  }

  final Exam exam;
  final List<PaperQuestion> paper;
  late final List<int?> answers;
  late final List<bool> flagged;

  Duration remaining;
  int current = 0;
  ExamResult? result;

  bool get isSubmitted => result != null;
  int get answeredCount => answers.where((a) => a != null).length;
  PaperQuestion get currentQuestion => paper[current];

  static List<PaperQuestion> _buildPaper(Exam exam, Random random) {
    final questions = [...exam.questions]..shuffle(random);
    return [
      for (final q in questions)
        PaperQuestion(
          q,
          List<int>.generate(q.options.length, (i) => i)..shuffle(random),
        ),
    ];
  }

  void select(int position) {
    if (isSubmitted) return;
    answers[current] = answers[current] == position ? null : position;
    notifyListeners();
  }

  void toggleFlag() {
    if (isSubmitted) return;
    flagged[current] = !flagged[current];
    notifyListeners();
  }

  void goTo(int index) {
    if (index < 0 || index >= paper.length || index == current) return;
    current = index;
    notifyListeners();
  }

  void next() => goTo(current + 1);
  void previous() => goTo(current - 1);

  /// Advances the clock by [elapsed]; submits automatically when time is up.
  void tick([Duration elapsed = const Duration(seconds: 1)]) {
    if (isSubmitted) return;
    remaining -= elapsed;
    if (remaining <= Duration.zero) {
      remaining = Duration.zero;
      _finish(timedOut: true);
    } else {
      notifyListeners();
    }
  }

  void submit() {
    if (isSubmitted) return;
    _finish(timedOut: false);
  }

  void _finish({required bool timedOut}) {
    result = ExamResult(
      exam: exam,
      paper: paper,
      answers: List.unmodifiable(answers),
      timeTaken: exam.duration - remaining,
      timedOut: timedOut,
    );
    notifyListeners();
  }
}
