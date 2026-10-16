/// A single multiple-choice question. [answer] is the index into [options]
/// of the correct option, in the order the options are written here.
class Question {
  const Question({
    required this.prompt,
    required this.options,
    required this.answer,
    this.explanation,
  });

  final String prompt;
  final List<String> options;
  final int answer;
  final String? explanation;
}

class Exam {
  const Exam({
    required this.id,
    required this.subject,
    required this.description,
    required this.duration,
    required this.questions,
  });

  final String id;
  final String subject;
  final String description;
  final Duration duration;
  final List<Question> questions;
}

/// One question as a student sees it in a paper: its options are shuffled,
/// so [optionOrder] maps displayed position -> index in [Question.options].
class PaperQuestion {
  const PaperQuestion(this.question, this.optionOrder);

  final Question question;
  final List<int> optionOrder;

  List<String> get displayedOptions =>
      [for (final i in optionOrder) question.options[i]];

  /// Displayed position of the correct option.
  int get correctPosition => optionOrder.indexOf(question.answer);
}

/// WAEC-style grade for a percentage score.
String waecGrade(double percent) {
  if (percent >= 75) return 'A1';
  if (percent >= 70) return 'B2';
  if (percent >= 65) return 'B3';
  if (percent >= 60) return 'C4';
  if (percent >= 55) return 'C5';
  if (percent >= 50) return 'C6';
  if (percent >= 45) return 'D7';
  if (percent >= 40) return 'E8';
  return 'F9';
}

class ExamResult {
  const ExamResult({
    required this.exam,
    required this.paper,
    required this.answers,
    required this.timeTaken,
    required this.timedOut,
  });

  final Exam exam;
  final List<PaperQuestion> paper;

  /// Displayed option position chosen for each paper question, or null.
  final List<int?> answers;
  final Duration timeTaken;
  final bool timedOut;

  int get correct => [
        for (var i = 0; i < paper.length; i++)
          if (answers[i] == paper[i].correctPosition) i
      ].length;

  int get unanswered => answers.where((a) => a == null).length;

  double get percent => paper.isEmpty ? 0 : correct * 100 / paper.length;

  String get grade => waecGrade(percent);
}
