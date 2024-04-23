import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:imgconv/models/img.dart';

void main([List<String>? args]) async {
  bool help = false;
  if (args != null && args.isNotEmpty) {
    help = args.contains('-h') || args.contains('--help');
  }

  if (help) {
    print('Usage: imgconv');
    print('Converts all .webp files in the current directory to .gif files.');
    print("Usage: imgconv [options]");
    print("Options:");
    print("  -h, --help    Print this usage information.");
    print("  -v, --version Print the current version.");
    print("  -d, --delete  Delete the .webp files after conversion.");
    print(
      "  -e, --out-ext Sets the extension of the output file. Defaults to '.gif'",
    );
    return;
  }

  if (args != null && args.isNotEmpty) {
    if (args.contains('-v') || args.contains('--version')) {
      print('ImgConv v1.0.0');
      return;
    }
  }

  bool delete = false;
  if (args != null && args.isNotEmpty) {
    delete = args.contains('-d') || args.contains('--delete');
  }

  String opExt = ".gif";
  if (args != null && args.isNotEmpty) {
    final extShort = args.contains('-e');
    final extLong = args.contains('--out-ext');
    final containsExt = extShort || extLong;
    if (containsExt) {
      int ix = -1;
      if (extShort) {
        ix = args.indexOf('-e');
      } else {
        ix = args.indexOf('--out-ext');
      }
      opExt = args[ix + 1];
    }
  }

  final files = Directory.current.listSync().toList();
  final webpfiles = files
      .where((file) => file is File && file.path.endsWith('.webp'))
      .toList()
      .cast<File>();

  if (webpfiles.isEmpty) {
    print('No .webp files found!');
    return;
  }

  print('Converting ${webpfiles.length} files...');
  if (webpfiles.length < 10) {
    await convertAllTogether(webpfiles, delete, opExt: opExt);
  } else {
    await convertOneByOne(webpfiles, delete, opExt: opExt);
  }

  print('Done!');
}

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
    if (deleteAfterConversion) {
      File(path).deleteSync();
    }
    return Img(path, success: true);
  } catch (e, st) {
    print('Error converting $path: $e\n$st');
    return Img(path, success: false, error: e, stackTrace: st);
  }
}

Future<void> convertAllTogether(
  List<File> files,
  bool delete, {
  required String opExt,
}) async {
  final futures = files.map(
    (file) => convert(
      file.path,
      deleteAfterConversion: delete,
      opExt: opExt,
    ),
  );
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
}

Future<void> convertOneByOne(
  List<File> files,
  bool delete, {
  required String opExt,
}) async {
  int success = 0, failure = 0;
  for (int i = 0; i < files.length; i++) {
    final file = files[i];
    print('Converting ${i + 1}/${files.length}: ${file.path}');
    final result = await convert(
      file.path,
      deleteAfterConversion: delete,
      opExt: opExt,
    );
    if (result.success) {
      success++;
    } else {
      failure++;
    }
  }

  print('{Success: $success, Failure: $failure}');
}
