import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:imgconv/models/img.dart';

void main() async {
  final files = Directory.current.listSync().toList();
  final webpfiles = files.where((file) => file.path.endsWith('.webp')).toList();

  if (webpfiles.isEmpty) {
    print('No .webp files found!');
    return;
  }

  print('Converting ${webpfiles.length} files...');

  final futures = webpfiles.map((file) => convert(file.path));
  try {
    final results = await Future.wait(futures);
    final successes = results.where((result) => result.success).toList();
    print('Successfully converted ${successes.length} files!');

    final failures = results.where((result) => !result.success).toList();
    if (failures.isNotEmpty) {
      print('Failed to convert ${failures.length} files:');
      failures.forEach((failure) {
        print('  ${failure.path}');
        print('    ${failure.error}');
        print('    ${failure.stackTrace}');
      });
    }
  } catch (e) {
    print('Error converting files: $e');
  }

  print('Done!');
}

Future<Img> convert(String path) async {
  try {
    final filename = path.split('/').last.split('.').first;
    final cmd = img.Command()
      ..decodeImageFile(path)
      ..writeToFile('$filename.gif');
    await cmd.execute();
    return Img(path, success: true);
  } catch (e, st) {
    print('Error converting $path: $e');
    return Img(path, success: false, error: e, stackTrace: st);
  }
}
