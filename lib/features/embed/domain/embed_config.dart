import 'assembly_file.dart';

enum LibraryMode { automatic, explicit }

enum ConfigIssue {
  missingInput('Select an input assembly.'),
  nativeInput('The input is a native DLL. Select a managed .NET assembly.'),
  noLibrariesSelected('Add at least one library or switch to automatic resolution.'),
  nativeLibrary('Remove native libraries. Only managed .NET assemblies can be embedded.'),
  missingOutput('Choose an output directory.');

  const ConfigIssue(this.message);
  final String message;
}

/// Immutable snapshot of everything the user configured.
class EmbedConfig {
  const EmbedConfig({
    this.inputAssembly,
    this.libraryMode = LibraryMode.automatic,
    this.libraries = const [],
    this.outputDirectory,
    this.generatePdb = true,
    this.overwriteOutput = true,
  });

  final AssemblyFile? inputAssembly;
  final LibraryMode libraryMode;
  final List<AssemblyFile> libraries;
  final String? outputDirectory;
  final bool generatePdb;
  final bool overwriteOutput;

  List<ConfigIssue> get issues {
    final result = <ConfigIssue>[];
    final input = inputAssembly;
    if (input == null) {
      result.add(ConfigIssue.missingInput);
    } else if (!input.isManaged) {
      result.add(ConfigIssue.nativeInput);
    }
    if (libraryMode == LibraryMode.explicit) {
      if (libraries.isEmpty) {
        result.add(ConfigIssue.noLibrariesSelected);
      } else if (libraries.any((l) => !l.isManaged)) {
        result.add(ConfigIssue.nativeLibrary);
      }
    }
    // final out = outputDirectory;
    // if (out == null || out.isEmpty) result.add(ConfigIssue.missingOutput);
    return result;
  }

  bool get isValid => issues.isEmpty;

  EmbedConfig copyWith({
    AssemblyFile? inputAssembly,
    LibraryMode? libraryMode,
    List<AssemblyFile>? libraries,
    String? outputDirectory,
    bool? generatePdb,
    bool? overwriteOutput,
  }) {
    return EmbedConfig(
      inputAssembly: inputAssembly ?? this.inputAssembly,
      libraryMode: libraryMode ?? this.libraryMode,
      libraries: libraries ?? this.libraries,
      outputDirectory: outputDirectory ?? this.outputDirectory,
      generatePdb: generatePdb ?? this.generatePdb,
      overwriteOutput: overwriteOutput ?? this.overwriteOutput,
    );
  }
}
