// lib/services/chat_init_service.dart
import 'dart:async';
import 'package:mobile_chat_flutter/presentation/mobile_chat_initialization.dart';

class ChatInitService {
  ChatInitService._();
  static final ChatInitService I = ChatInitService._();

  bool _initialized = false;
  String? _lastUserId;
  String? _lastDisplayName;
  Completer<bool>? _pending;

  bool get isInitialized => _initialized;

  Future<bool> ensureInit({
    required String userId,
    required String displayName,
    bool force = false,
  }) async {
    if (!force && _initialized && _lastUserId == userId && _lastDisplayName == displayName) {
      return true;
    }

    if (_pending != null) return _pending!.future; // kalau ada init yg lagi jalan, tunggu

    _pending = Completer<bool>();

    try {
      MobileChatInitialization.init(
        "_zGBGl1xg9V1ZQJVZNyFJg",
        "-8riuV9imwrYLkoV89aerSoTYsxiEAG-fPplAUw3dsc",
        "n_pujcjS8Dg7kd-AWjnDKSIPDL0gQhflerRNPhm5XAE",
        userId,
        displayName,
      );

      await Future.delayed(const Duration(milliseconds: 500)); // kasih jeda buat inject payload

      _initialized = true;
      _lastUserId = userId;
      _lastDisplayName = displayName;
      _pending?.complete(true);
    } catch (e) {
      _pending?.complete(false);
    } finally {
      _pending = null;
    }

    return _initialized;
  }
}
