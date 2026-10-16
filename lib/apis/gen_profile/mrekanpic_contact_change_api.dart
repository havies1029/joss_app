import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/gen_profile/mrekanpic_contact_change_model.dart';

class MRekanPicContactChangeApi {
  static const _baseEndpoint = '/api/profile/mrekanpic/contact-change';

  Future<MRekanPicContactChangeResult> send(
    MRekanPicContactChangeSendModel record,
  ) {
    return _post(
      action: 'MREKANPIC_CONTACT_CHANGE_SEND',
      path: 'send',
      modulId: 'PicContactOtpSend',
      body: record.toJson(),
      safeBody: record.toJson(),
      timeout: const Duration(seconds: 120),
      fallbackMessage: 'Gagal mengirim OTP perubahan kontak.',
    );
  }

  Future<MRekanPicContactChangeResult> validate(
    MRekanPicContactChangeValidateModel record,
  ) {
    return _post(
      action: 'MREKANPIC_CONTACT_CHANGE_VALIDATE',
      path: 'validate',
      modulId: 'PicContactOtpCheck',
      body: record.toJson(),
      safeBody: {
        'changeRequestId': record.changeRequestId,
        'pin': record.pin.isEmpty ? '' : '******',
      },
      timeout: const Duration(seconds: 30),
      fallbackMessage: 'Gagal memvalidasi OTP perubahan kontak.',
    );
  }

  Future<MRekanPicContactChangeResult> prepare(
    MRekanPicContactChangePrepareModel record,
  ) {
    return _post(
      action: 'MREKANPIC_CONTACT_CHANGE_PREPARE',
      path: 'prepare',
      modulId: 'PicContactPrepare',
      body: record.toJson(),
      safeBody: {
        'changeRequestId': record.changeRequestId,
        'newValue': record.newValue.isEmpty ? '' : '[REDACTED]',
      },
      timeout: const Duration(seconds: 30),
      fallbackMessage: 'Gagal menyiapkan perubahan kontak PIC.',
    );
  }

  Future<MRekanPicContactChangeResult> _post({
    required String action,
    required String path,
    required String modulId,
    required Map<String, dynamic> body,
    required Map<String, dynamic> safeBody,
    required Duration timeout,
    required String fallbackMessage,
  }) async {
    final endpoint = '${AppData.prefixEndPoint}$_baseEndpoint/$path';
    final uri = AppData.uriHtpp(
      AppData.httpAuthority,
      endpoint,
      {'modul_id': modulId},
    );

    debugPrint('[$action] URI: $uri');
    debugPrint('[$action] PAYLOAD: ${jsonEncode(safeBody)}');

    try {
      final response = await http
          .post(
            uri,
            headers: <String, String>{
              'Content-Type': 'application/json; odata=verbose',
              'Accept': 'application/json; odata=verbose',
              'Authorization': 'Bearer ${AppData.userToken}',
            },
            body: jsonEncode(body),
          )
          .timeout(timeout);

      debugPrint('[$action] STATUS: ${response.statusCode}');
      debugPrint('[$action] BODY: ${response.body}');

      if (response.statusCode != 200) {
        final message = response.statusCode == 401
            ? 'Sesi Anda telah berakhir. Silakan masuk kembali.'
            : _errorMessage(response.body, fallbackMessage);
        return MRekanPicContactChangeResult.failure(message);
      }

      if (response.body.trim().isEmpty || response.body.trim() == 'null') {
        return MRekanPicContactChangeResult.failure(fallbackMessage);
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return MRekanPicContactChangeResult.failure(fallbackMessage);
      }

      return MRekanPicContactChangeResult.fromJson(decoded);
    } on SocketException catch (error) {
      debugPrint('[$action] SOCKET ERROR: $error');
      return MRekanPicContactChangeResult.failure(
        'Tidak dapat terhubung ke server.',
      );
    } on TimeoutException catch (error) {
      debugPrint('[$action] TIMEOUT: $error');
      return MRekanPicContactChangeResult.failure(
        'Waktu koneksi habis. Silakan coba kembali.',
      );
    } on http.ClientException catch (error) {
      debugPrint('[$action] CLIENT ERROR: $error');
      return MRekanPicContactChangeResult.failure(
        'Tidak dapat terhubung ke server.',
      );
    } catch (error, stackTrace) {
      debugPrint('[$action] ERROR: $error');
      debugPrint('[$action] STACK: $stackTrace');
      return MRekanPicContactChangeResult.failure(fallbackMessage);
    }
  }

  String _errorMessage(String body, String fallback) {
    if (body.trim().isEmpty) return fallback;

    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final message = decoded['message']?.toString().trim() ?? '';
        if (message.isNotEmpty) return message;

        final data = decoded['data']?.toString().trim() ?? '';
        if (data.isNotEmpty) return data;
      }
    } catch (_) {
      // The HTTP body is not a JSON error response.
    }

    return fallback;
  }
}
