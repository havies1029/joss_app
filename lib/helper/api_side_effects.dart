import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/authentication/authentication_bloc.dart';
import 'package:joss_app/blocs/hakakses/hakaksescrud_bloc.dart';
import 'package:joss_app/helper/navigation_keys.dart';

class ApiSideEffects {
  static void refreshHakakses() {
    final context = rootNavigatorKey.currentContext;
    if (context == null) return;

    try {
      final authState = context.read<AuthenticationBloc>().state;
      if (authState is! AuthenticationAuthenticated ||
          authState.user.userType != 'C') {
        return;
      }

      context.read<HakaksesCrudBloc>().add(const HakaksesCrudLihatEvent());
    } catch (e) {
      debugPrint('Hakakses refresh side-effect failed: $e');
    }
  }

  static void refreshHakaksesOnHttpStatus(int? statusCode) {
    if (statusCode == 200) {
      refreshHakakses();
    }
  }
}
