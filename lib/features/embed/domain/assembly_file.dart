import '../../../core/utils/path_utils.dart';

class AssemblyFile {
  const AssemblyFile({required this.path, required this.isManaged});

  final String path;
  final bool isManaged;

  String get name => PathUtils.fileName(path);

  @override
  bool operator ==(Object other) =>
      other is AssemblyFile && other.path == path && other.isManaged == isManaged;

  @override
  int get hashCode => Object.hash(path, isManaged);
}
