import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:embedix_studio/core/utils/path_utils.dart';

import '../domain/embed_command.dart';
import '../domain/embed_config.dart';
import '../domain/run_result.dart';
import 'run_report.dart';

abstract interface class EmbedRunner {
  Future<EmbedRunResult> run({
    required EmbedCommand command,
    required EmbedConfig config,
    required String workingDirectory,
  });
}

/// Runs the real `Embedix.CLI` executable.
class CliEmbedRunner implements EmbedRunner {
  const CliEmbedRunner({required this.cliPath});

  final String cliPath;

  @override
  Future<EmbedRunResult> run({
    required EmbedCommand command,
    required EmbedConfig config,
    required String workingDirectory,
  }) async {
    final stopwatch = Stopwatch()..start();
    try {
      final (exitCode, out, err) = await Isolate.run(() async {
        final p = await Process.run(
          cliPath,
          command.args,
          workingDirectory: workingDirectory,
        );
        return (p.exitCode, '${p.stdout}', '${p.stderr}');
      });
      stopwatch.stop();

      final lines = const LineSplitter()
          .convert('$out\n$err')
          .where((l) => l.trim().isNotEmpty)
          .toList();

      if (exitCode != 0) {
        return EmbedRunResult.failed(
          config: config,
          message: 'Embedix.CLI exited with code $exitCode.',
          exitCode: exitCode,
          duration: stopwatch.elapsed,
          consoleLines: lines,
        );
      }

      final resolved = await _resolveOutput(config);
      return EmbedRunResult(
        exitCode: 0,
        finishedAt: DateTime.now(),
        duration: stopwatch.elapsed,
        outputDirectory: resolved,
        libraryMode: config.libraryMode,
        libraryCount: config.libraries.length,
        pdbGenerated: config.generatePdb,
        steps: RunReport.successSteps(config),
        consoleLines: lines,
        outputFiles: await _listOutputs(config),
      );
    } on ProcessException catch (e) {
      stopwatch.stop();
      final reason = e.message.replaceAll(RegExp(r'\s*\(at [^)]*\)\s*$'), '');
      return EmbedRunResult.failed(
        config: config,
        message: 'Could not start Embedix.CLI: $reason',
        duration: stopwatch.elapsed,
      );
    }
  }

  Future<String> _resolveOutput(EmbedConfig config) async {
    // 1) Resolve the base path
    String basePath = config.outputDirectory ?? '';

    if (basePath.isEmpty) {
      final inputPath = config.inputAssembly?.path ?? '';
      if (inputPath.isEmpty) return basePath;

      basePath = PathUtils.join(PathUtils.directoryOf(inputPath), 'Embedix');
    }

    // 2) Overwrite mode: use the base path as-is
    if (config.overwriteOutput) return basePath;

    // 3) Non-overwrite mode: use the latest numbered folder
    return await PathUtils.latestNumberedDirectoryAsync(basePath);
  }

  Future<List<OutputFile>> _listOutputs(EmbedConfig config) async {
    final dir = config.outputDirectory;
    if (dir == null) return RunReport.expectedOutputs(config);
    try {
      final files = <String>[];
      await for (final e in Directory(dir).list(followLinks: false)) {
        if (e is File) files.add(PathUtils.fileName(e.path));
      }
      files.sort();
      return files.isEmpty
          ? RunReport.expectedOutputs(config)
          : files.map(RunReport.describe).toList();
    } on FileSystemException {
      return RunReport.expectedOutputs(config);
    }
  }
}
