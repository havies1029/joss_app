// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mobile_chat_flutter/presentation/mobile_chat_initialization.dart';
//
// import '../../../blocs/authentication/authentication_bloc.dart';
// import '../../../blocs/gen_profile/mrekan1crud_bloc.dart';
// import '../../../blocs/reguser_profile/reguser_profile_cubit.dart';
// import '../../../blocs/reguser_profile/reguser_profile_state.dart';
// import '../../../blocs/user_profile/user_profile_cubit.dart';
// import '../../../blocs/user_profile/user_profile_state.dart';
//
// class CustomerServicePage extends StatefulWidget {
//   const CustomerServicePage({super.key});
//
//   @override
//   State<CustomerServicePage> createState() => _CustomerServicePageState();
// }
//
// class _CustomerServicePageState extends State<CustomerServicePage> {
//   String? _lastUserId;
//   String? _lastDisplayName;
//   bool _opened = false;
//
//   bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _initChatIfNeeded();
//
//     if (!_opened && isMobile) {
//       _opened = true;
//       WidgetsBinding.instance.addPostFrameCallback((_) async {
//         try {
//           await Navigator.pushNamed(context, 'chat');
//           // setelah chat ditutup, langsung keluar dari CustomerServicePage
//           if (mounted) Navigator.of(context).pop();
//         } catch (e) {
//           debugPrint("[CustomerServicePage] gagal push: $e");
//         }
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocListener(
//       listeners: [
//         BlocListener<UserProfileCubit, UserProfileState>(
//           listener: (context, state) {
//             _initChatIfNeeded();
//           },
//         ),
//         BlocListener<RegUserProfileCubit, RegUserProfileState>(
//           listener: (context, state) {
//             _initChatIfNeeded();
//           },
//         ),
//         BlocListener<AuthenticationBloc, AuthenticationState>(
//           listener: (context, state) {
//             _initChatIfNeeded();
//           },
//         ),
//       ],
//       child: const Scaffold(
//         backgroundColor: Colors.white,
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _initChatIfNeeded() async {
//     if (!isMobile) return;
//
//     final displayName = await _getDisplayName(context);
//     final userId = _getUserId(context);
//
//     if (_lastUserId != userId || _lastDisplayName != displayName) {
//       debugPrint('[CustomerServicePage] Init: userId=$userId, name=$displayName');
//
//       try {
//         MobileChatInitialization.init(
//           "_zGBGl1xg9V1ZQJVZNyFJg", // appId
//           "-8riuV9imwrYLkoV89aerSoTYsxiEAG-fPplAUw3dsc", // apiKey
//           "n_pujcjS8Dg7kd-AWjnDKSIPDL0gQhflerRNPhm5XAE", // secretKey
//           userId,
//           displayName,
//         );
//         _lastUserId = userId;
//         _lastDisplayName = displayName;
//       } catch (e) {
//         debugPrint('[CustomerServicePage] init failed: $e');
//       }
//     }
//   }
//
//   Future<String> _getDisplayName(BuildContext context) async {
//     final authState = context.read<AuthenticationBloc>().state;
//
//     if (authState is AuthenticationAuthenticated) {
//       final userType = authState.user.userType;
//       if (userType == 'C') {
//         final profileState = context.read<UserProfileCubit>().state;
//         return profileState.nama?.trim().isNotEmpty == true
//             ? profileState.nama!.trim()
//             : 'Client User';
//       } else if (userType == 'U') {
//         final regState = context.read<RegUserProfileCubit>().state;
//         return regState.email.isNotEmpty ? regState.email : 'New User';
//       }
//     }
//     return 'guest-${DateTime.now().millisecondsSinceEpoch}';
//   }
//
//   String _getUserId(BuildContext context) {
//     // 1. Cek dulu dari UserProfileCubit
//     final profileState = context.read<UserProfileCubit>().state;
//     if (profileState.mrekan1Id != null &&
//         profileState.mrekan1Id!.trim().isNotEmpty) {
//       return profileState.mrekan1Id!;
//     }
//
//     // 2. (opsional) bisa ambil dari AuthenticationBloc kalau perlu
//     final authState = context.read<AuthenticationBloc>().state;
//     if (authState is AuthenticationAuthenticated &&
//         authState.user.id != null &&
//         authState.user.id.toString().isNotEmpty) {
//       return authState.user.id.toString();
//     }
//
//     // 3. Fallback guest
//     return 'guest-${DateTime.now().millisecondsSinceEpoch}';
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_chat_flutter/presentation/mobile_chat_initialization.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../blocs/reguser/reguser_bloc.dart';
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
  Timer? _debounce;

  bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("👉 CustomerServicePage didChangeDependencies()");
    if (!_opened && isMobile && mounted) {
      _opened = true;

      _initChatIfNeeded().then((success) {
        if (success && mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, 'chat');
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // BlocListener<UserProfileCubit, UserProfileState>(
        //   listener: (context, state) => _scheduleInit(),
        // ),
        // BlocListener<RegUserProfileCubit, RegUserProfileState>(
        //   listener: (context, state) => _scheduleInit(),
        // ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) => _scheduleInit(),
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

  void _scheduleInit() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) _initChatIfNeeded();
    });
  }

  Future<bool> _initChatIfNeeded({int attempt = 1}) async {
    if (!isMobile) return false;
    debugPrint("👉 _initChatIfNeeded dipanggil (attempt $attempt)");
    final displayName = await _getDisplayName(context);
    final userId = await _getUserId(context);

    debugPrint('[CustomerServicePage] cek init (try $attempt): userId=$userId, name=$displayName');

    if (userId.isEmpty || displayName.isEmpty) {
      debugPrint('[CustomerServicePage] data belum siap');
      return false;
    }

    if (_lastUserId == userId && _lastDisplayName == displayName) {
      debugPrint('[CustomerServicePage] sama persis, skip init ulang');
      return true;
    }

    try {
      debugPrint("[CustomerServicePage] Payload JSON >>> ${{
        "appId": "_zGBGl1xg9V1ZQJVZNyFJg",
        "key1": "-8riuV9imwrYLkoV89aerSoTYsxiEAG-fPplAUw3dsc",
        "key2": "n_pujcjS8Dg7kd-AWjnDKSIPDL0gQhflerRNPhm5XAE",
        "userId": userId,
        "displayName": displayName,
      }}");

      MobileChatInitialization.init(
        "_zGBGl1xg9V1ZQJVZNyFJg",
        "-8riuV9imwrYLkoV89aerSoTYsxiEAG-fPplAUw3dsc",
        "n_pujcjS8Dg7kd-AWjnDKSIPDL0gQhflerRNPhm5XAE",
        userId,
        displayName,
      );

      _lastUserId = userId;
      _lastDisplayName = displayName;

      await Future.delayed(const Duration(seconds: 1));

      if ((userId.isEmpty || displayName.isEmpty) && attempt < 3) {
        debugPrint("[CustomerServicePage] payload belum siap → retry $attempt");
        return _initChatIfNeeded(attempt: attempt + 1);
      }

      debugPrint("[CustomerServicePage] Init sukses ✅ user=$userId");
      return true;
    } catch (e) {
      debugPrint('[CustomerServicePage] init failed: $e');
    }

    return false;
  }

  Future<String> _getDisplayName(BuildContext context) async {
    final authState = context.read<AuthenticationBloc>().state;

    if (authState is AuthenticationAuthenticated) {
      final userType = authState.user.userType;
      if (userType == 'C') {
        final name =
            context.read<MRekan1CrudBloc>().state.record?.rekanNama;

        return name?.trim().isNotEmpty == true
            ? name!.trim()
            : 'Client User';
      } else if (userType == 'U') {
        final email = context.select(
              (RegUserBloc b) => (b.state.record?.email ?? '').trim(),
        );

        return email.isNotEmpty ? email : 'New User';
      }

    }
    return '';
  }

  Future<String> _getUserId(BuildContext context) async {
    final mrekan1Id =
        context.read<MRekan1CrudBloc>().state.record?.mrekan1Id;

    if (mrekan1Id != null &&
        mrekan1Id!.trim().isNotEmpty) {
      return mrekan1Id!;
    }

    final prefs = await SharedPreferences.getInstance();
    String? savedGuestId = prefs.getString("guestId");
    if (savedGuestId == null) {
      savedGuestId = 'guest-${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString("guestId", savedGuestId);
    }
    return savedGuestId;
  }
}
