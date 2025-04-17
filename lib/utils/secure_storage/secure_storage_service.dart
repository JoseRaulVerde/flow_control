import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

  final log = Logger();

class SecureStorageService {
  // Guardado de Apikey
  Future<bool> setApiKey() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null) {
      File selectedFile = File(result.files.single.path!);
      String content = await selectedFile.readAsString();

      final List<String> apiKey = content.split('ApiKey:');

      log.d('apikey es; ${apiKey[1].trim()}');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('Api-Key', apiKey[1].trim());
      return true;
    } 
    return false;
  }
  // Lectura de ApiKey
  Future<String?> readApiKey()async {
    final prefs = await SharedPreferences.getInstance();
    String? apikey = prefs.getString('Api-Key');
    return apikey ?? '';
  }


  //Lectura de SessionId
  Future<String> readSessionId()async {
    final prefs = await SharedPreferences.getInstance();
    String? session = prefs.getString('X-Session-ID');
    log.d(session);
    return session ?? '';
  }

  // Graudado de sessionId
  Future<void> setSessionId(String session)async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('X-Session-ID', session);
  }

  // Borrado de sessionId
  Future<void> deleteSessionId()async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('X-Session-ID');
  }
}