// lib/services/chat_init_service.dart
import 'dart:async';
import 'package:flutter/material.dart'; // ✅ perlu buat snackbar
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
    BuildContext? context, // 🔑 tambahin context opsional
  }) async {
    if (!force && _initialized && _lastUserId == userId && _lastDisplayName == displayName) {
      return true;
    }

    if (_pending != null) return _pending!.future;

    _pending = Completer<bool>();

    try {
      MobileChatInitialization.init(
        "_zGBGl1xg9V1ZQJVZNyFJg",
        "-8riuV9imwrYLkoV89aerSoTYsxiEAG-fPplAUw3dsc",
        "n_pujcjS8Dg7kd-AWjnDKSIPDL0gQhflerRNPhm5XAE",
        userId,
        displayName,
      );

      _initialized = true;
      _lastUserId = userId;
      _lastDisplayName = displayName;
      _pending?.complete(true);

      // ✅ tampilkan snackbar sukses
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Chat berhasil diinisialisasi untuk $displayName"),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      _pending?.complete(false);

      // ✅ tampilkan snackbar error
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal inisialisasi chat: $e"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      _pending = null;
    }

    return _initialized;
  }
}