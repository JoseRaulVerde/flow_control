import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

/// Maneja solicitudes HTTP con respuestas comunes y función de éxito personalizada
Future<T> httpHandler<T>({
  required Future<http.Response> Function() request,
  required T Function(Map<String, dynamic> data) onSuccess,
}) async {
  try {
    final response = await request();
    final log = Logger();


  log.d(response.statusCode);
    switch (response.statusCode) {
      case 200:
        final data = jsonDecode(response.body);
        return onSuccess(data);

      case 201:
        final data = jsonDecode(response.body);
        return onSuccess(data);

      case 302:
        throw('Redirección detectada. Revisa la URL o tu sesión.');

      case 400:
        throw('Solicitud incorrecta (Bad Request). Verifica los datos enviados.');

      case 401:
        throw('Error de autenticación. Inicia sesión nuevamente.');

      case 403:
        throw('Acceso denegado. No tienes permisos suficientes.');

      case 404:
        final Map<String, dynamic> data = json.decode(response.body);
        final mensaje = data["message"];
        throw(mensaje);

      case 422:
        final data = jsonDecode(response.body);
        final errors = data['errors'][0][0];
        throw('Error de validación: ${errors.toString()}');

      case 500:
        throw('Error interno del servidor. Inténtalo más tarde.');

      case 503:
        throw('Servidor no disponible. Inténtalo de nuevo en unos minutos.');

      default:
        throw('Error inesperado: Código ${response.statusCode}');
    }
  } catch (e) {
    rethrow;
  }
}