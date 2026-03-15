// lib/services/chat_init_service.dart
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mobile_chat_flutter/presentation/mobile_chat_initialization.dart';

class ChatInitResult {
  final bool success;
  final String? error;
  final String userId;
  final String displayName;

  ChatInitResult({
    required this.success,
    required this.userId,
    required this.displayName,
    this.error,
  });
}

class ChatInitService {
  ChatInitService._();
  static final ChatInitService I = ChatInitService._();

  bool _initialized = false;
  String? _lastUserId;
  String? _lastDisplayName;
  Completer<ChatInitResult>? _pending;

  void dispose() {
    _initialized = false;
    _lastUserId = null;
    _lastDisplayName = null;
    _pending = null;

    debugPrint("🧹 ChatInitService disposed & reset complete");
  }

  bool get isInitialized => _initialized;

  Future<ChatInitResult> ensureInit({
    required String userId,
    required String displayName,
    bool force = false,
  }) async {
    final safeUserId = userId.trim();
    final safeDisplayName = displayName.trim();

    if (!force &&
        _initialized &&
        _lastUserId == safeUserId &&
        _lastDisplayName == safeDisplayName) {
      return ChatInitResult(
        success: true,
        userId: safeUserId,
        displayName: safeDisplayName,
      );
    }

    if (_pending != null) return _pending!.future;

    _pending = Completer<ChatInitResult>();

    try {
      if (kIsWeb) {
        throw UnsupportedError(
          'MobileChatInitialization tidak didukung di Web.',
        );
      }

      String platformName;
      String appId;
      String accessKey;
      String secretKey;

      if (Platform.isAndroid) {
        platformName = 'Android';

        appId = "_zGBGl1xg9V1ZQJVZNyFJg";
        accessKey = "-8riuV9imwrYLkoV89aerSoTYsxiEAG-fPplAUw3dsc";
        secretKey = "n_pujcjS8Dg7kd-AWjnDKSIPDL0gQhflerRNPhm5XAE";
      } else if (Platform.isIOS) {
        platformName = 'iOS';

        appId = "lf66qYomUMX6ejBxKZmVhg";
        accessKey = "a6lWRoRwYldgpoFu1Cev0ExdfhkuWPy3jaa6Z6Log1g";
        secretKey = "RknsOIHQdEfWts0i2RH-cuVzeO7DSNOmoY_6M4fTKIo";
      } else {
        throw UnsupportedError(
          'Platform ini tidak didukung untuk MobileChatInitialization.',
        );
      }

      debugPrint(
        "🚀 Chat init started | platform=$platformName | "
        "userId=$safeUserId | displayName=$safeDisplayName",
      );

      await MobileChatInitialization.init(
        appId,
        accessKey,
        secretKey,
        safeUserId,
        safeDisplayName,
      );

      _initialized = true;
      _lastUserId = safeUserId;
      _lastDisplayName = safeDisplayName;

      final result = ChatInitResult(
        success: true,
        userId: safeUserId,
        displayName: safeDisplayName,
      );

      debugPrint(
        "✅ Chat init success | platform=$platformName | userId=$safeUserId",
      );

      _pending?.complete(result);
      return result;
    } catch (e, st) {
      final result = ChatInitResult(
        success: false,
        userId: safeUserId,
        displayName: safeDisplayName,
        error: e.toString(),
      );

      debugPrint(
        'ChatInitResult => success=${result.success}, '
        'userId=${result.userId}, displayName=${result.displayName}, '
        'error=${result.error}',
      );
      debugPrint("❌ Chat init gagal: $e\n$st");

      _pending?.complete(result);
      return result;
    } finally {
      _pending = null;
    }
  }
}