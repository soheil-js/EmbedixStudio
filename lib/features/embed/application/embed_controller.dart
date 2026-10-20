import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/utils/path_utils.dart';
import '../data/assembly_inspector.dart';
import '../data/embed_runner.dart';
import '../data/file_system_service.dart';
import '../domain/assembly_file.dart';
import '../domain/embed_command.dart';
import '../domain/embed_config.dart';
import '../domain/run_result.dart';

/// Single source of truth for the Embed workbench screen.
///
/// State lives in `Rx` fields; widgets read it through the getters below
/// inside an `Obx`, so only the parts that read a value rebuild.
class EmbedController extends GetxController {
  EmbedController({
    required this.workingDirectory,
    required this._fileSystem,
    required this._inspector,
    required this._runner,
    EmbedCommandBuilder commandBuilder = const EmbedCommandBuilder(),
  }) : _builder = commandBuilder;

  final String workingDirectory;
  final FileSystemService _fileSystem;
  final AssemblyInspector _inspector;
  final EmbedRunner _runner;
  final EmbedCommandBuilder _builder;

  final Rx<EmbedConfig> _config = Rx<EmbedConfig>(const EmbedConfig());
  final Rx<RunStatus> _status = Rx<RunStatus>(RunStatus.idle);
  final Rxn<EmbedRunResult> _lastResult = Rxn<EmbedRunResult>();
  final RxInt _reportTab = 0.obs;

  EmbedConfig get config => _config.value;
  RunStatus get status => _status.value;
  EmbedRunResult? get lastResult => _lastResult.value;
  int get reportTab => _reportTab.value;
  bool get isRunning => status == RunStatus.running;
  bool get canRun => config.isValid && !isRunning;

  /// Command rendered with paths relative to [workingDirectory].
  EmbedCommand get previewCommand => _builder.build(
    config,
    format: (p) => PathUtils.relativeTo(p, workingDirectory),
  );

  String displayPath(String path) =>
      PathUtils.relativeTo(path, workingDirectory);

  // ---- cli ---------------------------------------------------------------

  Future<void> openCliDirectory() async {
    final cliDirectory = PathUtils.join(workingDirectory, "bin");
    if (await Directory(cliDirectory).exists()) {
      await _fileSystem.openDirectory(cliDirectory);
    } else {
      await _fileSystem.openDirectory(workingDirectory);
    }
  }

  // ---- input -------------------------------------------------------------
  Future<void> pickInputAssembly() async {
    final path = await _fileSystem.pickAssembly();
    if (path == null) return;
    final managed = await _inspector.isManagedAssembly(path);
    _update(
      config.copyWith(
        inputAssembly: AssemblyFile(path: path, isManaged: managed),
      ),
    );
  }

  // ---- libraries ---------------------------------------------------------
  void setLibraryMode(LibraryMode mode) =>
      _update(config.copyWith(libraryMode: mode));

  Future<void> addLibraries() async {
    final paths = await _fileSystem.pickLibraries();
    if (paths.isEmpty) return;
    final known = {for (final l in config.libraries) l.path.toLowerCase()};
    final added = <AssemblyFile>[];
    for (final path in paths) {
      if (!known.add(path.toLowerCase())) continue;
      added.add(
        AssemblyFile(
          path: path,
          isManaged: await _inspector.isManagedAssembly(path),
        ),
      );
    }
    if (added.isEmpty) return;
    _update(config.copyWith(libraries: [...config.libraries, ...added]));
  }

  void removeLibrary(AssemblyFile library) {
    _update(
      config.copyWith(
        libraries: config.libraries
            .where((l) => l.path != library.path)
            .toList(),
      ),
    );
  }

  // ---- output ------------------------------------------------------------
  Future<void> pickOutputDirectory() async {
    final path = await _fileSystem.pickDirectory();
    if (path == null) return;
    _update(config.copyWith(outputDirectory: path));
  }

  void setGeneratePdb(bool value) =>
      _update(config.copyWith(generatePdb: value));
  void setOverwriteOutput(bool value) =>
      _update(config.copyWith(overwriteOutput: value));

  // ---- report ------------------------------------------------------------
  void setReportTab(int index) => _reportTab.value = index;

  // ---- actions -----------------------------------------------------------
  Future<void> copyCommand() {
    return Clipboard.setData(ClipboardData(text: previewCommand.fullDisplay));
  }

  Future<void> openOutputDirectory(String output) async {
    if (output.isEmpty) return;

    await _fileSystem.openDirectory(output);
  }

  Future<void> run() async {
    if (!canRun) return;
    _status.value = RunStatus.running;

    final snapshot = config;
    EmbedRunResult result;
    try {
      result = await _runner.run(
        command: _builder.build(snapshot), // absolute paths
        config: snapshot,
        workingDirectory: workingDirectory,
      );
    } catch (e) {
      result = EmbedRunResult.failed(
        config: snapshot,
        message: 'Unexpected error: $e',
      );
    }

    if (isClosed) return; // the screen was closed while the CLI was running
    _reportTab.value = 0; // a new report always opens on "Run summary"
    _lastResult.value = result;
    _status.value = result.isSuccess ? RunStatus.success : RunStatus.failure;
  }

  // ---- internals ---------------------------------------------------------
  void _update(EmbedConfig next) => _config.value = next;
}
