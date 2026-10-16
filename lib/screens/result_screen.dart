import 'package:flutter/material.dart';

import '../models.dart';
import 'exam_screen.dart';

const _letters = ['A', 'B', 'C', 'D', 'E'];

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.result});

  final ExamResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final passed = result.percent >= 50;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.of(context).pop(result);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${result.exam.subject} result'),
          leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop(result)),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Card(
                  color: passed ? scheme.primaryContainer : scheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        if (result.timedOut)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text('Time up: your paper was submitted automatically.', style: theme.textTheme.bodyMedium),
                          ),
                        Text(result.grade, style: theme.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w800)),
                        Text('${result.percent.round()}%  ·  ${result.correct} of ${result.paper.length} correct',
                            style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(
                          '${result.unanswered} unanswered  ·  time taken ${formatClock(result.timeTaken)}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Review', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                for (var i = 0; i < result.paper.length; i++) _ReviewTile(index: i, result: result),
                const SizedBox(height: 12),
                FilledButton(onPressed: () => Navigator.of(context).pop(result), child: const Text('Back to exams')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.index, required this.result});

  final int index;
  final ExamResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pq = result.paper[index];
    final options = pq.displayedOptions;
    final chosen = result.answers[index];
    final correct = chosen == pq.correctPosition;
    final explanation = pq.question.explanation;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  chosen == null ? Icons.remove_circle_outline : (correct ? Icons.check_circle : Icons.cancel),
                  color: chosen == null ? theme.colorScheme.outline : (correct ? Colors.green.shade600 : theme.colorScheme.error),
                ),
                const SizedBox(width: 8),
                Text('Question ${index + 1}', style: theme.textTheme.labelLarge),
              ],
            ),
            const SizedBox(height: 8),
            Text(pq.question.prompt, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text(
              chosen == null ? 'Not answered' : 'Your answer: ${_letters[chosen]}. ${options[chosen]}',
              style: theme.textTheme.bodyMedium,
            ),
            if (!correct)
              Text(
                'Correct answer: ${_letters[pq.correctPosition]}. ${options[pq.correctPosition]}',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.green.shade700, fontWeight: FontWeight.w600),
              ),
            if (explanation != null) ...[
              const SizedBox(height: 6),
              Text(explanation, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ],
        ),
      ),
    );
  }
}
