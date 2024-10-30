void printUsage() {
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
}
