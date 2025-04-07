import 'package:flow_control/provider/user_provider.dart';
import 'package:flow_control/services/api/user_api_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class UserActionsService extends ChangeNotifier {
  final UserProvider userProvider;
  final log = Logger();

  UserActionsService(this.userProvider);

  /// Retorna `null` si todo salió bien, o un mensaje de error si falló
  Future<String?> login(String name, String pass) async {
    try {
      if (name.isNotEmpty) {
        final user = await UserApiService().loginUser(name, pass);
        if (user != null) {
          userProvider.setUser(user);
          return null; // éxito
        } else {
          return 'Usuario no válido';
        }
      }
      return 'El nombre de usuario no puede estar vacío';
    } catch (e) {
      log.e('Error en login: $e');
      return e.toString();
    }
  }

  Future<String?> loginByCode(String code) async {
    try {
      if (code.isNotEmpty) {
        final user = await UserApiService().loginUserByCode(code);
        if (user != null) {
          userProvider.setUser(user);
          log.d('✅ Login por QR exitoso');
          return null; // éxito
        } else {
          return 'Código QR inválido';
        }
      }
      return 'El código no puede estar vacío';
    } catch (e) {
      log.e('Error en loginByCode: $e');
      return e.toString();
    }
  }

  Future<void> logout() async {
    try {
      final name = userProvider.user?.name ?? '';
      await UserApiService().logoutUser(name);
      userProvider.clearUser();
      log.i('✅ Sesión cerrada correctamente');
    } catch (e) {
      log.e('Error al cerrar sesión: $e');
    }
  }

  Future<void> forgotPassword() async {
    try {
      await UserApiService().forgotPassword();
      userProvider.clearUser();
    } catch (e) {
      log.e('Error en forgotPassword: $e');
    }
  }
}