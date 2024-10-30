import 'dart:io';

class FileManager {
  static List<File> getWebPFiles(Directory directory) {
    final files = directory
        .listSync()
        .toList()
        .whereType<File>()
        .where((file) => file.path.endsWith('.webp'))
        .toList();
    return files;
  }
}
