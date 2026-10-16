import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../exam_controller.dart';
import '../models.dart';
import 'result_screen.dart';

const _letters = ['A', 'B', 'C', 'D', 'E'];

String formatClock(Duration d) {
  final m = d.inMinutes.toString().padLeft(2, '0');
  final s = (d.inSeconds % 60).toString().padLeft(2, '0');
  return '$m:$s';
}

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key, required this.exam});

  final Exam exam;

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  late final ExamController _controller = ExamController(widget.exam)..addListener(_onChange);
  late final Timer _timer;
  bool _leaving = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _controller.tick());
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller
      ..removeListener(_onChange)
      ..dispose();
    super.dispose();
  }

  void _onChange() {
    final result = _controller.result;
    if (result != null && !_leaving) {
      _leaving = true;
      _timer.cancel();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
      );
      return;
    }
    setState(() {});
  }

  Future<void> _confirmSubmit() async {
    final unanswered = _controller.paper.length - _controller.answeredCount;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit exam?'),
        content: Text(unanswered == 0
            ? 'You have answered every question.'
            : 'You still have $unanswered unanswered question${unanswered == 1 ? '' : 's'}.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Keep writing')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Submit')),
        ],
      ),
    );
    if (ok == true) _controller.submit();
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    final theme = Theme.of(context);
    final lowTime = c.remaining < const Duration(minutes: 1);

    return CallbackShortcuts(
      bindings: {
        for (var i = 0; i < c.currentQuestion.optionOrder.length; i++)
          SingleActivator(LogicalKeyboardKey(LogicalKeyboardKey.keyA.keyId + i)): () => c.select(i),
        const SingleActivator(LogicalKeyboardKey.keyN): c.next,
        const SingleActivator(LogicalKeyboardKey.arrowRight): c.next,
        const SingleActivator(LogicalKeyboardKey.keyP): c.previous,
        const SingleActivator(LogicalKeyboardKey.arrowLeft): c.previous,
        const SingleActivator(LogicalKeyboardKey.keyF): c.toggleFlag,
      },
      child: Focus(
        autofocus: true,
        child: PopScope(
          canPop: false,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(widget.exam.subject),
              actions: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: lowTime ? theme.colorScheme.errorContainer : theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 18, color: lowTime ? theme.colorScheme.onErrorContainer : null),
                      const SizedBox(width: 6),
                      Text(
                        formatClock(c.remaining),
                        semanticsLabel: 'Time left ${formatClock(c.remaining)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontFeatures: const [FontFeature.tabularFigures()],
                          color: lowTime ? theme.colorScheme.onErrorContainer : null,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: FilledButton(onPressed: _confirmSubmit, child: const Text('Submit')),
                ),
              ],
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 840;
                final question = _QuestionPanel(controller: c);
                final navigator = _QuestionNavigator(controller: c);
                if (wide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: question),
                      SizedBox(width: 300, child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: navigator)),
                    ],
                  );
                }
                return Column(
                  children: [
                    Expanded(child: question),
                    Material(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        child: navigator,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _QuestionPanel extends StatelessWidget {
  const _QuestionPanel({required this.controller});

  final ExamController controller;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final theme = Theme.of(context);
    final q = c.currentQuestion;
    final options = q.displayedOptions;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            Text('Question ${c.current + 1} of ${c.paper.length}',
                style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary)),
            const Spacer(),
            TextButton.icon(
              onPressed: c.toggleFlag,
              icon: Icon(c.flagged[c.current] ? Icons.flag : Icons.outlined_flag),
              label: Text(c.flagged[c.current] ? 'Flagged' : 'Flag for review'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(q.question.prompt, style: theme.textTheme.titleLarge),
        const SizedBox(height: 20),
        for (var i = 0; i < options.length; i++) ...[
          _OptionTile(
            letter: _letters[i],
            text: options[i],
            selected: c.answers[c.current] == i,
            onTap: () => c.select(i),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: c.current == 0 ? null : c.previous,
              icon: const Icon(Icons.chevron_left),
              label: const Text('Previous'),
            ),
            const Spacer(),
            FilledButton.tonalIcon(
              onPressed: c.current == c.paper.length - 1 ? null : c.next,
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.chevron_right),
              label: const Text('Next'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Keyboard: A–D to answer, N / P for next and previous, F to flag.',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.letter, required this.text, required this.selected, required this.onTap});

  final String letter;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? scheme.primaryContainer : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: selected ? scheme.primary : scheme.outlineVariant, width: selected ? 2 : 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: selected ? scheme.primary : scheme.surface,
                  child: Text(letter, style: TextStyle(color: selected ? scheme.onPrimary : scheme.onSurface, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 14),
                Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuestionNavigator extends StatelessWidget {
  const _QuestionNavigator({required this.controller});

  final ExamController controller;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${c.answeredCount} of ${c.paper.length} answered', style: theme.textTheme.labelLarge),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < c.paper.length; i++)
              _NavCell(
                number: i + 1,
                answered: c.answers[i] != null,
                flagged: c.flagged[i],
                current: i == c.current,
                onTap: () => c.goTo(i),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 14,
          runSpacing: 4,
          children: [
            _Legend(color: scheme.primary, label: 'Answered'),
            _Legend(color: Colors.amber.shade700, label: 'Flagged'),
            _Legend(color: scheme.surfaceContainerHighest, label: 'Not answered'),
          ],
        ),
      ],
    );
  }
}

class _NavCell extends StatelessWidget {
  const _NavCell({required this.number, required this.answered, required this.flagged, required this.current, required this.onTap});

  final int number;
  final bool answered;
  final bool flagged;
  final bool current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Color bg = flagged
        ? Colors.amber.shade700
        : answered
            ? scheme.primary
            : scheme.surfaceContainerHighest;
    final Color fg = flagged || answered ? Colors.white : scheme.onSurface;

    return Semantics(
      label: 'Question $number${answered ? ', answered' : ''}${flagged ? ', flagged' : ''}',
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: current ? Border.all(color: scheme.onSurface, width: 2.5) : null,
          ),
          child: Text('$number', style: TextStyle(color: fg, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
