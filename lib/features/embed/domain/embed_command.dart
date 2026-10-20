import 'embed_config.dart';

typedef PathFormatter = String Function(String path);

String _identity(String path) => path;

class CommandToken {
  const CommandToken(this.value, {this.quoted = false});
  final String value;
  final bool quoted;
}

/// A CLI invocation, usable both for display and for [Process] execution.
class EmbedCommand {
  const EmbedCommand({
    required this.executable,
    required this.subcommand,
    required this.options,
  });

  final String executable;
  final String subcommand;
  final List<CommandToken> options;

  /// Raw argument list (no shell quoting) for `Process.run`.
  List<String> get args => [subcommand, for (final t in options) t.value];

  /// `.\Embedix.CLI.exe embed`
  String get headDisplay => '$executable $subcommand';

  /// ` -i ".\MyApp.dll" -o ".\out"` (leading space included, empty when no options)
  String get optionsDisplay => options.isEmpty
      ? ''
      : ' ${options.map((t) => t.quoted ? '"${t.value}"' : t.value).join(' ')}';

  String get fullDisplay => '$headDisplay$optionsDisplay';
}

class EmbedCommandBuilder {
  const EmbedCommandBuilder({this.executable = r'.\Embedix.CLI.exe'});

  final String executable;

  /// [format] lets the caller choose how paths are rendered
  /// (relative for the preview, absolute for execution).
  EmbedCommand build(EmbedConfig config, {PathFormatter format = _identity}) {
    final options = <CommandToken>[];
    final input = config.inputAssembly;
    if (input != null) {
      options
        ..add(const CommandToken('-i'))
        ..add(CommandToken(format(input.path), quoted: true));
    }
    final output = config.outputDirectory;
    if (output != null && output.isNotEmpty) {
      options
        ..add(const CommandToken('-o'))
        ..add(CommandToken(format(output), quoted: true));
    }
    if (config.libraryMode == LibraryMode.explicit && config.libraries.isNotEmpty) {
      options.add(const CommandToken('-l'));
      for (final lib in config.libraries) {
        options.add(CommandToken(format(lib.path), quoted: true));
      }
    }
    if (!config.generatePdb) options.add(const CommandToken('--no-pdb'));
    if (!config.overwriteOutput) options.add(const CommandToken('--no-overwrite'));

    return EmbedCommand(executable: executable, subcommand: 'embed', options: options);
  }
}
