import 'package:flow_control/modals/alert_message.dart';
import 'package:flow_control/services/api/settings_api_service.dart';
import 'package:flutter/material.dart';

class Validators {
  static void ensureSession(String? sessionId) {
    if (sessionId == null || sessionId.isEmpty) {
      throw Exception('La sesión no es válida');
    }
  }

  static void ensureApiKey(String? apiKey) {
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('La llave de API no es válida');
    }
  }

  static void ensureSuccessStatusCode(int statusCode, {String? message}) {
    if (statusCode < 200 || statusCode >= 300) {
      throw Exception(message ?? 'La respuesta del servidor fue inválida: $statusCode');
    }
  }

  static void handleHttpError(int statusCode, dynamic body) {
    switch (statusCode) {
      case 401:
        throw HttpException(401, 'No autorizado: ${body['message'] ?? body['Error'] ?? 'Sin mensaje'}');
      case 403:
        throw HttpException(403, 'Prohibido: ${body['message'] ?? 'Sin mensaje'}');
      case 404:
        throw HttpException(404, 'No encontrado: ${body['message'] ?? 'Sin mensaje'}');
      case 408:
        throw HttpException(408, '${body['message'] ?? 'Sin mensaje'}');
      case 500:
        throw HttpException(500, 'Error del servidor: ${body['message'] ?? 'Sin mensaje'}');
      default:
        throw HttpException(statusCode, 'Error HTTP $statusCode: ${body['message'] ?? 'Sin mensaje'}');
    }
  }

  static void handleHttpException(BuildContext context, dynamic error) {
    final message = error.toString();
    log.e('HttpException atrapada: $message');
    showAlertModal(context, message);
  }
}
