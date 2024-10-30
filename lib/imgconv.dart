import 'dart:io';

import 'package:imgconv/functions/batch_convert.dart';
import 'package:imgconv/functions/get_args.dart';
import 'package:imgconv/functions/help.dart';
import 'package:imgconv/manager/file_manager.dart';

void main([List<String>? args]) async {
  if (args != null && args.isNotEmpty) {
    if (args.contains('-h') || args.contains('--help')) {
      printUsage();
      return;
    }
    if (args.contains('-v') || args.contains('--version')) {
      print('ImgConv v1.0.0');
      return;
    }
  }

  bool deleteAfterConversion = args?.contains('-d') ?? false;
  String outputExtension =
      getArg(args, '-e', '--out-ext', defaultValue: '.gif');
  List<File> webpFiles = FileManager.getWebPFiles(Directory.current);

  if (webpFiles.isEmpty) {
    print('No .webp files found!');
    return;
  }

  print('Converting ${webpFiles.length} files...');

  int batchSize = 5;

  await convertInBatches(
    webpFiles,
    batchSize,
    deleteAfterConversion,
    outputExtension,
  );
  print('Done!');
}
