import 'dart:convert';
import 'package:flow_control/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UserApiService {
  final String _baseUrl = 'http://172.19.0.181:8000/api';
  final log = Logger();

  Future<User?> loginUserByCode(String code) async {
    try {
      log.d('Entra a login por código QR');

      final response = await http.post(
        Uri.parse('$_baseUrl/login-qr'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'User-Agent': 'App/$code (Flutter)',
        },
        body: {'code_qr': code},
      );

      log.d(response.statusCode);

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
          email: userData["email"],
          name: userData["nombre"],
          lastName: userData["apellido"],
          userName: userData["username"],
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

      final response = await http.post(
        Uri.parse('$_baseUrl/login-endpoint'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'User-Agent': 'App/$name (Flutter)',
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
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('X-Session-ID', sessionKey);
        }

        return User(
          id: userData["id"],
          email: userData["email"],
          name: userData["nombre"],
          lastName: userData["apellido"],
          userName: userData["username"],
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
      final prefs = await SharedPreferences.getInstance();
      final sessionCookie = prefs.getString('X-Session-ID') ?? '';

      final response = await http.post(
        Uri.parse('$_baseUrl/logout-endpoint'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'User-Agent': 'App/$name (Flutter)',
          'X-Session-ID': sessionCookie,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
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
    final Uri url = Uri.parse('https://flutter.dev'); // TODO: Cambiar al endpoint real
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      log.w('No se pudo abrir el navegador');
    }
  }
}