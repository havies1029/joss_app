// lib/services/chat_init_service.dart
import 'dart:async';
import 'package:flutter/cupertino.dart';
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

  bool get isInitialized => _initialized;

  Future<ChatInitResult> ensureInit({
    required String userId,
    required String displayName,
    bool force = false,
  }) async {
    if (!force && _initialized && _lastUserId == userId && _lastDisplayName == displayName) {
      return ChatInitResult(success: true, userId: userId, displayName: displayName);
    }

    if (_pending != null) return _pending!.future;

    _pending = Completer<ChatInitResult>();
    try {
      // ✅ tunggu sampai init selesai
      await MobileChatInitialization.init(
        "_zGBGl1xg9V1ZQJVZNyFJg",
        "-8riuV9imwrYLkoV89aerSoTYsxiEAG-fPplAUw3dsc",
        "n_pujcjS8Dg7kd-AWjnDKSIPDL0gQhflerRNPhm5XAE",
        userId,
        displayName,
      );

      _initialized = true;
      _lastUserId = userId;
      _lastDisplayName = displayName;

      final result = ChatInitResult(
        success: true,
        userId: userId,
        displayName: displayName,
      );
      _pending?.complete(result);
      return result;

    } catch (e, st) {
      // ✅ tangkap error dengan jelas
      final result = ChatInitResult(
        success: false,
        userId: userId,
        displayName: displayName,
        error: e.toString(),
      );
      debugPrint("❌ Chat init gagal: $e\n$st");
      _pending?.complete(result);
      return result;
    } finally {
      _pending = null;
    }
  }
}
