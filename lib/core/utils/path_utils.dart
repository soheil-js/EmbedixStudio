import 'dart:io';

/// Small, dependency-free path helpers (desktop only).
abstract final class PathUtils {
  static final String separator = Platform.pathSeparator;
  static final RegExp _splitter = RegExp(r'[\\/]');
  static final RegExp _trailing = RegExp(r'[\\/]+$');

  static String fileName(String path) {
    final parts = path.split(_splitter).where((s) => s.isNotEmpty).toList();
    return parts.isEmpty ? path : parts.last;
  }

  static String directoryOf(String path) {
    final i = path.lastIndexOf(_splitter);
    return i <= 0 ? '' : path.substring(0, i);
  }

  static String join(String a, String b) {
    if (a.isEmpty) return b;
    return a.endsWith(separator) ? '$a$b' : '$a$separator$b';
  }

  static String withExtension(String fileName, String extension) {
    final dot = fileName.lastIndexOf('.');
    final stem = dot <= 0 ? fileName : fileName.substring(0, dot);
    return '$stem.$extension';
  }

  static String extensionOf(String fileName) {
    final dot = fileName.lastIndexOf('.');
    return dot < 0 ? '' : fileName.substring(dot + 1).toLowerCase();
  }

  /// Returns `.\sub\file` when [path] is inside [base]; otherwise [path] unchanged.
  static String relativeTo(String path, String base) {
    if (base.isEmpty) return path;
    final p = path.replaceAll('/', separator);
    final b = base.replaceAll('/', separator).replaceAll(_trailing, '');
    final prefix = '$b$separator';
    final inside = Platform.isWindows
        ? p.toLowerCase().startsWith(prefix.toLowerCase())
        : p.startsWith(prefix);
    if (!inside) return path;
    return '.$separator${p.substring(prefix.length)}';
  }

  /// Looks for sibling folders like `folder1`, `folder2`, ... and returns
  /// the one with the highest number. Returns [basePath] if none exist.
  static String latestNumberedDirectory(String basePath) {
    final cleanBase = basePath.replaceAll(RegExp(r'[\\/]+$'), '');
    final parentPath = PathUtils.directoryOf(cleanBase);
    final baseName = PathUtils.fileName(cleanBase);

    if (parentPath.isEmpty) return basePath;

    final parent = Directory(parentPath);
    if (!parent.existsSync()) return basePath;

    // Matches "<baseName><number>" with no space (case-insensitive on Windows)
    final pattern = RegExp(
      '^${RegExp.escape(baseName)}(\\d+)\$',
      caseSensitive: !Platform.isWindows,
    );

    int maxNumber = 0;

    for (final entity in parent.listSync(followLinks: false)) {
      if (entity is! Directory) continue;

      final match = pattern.firstMatch(PathUtils.fileName(entity.path));
      if (match == null) continue;

      final number = int.parse(match.group(1)!);
      if (number > maxNumber) maxNumber = number;
    }

    if (maxNumber == 0) return basePath;

    return PathUtils.join(parentPath, '$baseName$maxNumber');
  }

  /// Async variant: never blocks the UI isolate.
  static Future<String> latestNumberedDirectoryAsync(String basePath) async {
    final cleanBase = basePath.replaceAll(_trailing, '');
    final parentPath = directoryOf(cleanBase);
    final baseName = fileName(cleanBase);

    if (parentPath.isEmpty) return basePath;

    final parent = Directory(parentPath);
    if (!await parent.exists()) return basePath;

    final pattern = RegExp(
      '^${RegExp.escape(baseName)}(\\d+)\$',
      caseSensitive: !Platform.isWindows,
    );

    int maxNumber = 0;
    await for (final entity in parent.list(followLinks: false)) {
      if (entity is! Directory) continue;
      final match = pattern.firstMatch(fileName(entity.path));
      if (match == null) continue;
      final number = int.parse(match.group(1)!);
      if (number > maxNumber) maxNumber = number;
    }

    return maxNumber == 0 ? basePath : join(parentPath, '$baseName$maxNumber');
  }
}
