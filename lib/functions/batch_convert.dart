import 'dart:io';
import 'dart:isolate';

import 'package:imgconv/functions/convert.dart';

Future<void> convertInBatches(
  List<File> files,
  int batchSize,
  bool delete,
  String opExt,
) async {
  int success = 0, failure = 0;

  for (var i = 0; i < files.length; i += batchSize) {
    var batch = files.sublist(
      i,
      i + batchSize > files.length ? files.length : i + batchSize,
    );

    // Log for batch start
    print('Starting batch ${i ~/ batchSize + 1} with ${batch.length} files...');

    var results = await Future.wait(
      batch.map(
        (file) {
          final index = files.indexOf(file) + 1;
          print('#$index: Converting ${file.path}...');
          return Isolate.run(() {
            return convert(
              file.path,
              deleteAfterConversion: delete,
              opExt: opExt,
            );
          });
        },
      ),
    );

    // Count successes and failures
    success += results.where((result) => result.success).length;
    failure += results.where((result) => !result.success).length;

    // Log batch completion status
    print(
      'ℹ️ Batch ${i ~/ batchSize + 1} completed. Total so far -> Success: $success, Failure: $failure',
    );
  }

  print('Final Conversion Summary: {Success: $success, Failure: $failure}');
}
