import 'dart:io';

import 'package:image/image.dart' as img;

void main() async {
  final files = Directory.current.listSync().toList();

  for (final file in files) {
    if (file is File && file.path.endsWith('.webp')) {
      await convert(file.path);
      file.delete();
    }
  }

  print('Done!');
}

Future<void> convert(String path) async {
  final filename = path.split('/').last.split('.').first;
  final cmd = img.Command()
    ..decodeImageFile(path)
    ..writeToFile('$filename.gif');

  await cmd.execute();
}
