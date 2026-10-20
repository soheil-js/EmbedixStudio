import 'dart:io';

import 'package:get/get.dart';

import '../../core/utils/path_utils.dart';
import '../../features/embed/data/assembly_inspector.dart';
import '../../features/embed/data/embed_runner.dart';
import '../../features/embed/data/file_system_service.dart';

const _cliFileName = 'Embedix.CLI.exe';
const _cliFolderName = 'bin';

/// CLI lookup order:
///   1. .\bin\Embedix.CLI.exe
///   2. the bare file name, so Windows searches PATH
String _resolveCliPath() {
  final appDir = PathUtils.directoryOf(Platform.resolvedExecutable);
  final bundled = PathUtils.join(
    PathUtils.join(appDir, _cliFolderName),
    _cliFileName,
  );
  if (File(bundled).existsSync()) return bundled;

  return _cliFileName;
}

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FileSystemService>(
      const NativeFileSystemService(),
      permanent: true,
    );
    Get.put<AssemblyInspector>(const PeAssemblyInspector(), permanent: true);
    Get.put<EmbedRunner>(
      CliEmbedRunner(cliPath: _resolveCliPath()),
      permanent: true,
    );
  }
}
