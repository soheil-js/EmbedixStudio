import 'embed_config.dart';

enum RunStatus { idle, running, success, failure }

class RunStep {
  const RunStep(this.label, {this.succeeded = true});
  final String label;
  final bool succeeded;
}

class OutputFile {
  const OutputFile({required this.name, required this.description});
  final String name;
  final String description;
}

class EmbedRunResult {
  const EmbedRunResult({
    required this.exitCode,
    required this.finishedAt,
    required this.duration,
    required this.outputDirectory,
    required this.libraryMode,
    required this.libraryCount,
    required this.pdbGenerated,
    this.steps = const [],
    this.consoleLines = const [],
    this.outputFiles = const [],
    this.errorMessage,
  });

  factory EmbedRunResult.failed({
    required EmbedConfig config,
    required String message,
    int exitCode = -1,
    Duration duration = Duration.zero,
    List<String> consoleLines = const [],
  }) {
    return EmbedRunResult(
      exitCode: exitCode,
      finishedAt: DateTime.now(),
      duration: duration,
      outputDirectory: config.outputDirectory ?? '',
      libraryMode: config.libraryMode,
      libraryCount: config.libraries.length,
      pdbGenerated: false,
      steps: [RunStep(message, succeeded: false)],
      consoleLines: consoleLines,
      errorMessage: message,
    );
  }

  final int exitCode;
  final DateTime finishedAt;
  final Duration duration;
  final String outputDirectory;
  final LibraryMode libraryMode;
  final int libraryCount;
  final bool pdbGenerated;
  final List<RunStep> steps;
  final List<String> consoleLines;
  final List<OutputFile> outputFiles;
  final String? errorMessage;

  bool get isSuccess => exitCode == 0;
}
