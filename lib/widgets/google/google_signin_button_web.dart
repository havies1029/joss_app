import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart'
    show GoogleSignInPlatform;
import 'package:google_sign_in_web/google_sign_in_web.dart';

void registerGoogleSigninButton() async {
  debugPrint(
    'Google Sign-In button registered for web platform.',
  );

  final plugin = GoogleSignInPlatform.instance as GoogleSignInPlugin;
  await plugin.init(clientId: '217496566954-tiqmna993j1a943i9d86chpas0ipktle.apps.googleusercontent.com');

}

Widget googleSigninButton() {
  debugPrint(
    'Google Sign-In button widget created for web platform.',
  );
  return renderButton();
}
