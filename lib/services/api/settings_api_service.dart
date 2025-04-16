import 'dart:convert';
import 'package:flow_control/models/gestion_details.dart';
import 'package:flow_control/models/settings_info.dart';
import 'package:flow_control/utils/secure_storage/secure_storage_service.dart';
import 'package:flow_control/utils/validator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpException implements Exception {
  final int statusCode;
  final String message;

  HttpException(this.statusCode, this.message);

  @override
  String toString() => message;
}

class SettingsApiService {
  
  Future<SettingsInfo?> getSettings(BuildContext context) async {
      final String baseUrl = dotenv.env["API_URL"].toString();

    try {
      final sessionId =  await SecureStorageService().readSessionId();
      final apiKey = await SecureStorageService().readApiKey();

      Validators.ensureSession(sessionId);
      Validators.ensureApiKey(apiKey);

      final response = await http.post(
        Uri.parse('$baseUrl/$apiKey/settings-endpoint'),
        headers: {
          'X-Session-ID': sessionId,
          'User-Agent': 'Mozilla/5.0 (Linux; Android 11; Pixel 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.91 Mobile Safari/537.36',
          'X-Device-Type': 'android',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      final data = jsonDecode(response.body);

       if (response.statusCode == 200) {

        return SettingsInfo.fromJson(data);
      } else {
        Validators.handleHttpError(response.statusCode, data);
        final body = jsonDecode(response.body);
        throw HttpException(response.statusCode, body["message"]);
      }
    } catch (e) {
      log.e(e);
      rethrow;
    }
   
  }
  Future <List<GestionDetails>?> getStation(BuildContext context, int id) async {
      final String baseUrl = dotenv.env["API_URL"].toString();

    try {
      final sessionId =  await SecureStorageService().readSessionId();
      final apiKey = await SecureStorageService().readApiKey();

      Validators.ensureSession(sessionId);
      Validators.ensureApiKey(apiKey);

      final response = await http.get(
        Uri.parse('$baseUrl/$apiKey/estaciones-endpoint?area_id=$id'),
        headers: {
          'X-Session-ID': sessionId,
          'User-Agent': 'Mozilla/5.0 (Linux; Android 11; Pixel 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.91 Mobile Safari/537.36',
          'X-Device-Type': 'android',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      log.f(response.statusCode);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return body.map<GestionDetails>((item) => GestionDetails.fromJson(item)).toList();       
      } else {
        Validators.handleHttpError(response.statusCode, body);
        throw (body["message"]);
      }
    } catch (e) {
      log.e(e);
      Validators.handleHttpException(context, e);
      rethrow;
    }
   
  }
  Future<List<GestionDetails>?> selectStation(BuildContext context, int id) async {
      final String baseUrl = dotenv.env["API_URL"].toString();

    try {
      final sessionId =  await SecureStorageService().readSessionId();
      final apiKey = await SecureStorageService().readApiKey();

      Validators.ensureSession(sessionId);
      Validators.ensureApiKey(apiKey);

      final response = await http.put(
        Uri.parse('$baseUrl/$apiKey/select-station?station_id=$id'),
        headers: {
          'X-Session-ID': sessionId,
          'User-Agent': 'Mozilla/5.0 (Linux; Android 11; Pixel 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.91 Mobile Safari/537.36',
          'X-Device-Type': 'android',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      log.f(response.statusCode);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {

        return body.map<GestionDetails>((item) => GestionDetails.fromJson(item)).toList();        
      } else {
        Validators.handleHttpError(response.statusCode, body);
        throw (body["message"]);
      }
    } catch (e) {
      log.e(e);
      Validators.handleHttpException(context, e);
      rethrow;
    }
   
  }
  Future<String?> selectMachine(BuildContext context, int id) async {
      final String baseUrl = dotenv.env["API_URL"].toString();

    try {
      final sessionId =  await SecureStorageService().readSessionId();
      final apiKey = await SecureStorageService().readApiKey();

      Validators.ensureSession(sessionId);
      Validators.ensureApiKey(apiKey);

      final response = await http.put(
        Uri.parse('$baseUrl/$apiKey/select-machine?machine_id=$id'),
        headers: {
          'X-Session-ID': sessionId,
          'User-Agent': 'Mozilla/5.0 (Linux; Android 11; Pixel 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.91 Mobile Safari/537.36',
          'X-Device-Type': 'android',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      log.f(response.statusCode);
      final body = jsonDecode(response.body);


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data["message"];
      } else {
      Validators.handleHttpError(response.statusCode, body);
        throw (body["message"]);
      }
    } catch (e) {
      log.e(e);
      Validators.handleHttpException(context, e);
      rethrow;
    }
   
  }
}
