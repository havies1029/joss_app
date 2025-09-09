import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_chat_flutter/presentation/mobile_chat_initialization.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../blocs/reguser_profile/reguser_profile_cubit.dart';
import '../../../blocs/user_profile/user_profile_cubit.dart';

class CustomerServicePage extends StatefulWidget {
  const CustomerServicePage({super.key});

  @override
  State<CustomerServicePage> createState() => _CustomerServicePageState();
}

class _CustomerServicePageState extends State<CustomerServicePage> {
  String? _lastUserId;
  String? _lastDisplayName;
  bool _opened = false;

  bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initChatIfNeeded();

    // Auto-open chat setelah frame pertama
    if (!_opened && isMobile) {
      _opened = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, 'chat');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (_, __) => _initChatIfNeeded(),
        ),
        BlocListener<MRekan1CrudBloc, MRekan1CrudState>(
          listenWhen: (prev, curr) =>
          prev.record?.rekanNama != curr.record?.rekanNama,
          listener: (_, __) => _initChatIfNeeded(),
        ),
      ],
      child: const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(), // loading sementara
        ),
      ),
    );
  }

  Future<void> _initChatIfNeeded() async {
    if (!isMobile) return;

    final displayName = await _getDisplayName(context);
    final userId = _getUserId(context);

    if (_lastUserId != userId || _lastDisplayName != displayName) {
      debugPrint('[CustomerServicePage] Init: userId=$userId, name=$displayName');

      try {
        MobileChatInitialization.init(
          "_zGBGl1xg9V1ZQJVZNyFJg", // TODO: pindahin ke env/config
          "-8riuV9imwrYLkoV89aerSoTYsxiEAG-fPplAUw3dsc",
          "n_pujcjS8Dg7kd-AWjnDKSIPDL0gQhflerRNPhm5XAE",
          userId,
          displayName,
        );
        _lastUserId = userId;
        _lastDisplayName = displayName;
      } catch (e) {
        debugPrint('[CustomerServicePage] init failed: $e');
      }
    }
  }

  Future<String> _getDisplayName(BuildContext context) async {
    final authState = context.read<AuthenticationBloc>().state;

    if (authState is AuthenticationAuthenticated) {
      final custType = authState.user.custType;

      if (custType == 'C') {
        // 🔹 Client → ambil dari UserProfileCubit
        final profileState = context.read<UserProfileCubit>().state;
        final nama = profileState.nama?.trim();
        if (nama != null && nama.isNotEmpty) {
          return nama;
        }
        return 'Client User'; // default kalau kosong
      } else if (custType == 'U') {
        // 🔹 User baru → ambil dari RegUserProfileCubit
        final regState = context.read<RegUserProfileCubit>().state;
        if (regState.email.isNotEmpty) {
          return regState.email;
        }
        return 'New User'; // default kalau email kosong
      }
    }

    // 🔹 Default (belum login / state lain)
    return 'Guest';
  }


  String _getUserId(BuildContext context) {
    final authState = context.read<AuthenticationBloc>().state;
    if (authState is AuthenticationAuthenticated &&
        authState.user.id != null) {
      return authState.user.id.toString();
    }
    return 'guest-${DateTime.now().millisecondsSinceEpoch}';
  }
}
