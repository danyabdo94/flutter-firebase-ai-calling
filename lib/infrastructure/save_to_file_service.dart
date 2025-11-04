// import 'dart:io';

// import 'package:path_provider/path_provider.dart';

// Future<String> get _localPath async {
//   final directory = await getApplicationDocumentsDirectory();

//   return directory.path;
// }

// Future<File> get _localFile async {
//   final path = await _localPath;
//   return File('$path/output.py');
// }

// Future<File> saveCodeToFile(String text) async {
//   final file = await _localFile;

//   // Write the file
//   return file.writeAsString(text);
// }
