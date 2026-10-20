import '../../../core/widgets/widgets.dart';
import '../application/embed_controller.dart';
import '../domain/embed_config.dart';
import '../domain/run_result.dart';

/// Maps controller state to the labels/tones shown across the screen,
/// so every widget reports the same status.
class StatusView {
  const StatusView({
    required this.readinessLabel,
    required this.readinessTone,
    required this.readinessDot,
    required this.runLabel,
    required this.runTone,
    required this.summary,
    required this.footer,
    required this.message,
  });

  final String readinessLabel;
  final BadgeTone readinessTone;
  final bool readinessDot;
  final String runLabel;
  final BadgeTone runTone;
  final String summary;
  final String footer;
  final String message;
}

StatusView presentStatus(EmbedController c) {
  final config = c.config;
  final issues = config.issues;
  final valid = issues.isEmpty;

  final String summary;
  if (!valid) {
    summary = issues.first.message;
  } else {
    final input = config.inputAssembly!.name;
    final count = config.libraries.length;
    summary = config.libraryMode == LibraryMode.automatic
        ? '$input + automatic resolution'
        : '$input + $count selected ${count == 1 ? 'library' : 'libraries'}';
  }

  final (String readinessLabel, BadgeTone readinessTone, bool readinessDot) = c.isRunning
      ? ('RUNNING', BadgeTone.neutral, false)
      : valid
          ? ('READY', BadgeTone.success, true)
          : ('INCOMPLETE', BadgeTone.neutral, false);

  final (String runLabel, BadgeTone runTone) = switch (c.status) {
    RunStatus.idle => ('NOT RUN', BadgeTone.neutral),
    RunStatus.running => ('RUNNING', BadgeTone.neutral),
    RunStatus.success => ('SUCCEEDED', BadgeTone.success),
    RunStatus.failure => ('FAILED', BadgeTone.danger),
  };

  final String footer = c.isRunning
      ? 'Embedding in progress…'
      : !valid
          ? 'Configuration incomplete'
          : switch (c.status) {
              RunStatus.success => 'Last run succeeded',
              RunStatus.failure => 'Last run failed',
              _ => 'Configuration ready · Not yet executed',
            };

  final String message = c.isRunning
      ? 'Embedding in progress. The report below is replaced when the run finishes.'
      : !valid
          ? issues.first.message
          : 'Ready to start. The next execution will replace the report below.';

  return StatusView(
    readinessLabel: readinessLabel,
    readinessTone: readinessTone,
    readinessDot: readinessDot,
    runLabel: runLabel,
    runTone: runTone,
    summary: summary,
    footer: footer,
    message: message,
  );
}
