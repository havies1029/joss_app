import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_chat_flutter/presentation/mobile_chat_initialization.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../blocs/reguser_profile/reguser_profile_cubit.dart';
import '../../../blocs/reguser_profile/reguser_profile_state.dart';
import '../../../blocs/user_profile/user_profile_cubit.dart';
import '../../../blocs/user_profile/user_profile_state.dart';

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

    if (!_opened && isMobile) {
      _opened = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          await Navigator.pushNamed(context, 'chat');
          // setelah chat ditutup, langsung keluar dari CustomerServicePage
          if (mounted) Navigator.of(context).pop();
        } catch (e) {
          debugPrint("[CustomerServicePage] gagal push: $e");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserProfileCubit, UserProfileState>(
          listener: (context, state) {
            _initChatIfNeeded();
          },
        ),
        BlocListener<RegUserProfileCubit, RegUserProfileState>(
          listener: (context, state) {
            _initChatIfNeeded();
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            _initChatIfNeeded();
          },
        ),
      ],
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
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
          "_zGBGl1xg9V1ZQJVZNyFJg", // appId
          "-8riuV9imwrYLkoV89aerSoTYsxiEAG-fPplAUw3dsc", // apiKey
          "n_pujcjS8Dg7kd-AWjnDKSIPDL0gQhflerRNPhm5XAE", // secretKey
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
        final profileState = context.read<UserProfileCubit>().state;
        return profileState.nama?.trim().isNotEmpty == true
            ? profileState.nama!.trim()
            : 'Client User';
      } else if (custType == 'U') {
        final regState = context.read<RegUserProfileCubit>().state;
        return regState.email.isNotEmpty ? regState.email : 'New User';
      }
    }
    return 'guest-${DateTime.now().millisecondsSinceEpoch}';
  }

  String _getUserId(BuildContext context) {
    // 1. Cek dulu dari UserProfileCubit
    final profileState = context.read<UserProfileCubit>().state;
    if (profileState.mrekan1Id != null &&
        profileState.mrekan1Id!.trim().isNotEmpty) {
      return profileState.mrekan1Id!;
    }

    // 2. (opsional) bisa ambil dari AuthenticationBloc kalau perlu
    final authState = context.read<AuthenticationBloc>().state;
    if (authState is AuthenticationAuthenticated &&
        authState.user.id != null &&
        authState.user.id.toString().isNotEmpty) {
      return authState.user.id.toString();
    }

    // 3. Fallback guest
    return 'guest-${DateTime.now().millisecondsSinceEpoch}';
  }
}
