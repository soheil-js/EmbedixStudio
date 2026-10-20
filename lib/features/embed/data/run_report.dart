import '../../../core/utils/path_utils.dart';
import '../domain/embed_config.dart';
import '../domain/run_result.dart';

/// Shared helpers that turn a config / output listing into report data.
abstract final class RunReport {
  static List<RunStep> successSteps(EmbedConfig config) {
    return [
      RunStep('Read ${config.inputAssembly?.name ?? 'input assembly'}'),
      if (config.libraryMode == LibraryMode.explicit)
        for (final lib in config.libraries) RunStep('Embedded ${lib.name}')
      else
        const RunStep('Resolved referenced libraries automatically'),
      RunStep(config.generatePdb ? 'Wrote assembly and debug symbols' : 'Wrote assembly'),
    ];
  }

  static List<OutputFile> expectedOutputs(EmbedConfig config) {
    final name = config.inputAssembly?.name;
    if (name == null) return const [];
    return [
      describe(name),
      if (config.generatePdb) describe(PathUtils.withExtension(name, 'pdb')),
    ];
  }

  static OutputFile describe(String fileName) {
    final description = switch (PathUtils.extensionOf(fileName)) {
      'dll' => 'Managed assembly · libraries embedded',
      'exe' => 'Companion executable',
      'pdb' => 'Generated debug symbols',
      'json' => 'Runtime configuration',
      _ => 'Output file',
    };
    return OutputFile(name: fileName, description: description);
  }
}
