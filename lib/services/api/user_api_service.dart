import 'dart:convert';
import 'package:flow_control/models/user.dart';
import 'package:flow_control/utils/secure_storage/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class UserApiService {
  // final String _baseUrl = 'http://172.19.0.181:8000/api';
  // final String baseUrl = 'https://kpi.officialstore.net/api';
  final String baseUrl = dotenv.env["API_URL"].toString();
  
  final log = Logger();

  Future<User?> checkActiveSession() async {
    try {
      final sessionId =  await SecureStorageService().readSessionId();

      if (sessionId.isNotEmpty) {
        final response = await http.post(
          Uri.parse('$baseUrl/login-check-session'),
          headers: {
            'X-Session-ID': sessionId,
            'User-Agent': 'Mozilla/5.0 (Linux; Android 11; Pixel 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.91 Mobile Safari/537.36',
            'X-Device-Type': 'android',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        );
          log.i(response.statusCode);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final userData = data['user'];

          final sessionKey = data['session_id'];
          if (sessionKey.isNotEmpty) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('X-Session-ID', sessionKey);
          }

          return User(
            id: userData["id"],
            permissions: userData["permissions"],
            email: userData["email"],
            name: userData["nombre"],
            lastName: userData["apellido"],
            userName: userData["username"],
            image: userData["profile_photo_url"],
          );
        } else {
          final body = jsonDecode(response.body);
          throw (body["message"]);
        }
      }else {
        return null;
      }
    } catch (e) {
      log.e(e);
      rethrow;
    }
  }

  Future<User?> loginUserByCode(String code) async {
    try {
      log.d('Entra a login por código QR');

      log.d('Entra $baseUrl');

      final response = await http.post(
        Uri.parse('$baseUrl/login-qr'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'User-Agent': 'Mozilla/5.0 (Linux; Android 11; Pixel 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.91 Mobile Safari/537.36',
          'X-Device-Type': 'android',
        },
        body: {'code_qr': code},
      );

      log.d(response.statusCode);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userData = data['user'];

        final sessionKey = data['session_id'];
        if (sessionKey.isNotEmpty) {
          SecureStorageService().setSessionId(sessionKey);
        }

        return User(
          id: userData["id"],
          permissions: userData["permissions"],
          email: userData["email"],
          name: userData["nombre"],
          lastName: userData["apellido"],
          userName: userData["username"],
          image: userData["profile_photo_url"],
        );
      } else {
        final body = jsonDecode(response.body);
        throw (body["message"]);
      }
    } catch (e) {
      log.e(e);
      rethrow;
    }
  }

  Future<User?> loginUser(String name, String pass) async {
    try {
      log.d('Login con usuario y contraseña');
      log.d('api es : $baseUrl');

      final response = await http.post(
        Uri.parse('$baseUrl/login-endpoint'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'User-Agent': 'Mozilla/5.0 (Linux; Android 11; Pixel 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.91 Mobile Safari/537.36',
          'X-Device-Type': 'android',
        },
        body: {
          'username': name,
          'password': pass,
        },
      );

      log.d(response.statusCode);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userData = data['user'];

        final sessionKey = data['session_id'];
        if (sessionKey.isNotEmpty) {
          SecureStorageService().setSessionId(sessionKey);
        }

        return User(
          id: userData["id"],
          permissions: userData["permissions"],
          email: userData["email"],
          name: userData["nombre"],
          lastName: userData["apellido"],
          userName: userData["username"],
          image: userData["profile_photo_url"],
        );
      } else {
        final body = jsonDecode(response.body);
        throw (body["message"]);
      }
    } catch (e) {
      log.e(e);
      rethrow;
    }
  }

  Future<String> logoutUser(String name) async {
    try {
      final sessionCookie =  await SecureStorageService().readSessionId();

      final response = await http.post(
        Uri.parse('$baseUrl/logout-endpoint'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'User-Agent': 'App/$name (Flutter)',
          'X-Session-ID': sessionCookie,
          'X-Device-Type': 'android',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        SecureStorageService().deleteSessionId();
        return data["message"];
      } else {
        throw (response.body.toString());
      }
    } catch (e) {
      log.e(e);
      rethrow;
    }
  }

  Future<void> forgotPassword() async {
    final Uri url = Uri.parse('https://kpi.officialstore.net/forgot-password');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      log.w('No se pudo abrir el navegador');
    }
  }
}