import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../common/constants.dart';

class LogoutConfirmationPopup extends StatefulWidget {
  const LogoutConfirmationPopup({Key? key}) : super(key: key);

  @override
  State<LogoutConfirmationPopup> createState() =>
      _LogoutConfirmationPopupState();
}

class _LogoutConfirmationPopupState extends State<LogoutConfirmationPopup>
    with TickerProviderStateMixin {
  late AnimationController _animController, _overlayController;
  late Animation<double> _scaleAnim, _fadeAnim, _overlayAnim;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _overlayController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _overlayAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _overlayController, curve: Curves.easeInOut),
    );

    _overlayController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _overlayController.dispose();
    super.dispose();
  }

  void _closePopup() async {
    if (_isLoggingOut || !mounted) return;

    try {
      await _animController.reverse();
      await _overlayController.reverse();
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _confirmLogout() async {
    if (_isLoggingOut || !mounted) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      AuthenticationBloc? authBloc;
      if (mounted) {
        try {
          authBloc = context.read<AuthenticationBloc>();
        } catch (e) {}
      }

      // Google Sign Out
      try {
        await googleSignIn.signOut();
      } catch (e) {}

      // Trigger logout BEFORE closing popup
      if (authBloc != null) {
        authBloc.add(LoggedOut());
        await Future.delayed(const Duration(milliseconds: 100));
      } else {
        return; // Don't continue if we can't logout
      }

      // Close popup with animation only after logout is triggered
      try {
        if (mounted) {
          await _animController.reverse();
          await _overlayController.reverse();
        }
      } catch (e) {}

      // Pop dialog
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Emergency fallback - try to logout anyway
      if (mounted) {
        try {
          context.read<AuthenticationBloc>().add(LoggedOut());
          Navigator.of(context).pop();
        } catch (fallbackError) {
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dialogWidth =
    isMobile(context) ? MediaQuery.of(context).size.width * 0.97 : 380.0;

    final bottomSheetAnim = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    return PopScope(
      canPop: !_isLoggingOut,
      child: AnimatedBuilder(
        animation: _overlayAnim,
        builder: (context, child) {
          return Material(
            color: primaryBlackColor.withOpacity(0.5 * _overlayAnim.value),
            child: GestureDetector(
              onTap: _isLoggingOut ? null : _closePopup,
              // Ganti Center -> Align bottom
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {}, // biar tap di content gak close
                  child: SlideTransition(
                    position: bottomSheetAnim,
                    child: Opacity(
                      opacity: _fadeAnim.value,
                      child: Container(
                        width: dialogWidth,
                        margin: EdgeInsets.only(
                          bottom: isMobile(context)
                              ? 16 + MediaQuery.of(context).viewInsets.bottom
                              : 36,
                          left: 6,
                          right: 6,
                        ),
                        decoration: BoxDecoration(
                          color: primaryBlackColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(cardBorderRadius * 1.3),
                            bottom: Radius.circular(isMobile(context) ? 22 : cardBorderRadius * 0.7),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.13),
                              blurRadius: 18,
                              offset: const Offset(0, -7),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Drag indicator (optional, biar kaya modal bottom sheet beneran)
                            Container(
                              margin: const EdgeInsets.only(top: 8, bottom: 6),
                              width: 38,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(vPadding),
                              child: Column(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: pRed,
                                      shape: BoxShape.circle,
                                    ),
                                    child: _isLoggingOut
                                        ? const SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                            primaryLightColor),
                                      ),
                                    )
                                        : Icon(
                                      Icons.logout,
                                      color: primaryLightColor,
                                      size: 25,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _isLoggingOut
                                        ? 'Sedang Keluar...'
                                        : 'Keluar dari Akun',
                                    style: bodyTextStyle(
                                      context,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    _isLoggingOut
                                        ? 'Mohon tunggu sebentar...'
                                        : 'Apakah Anda yakin ingin melanjutkan?',
                                    textAlign: TextAlign.center,
                                    style: bodyTextStyle(context),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: _isLoggingOut ? null : _closePopup,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _isLoggingOut
                                            ? primaryLightColor
                                            : pGrey,
                                        foregroundColor: _isLoggingOut
                                            ? sGrey
                                            : primaryLightColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              cardBorderRadius),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: hPadding + 2,
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.close,
                                        size: 16,
                                      ),
                                      label: const Text(
                                        'Batal',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: _isLoggingOut
                                          ? null
                                          : _confirmLogout,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _isLoggingOut
                                            ? Colors.red.shade300
                                            : Colors.red.shade500,
                                        foregroundColor: primaryLightColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              cardBorderRadius),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: hPadding + 2,
                                        ),
                                      ),
                                      icon: _isLoggingOut
                                          ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                              primaryLightColor),
                                        ),
                                      )
                                          : const Icon(
                                        Icons.check,
                                        size: 16,
                                      ),
                                      label: Text(
                                        _isLoggingOut ? 'Keluar...' : 'Keluar',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}