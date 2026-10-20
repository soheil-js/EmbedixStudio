import 'dart:io';

import 'package:get/get.dart';

import '../application/embed_controller.dart';
import '../data/assembly_inspector.dart';
import '../data/embed_runner.dart';
import '../data/file_system_service.dart';

/// Creates the screen controller together with the route and disposes it with the route.
class EmbedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmbedController>(
      () => EmbedController(
        workingDirectory: File(Platform.resolvedExecutable).parent.path,
        fileSystem: Get.find<FileSystemService>(),
        inspector: Get.find<AssemblyInspector>(),
        runner: Get.find<EmbedRunner>(),
      ),
    );
  }
}
