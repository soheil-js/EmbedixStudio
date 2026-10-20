import 'dart:io';

import 'package:file_picker/file_picker.dart';

/// Abstraction over native dialogs / OS shell so the UI stays testable.
abstract interface class FileSystemService {
  Future<String?> pickAssembly();
  Future<List<String>> pickLibraries();
  Future<String?> pickDirectory();
  Future<void> openDirectory(String path);
}

class NativeFileSystemService implements FileSystemService {
  const NativeFileSystemService();

  @override
  Future<String?> pickAssembly() async {
    final result = await FilePicker.pickFile(
      windowsOptions: WindowsOptions(lockParentWindow: true),
      linuxOptions: LinuxOptions(lockParentWindow: true),
      dialogTitle: 'Select input assembly',
      type: FileType.custom,
      allowedExtensions: ['dll', 'exe'],
    );

    if (result == null) {
      return null;
    }

    return result.path;
  }

  @override
  Future<List<String>> pickLibraries() async {
    final result = await FilePicker.pickFiles(
      windowsOptions: WindowsOptions(lockParentWindow: true),
      linuxOptions: LinuxOptions(lockParentWindow: true),
      dialogTitle: 'Select libraries to embed',
      type: FileType.custom,
      allowedExtensions: ['dll'],
    );

    return result.map((f) => f.path).whereType<String>().toList();
  }

  @override
  Future<String?> pickDirectory() {
    return FilePicker.getDirectoryPath(
      windowsOptions: WindowsOptions(lockParentWindow: true),
      linuxOptions: LinuxOptions(lockParentWindow: true),
      dialogTitle: 'Select output directory',
      
    );
  }

  @override
  Future<void> openDirectory(String path) async {
    final command = Platform.isWindows
        ? 'explorer.exe'
        : Platform.isMacOS
        ? 'open'
        : 'xdg-open';
    await Process.start(command, [path], mode: ProcessStartMode.detached);
  }
}
