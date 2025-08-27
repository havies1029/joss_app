import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_chat_flutter/presentation/mobile_chat_initialization.dart';

class CustomerServicePage extends StatefulWidget {
  const CustomerServicePage({super.key});

  @override
  State<CustomerServicePage> createState() => _CustomerServicePageState();
}

class _CustomerServicePageState extends State<CustomerServicePage> {
  String? _lastUserId;
  String? _lastDisplayName;
  bool _initInFlight = false;

  bool get isMobile =>
      !kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initChatIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181818),
        elevation: 0,
        title: const Text(
          'Customer Service',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // ❌ body kosong, hapus text placeholder
      body: const SizedBox.shrink(),
      // ✅ FAB untuk buka halaman chat
      floatingActionButton:  FloatingActionButton(
        onPressed: () => Navigator.of(context, rootNavigator: true).pushNamed('chat'),
        child: const Icon(Icons.chat),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }


  Future<void> _initChatIfNeeded() async {
    if (_initInFlight) return;
    _initInFlight = true;
    try {
      if (!isMobile) return; // kalau SDK cuma dukung mobile

      const userId = "dummy-user-123";
      const displayName = "Dummy Guest";

      if (_lastUserId == userId && _lastDisplayName == displayName) return;

      MobileChatInitialization.init(
        "_zGBGl1xg9V1ZQJVZNyFJg",
        "-8riuV9imwrYLkoV89aerSoTYsxiEAG-fPplAUw3dsc",
        "n_pujcjS8Dg7kd-AWjnDKSIPDL0gQhflerRNPhm5XAE",
        userId,
        displayName,
      );

      _lastUserId = userId;
      _lastDisplayName = displayName;
    } catch (e, st) {
      debugPrint('[CustomerServicePage] init error: $e\n$st');
    } finally {
      _initInFlight = false;
    }
  }
}
