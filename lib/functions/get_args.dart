String getArg(
  List<String>? args,
  String shortFlag,
  String longFlag, {
  required String defaultValue,
}) {
  if (args == null) return defaultValue;
  final index = args.indexWhere((arg) => arg == shortFlag || arg == longFlag);
  return index >= 0 && index + 1 < args.length ? args[index + 1] : defaultValue;
}
