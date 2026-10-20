import 'dart:io';
import 'dart:typed_data';

abstract interface class AssemblyInspector {
  /// True when the PE file has a CLR runtime header (i.e. it is a managed .NET assembly).
  Future<bool> isManagedAssembly(String path);
}

/// Reads the PE header directly: a file is managed when the
/// IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR (index 14) data directory is non-empty.
class PeAssemblyInspector implements AssemblyInspector {
  const PeAssemblyInspector();

  static const _headerBytes = 4096;
  static const _peSignature = 0x00004550; // "PE\0\0"
  static const _pe32Magic = 0x10B;
  static const _pe32PlusMagic = 0x20B;
  static const _clrDirectoryIndex = 14;

  @override
  Future<bool> isManagedAssembly(String path) async {
    RandomAccessFile? file;
    try {
      file = await File(path).open();
      final length = await file.length();
      final Uint8List data = await file.read(length < _headerBytes ? length : _headerBytes);

      if (data.length < 0x40 || data[0] != 0x4D || data[1] != 0x5A) return false; // "MZ"
      final view = ByteData.sublistView(data);

      final peOffset = view.getUint32(0x3C, Endian.little);
      if (peOffset + 24 + 2 > data.length) return false;
      if (view.getUint32(peOffset, Endian.little) != _peSignature) return false;

      final optionalHeader = peOffset + 24;
      final magic = view.getUint16(optionalHeader, Endian.little);
      final int dataDirectories;
      if (magic == _pe32Magic) {
        dataDirectories = optionalHeader + 96;
      } else if (magic == _pe32PlusMagic) {
        dataDirectories = optionalHeader + 112;
      } else {
        return false;
      }

      final clrEntry = dataDirectories + _clrDirectoryIndex * 8;
      if (clrEntry + 8 > data.length) return false;
      final rva = view.getUint32(clrEntry, Endian.little);
      final size = view.getUint32(clrEntry + 4, Endian.little);
      return rva != 0 && size != 0;
    } on FileSystemException {
      return false;
    } finally {
      await file?.close();
    }
  }
}
