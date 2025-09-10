import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/helper/app_prefs.dart';

class AuthLocalState {
  final String? lastLoginEmail;
  final String? googleDisplayName;

  const AuthLocalState({
    this.lastLoginEmail,
    this.googleDisplayName,
  });

  AuthLocalState copyWith({
    String? lastLoginEmail,
    String? googleDisplayName,
  }) {
    return AuthLocalState(
      lastLoginEmail: lastLoginEmail ?? this.lastLoginEmail,
      googleDisplayName: googleDisplayName ?? this.googleDisplayName,
    );
  }
}

class AuthLocalCubit extends Cubit<AuthLocalState> {
  final AppPrefs prefs;
  AuthLocalCubit(this.prefs) : super(const AuthLocalState()) {
    _hydrate();
  }

  void _hydrate() {
    emit(AuthLocalState(
      lastLoginEmail: prefs.lastLoginEmail,
      googleDisplayName: prefs.googleDisplayName,
    ));
  }

  Future<void> setLastLoginEmail(String? email) async {
    await prefs.setLastLoginEmail(email);
    emit(state.copyWith(lastLoginEmail: email));
  }

  Future<void> setGoogleDisplayName(String? name) async {
    await prefs.setGoogleDisplayName(name);
    emit(state.copyWith(googleDisplayName: name));
  }

  Future<void> clearLastLoginEmail() => setLastLoginEmail(null);
  Future<void> clearGoogleDisplayName() => setGoogleDisplayName(null);
}
