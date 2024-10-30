import 'dart:io';

import 'package:imgconv/models/img.dart';
import 'package:image/image.dart' as img;

Future<Img> convert(
  String path, {
  bool deleteAfterConversion = false,
  String opExt = ".gif",
}) async {
  try {
    final filename = path.split('/').last.split('.').first;
    final cmd = img.Command()
      ..decodeImageFile(path)
      ..writeToFile('$filename$opExt');
    await cmd.execute();

    if (deleteAfterConversion) File(path).deleteSync();

    return Img(path, success: true);
  } catch (e, st) {
    print('Error converting $path: $e\n$st');
    return Img(path, success: false, error: e, stackTrace: st);
  }
}
