import 'dart:io';

class Img {
  final String path;

  bool success;
  Object? error;
  StackTrace? stackTrace;

  Img(
    this.path, {
    this.success = false,
    this.error,
    this.stackTrace,
  });

  File get file => File(path);

  String get filename => path.split('/').last.split('.').first;
}
