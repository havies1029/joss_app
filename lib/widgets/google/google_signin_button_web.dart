import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart'
    show GoogleSignInPlatform;
import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:joss_app/common/constants.dart';

void registerGoogleSigninButton() async {
  debugPrint(
    'Google Sign-In button registered for web platform.',
  );

  final plugin = GoogleSignInPlatform.instance as GoogleSignInPlugin;
  await plugin.init(
      clientId: '217496566954-tiqmna993j1a943i9d86chpas0ipktle.apps.googleusercontent.com'
  );
}

Widget googleSigninButton() {
  debugPrint(
    'Google Sign-In button widget created for web platform.',
  );
  return const StyledGoogleSignInButton();
}

class StyledGoogleSignInButton extends StatefulWidget {
  const StyledGoogleSignInButton({super.key});

  @override
  State<StyledGoogleSignInButton> createState() => _StyledGoogleSignInButtonState();
}

class _StyledGoogleSignInButtonState extends State<StyledGoogleSignInButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: sGrey,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Transform.scale(
            scale: 1,
            child: SizedBox(
              width: double.infinity,
              child: renderButton(
                configuration: GSIButtonConfiguration(
                  type: GSIButtonType.standard,
                  theme: GSIButtonTheme.outline,
                  size: GSIButtonSize.large,
                  text: GSIButtonText.signinWith,
                  shape: GSIButtonShape.rectangular,
                  logoAlignment: GSIButtonLogoAlignment.center,
                  minimumWidth: 400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}