import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/login/change_password_bloc.dart';
import 'package:joss_app/models/authentication/change_password_model.dart';
import 'package:joss_app/common/constants.dart';

class UbahPassword extends StatefulWidget {
  const UbahPassword({Key? key}) : super(key: key);

  @override
  State<UbahPassword> createState() => _UbahPasswordState();

  /// Helper untuk buka UbahPassword (panggil dari mana saja)
  static Future show(BuildContext context) {
    if (pIsMobile) {
      // Buka sebagai PAGE PENUH di mobile
      return Navigator.push(context,
          MaterialPageRoute(builder: (ctx) => const UbahPasswordPage())
      );
    } else {
      // Web/Desktop: Modal dialog
      return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => const UbahPassword(),
      );
    }
  }
}

class _UbahPasswordState extends State<UbahPassword> with TickerProviderStateMixin {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showOld = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _isHovering = false;

  String? _oldPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  late ChangePasswordBloc _bloc;
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ChangePasswordBloc>();
    _animCtrl = AnimationController(
      duration: const Duration(milliseconds: 280),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.elasticOut),
    );
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _oldPasswordError = null;
      _newPasswordError = null;
      _confirmPasswordError = null;
    });

    final oldPwd = _oldPasswordController.text.trim();
    final newPwd = _newPasswordController.text.trim();
    final confirmPwd = _confirmPasswordController.text.trim();

    bool hasError = false;

    if (oldPwd.isEmpty) {
      _oldPasswordError = 'Password lama tidak boleh kosong';
      hasError = true;
    }
    if (newPwd.isEmpty) {
      _newPasswordError = 'Password baru tidak boleh kosong';
      hasError = true;
    }
    if (confirmPwd.isEmpty) {
      _confirmPasswordError = 'Ulangi password baru';
      hasError = true;
    } else if (!hasError && newPwd != confirmPwd) {
      _confirmPasswordError = 'Password baru & konfirmasi tidak sama';
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    final model = ChangePasswordModel(oldPassword: oldPwd, newPassword: newPwd);
    _bloc.add(UserChangePasswordEvent(pswd: model));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state.isSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.hasFailure
                    ? "Password lama salah."
                    : "Password berhasil diubah.",
              ),
              backgroundColor: state.hasFailure ? Colors.red : primaryColor,
            ),
          );
          if (!state.hasFailure) Navigator.of(context).pop();

          _oldPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
        }
      },
      builder: (context, state) {
        // --- POPUP only (web/desktop) ---
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.55),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: Center(
              child: AnimatedBuilder(
                animation: _scaleAnim,
                builder: (ctx, child) => Transform.scale(
                  scale: _scaleAnim.value,
                  child: GestureDetector(
                    onTap: () {},
                    child: _UbahPasswordForm(
                      oldPasswordController: _oldPasswordController,
                      newPasswordController: _newPasswordController,
                      confirmPasswordController: _confirmPasswordController,
                      oldPasswordError: _oldPasswordError,
                      newPasswordError: _newPasswordError,
                      confirmPasswordError: _confirmPasswordError,
                      showOld: _showOld,
                      showNew: _showNew,
                      showConfirm: _showConfirm,
                      isHovering: _isHovering,
                      onOldToggle: () => setState(() => _showOld = !_showOld),
                      onNewToggle: () => setState(() => _showNew = !_showNew),
                      onConfirmToggle: () => setState(() => _showConfirm = !_showConfirm),
                      onSubmit: _submit,
                      onHoverChanged: (v) => setState(() => _isHovering = v),
                      closeOnTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// =======================
/// PAGE PENUH (mobile)!!!
/// =======================
class UbahPasswordPage extends StatefulWidget {
  const UbahPasswordPage({Key? key}) : super(key: key);

  @override
  State<UbahPasswordPage> createState() => _UbahPasswordPageState();
}

class _UbahPasswordPageState extends State<UbahPasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showOld = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _isHovering = false;

  String? _oldPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  late ChangePasswordBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ChangePasswordBloc>();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _oldPasswordError = null;
      _newPasswordError = null;
      _confirmPasswordError = null;
    });

    final oldPwd = _oldPasswordController.text.trim();
    final newPwd = _newPasswordController.text.trim();
    final confirmPwd = _confirmPasswordController.text.trim();

    bool hasError = false;

    if (oldPwd.isEmpty) {
      _oldPasswordError = 'Password lama tidak boleh kosong';
      hasError = true;
    }
    if (newPwd.isEmpty) {
      _newPasswordError = 'Password baru tidak boleh kosong';
      hasError = true;
    }
    if (confirmPwd.isEmpty) {
      _confirmPasswordError = 'Ulangi password baru';
      hasError = true;
    } else if (!hasError && newPwd != confirmPwd) {
      _confirmPasswordError = 'Password baru & konfirmasi tidak sama';
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    final model = ChangePasswordModel(oldPassword: oldPwd, newPassword: newPwd);
    _bloc.add(UserChangePasswordEvent(pswd: model));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state.isSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.hasFailure
                    ? "Password lama salah."
                    : "Password berhasil diubah.",
              ),
              backgroundColor: state.hasFailure ? Colors.red : primaryColor,
            ),
          );
          if (!state.hasFailure) Navigator.of(context).pop();

          _oldPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
        }
      },
      builder: (context, state) {
        // --- FULL PAGE mobile ---
        return Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "Ubah Password",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: _UbahPasswordForm(
                oldPasswordController: _oldPasswordController,
                newPasswordController: _newPasswordController,
                confirmPasswordController: _confirmPasswordController,
                oldPasswordError: _oldPasswordError,
                newPasswordError: _newPasswordError,
                confirmPasswordError: _confirmPasswordError,
                showOld: _showOld,
                showNew: _showNew,
                showConfirm: _showConfirm,
                isHovering: _isHovering,
                onOldToggle: () => setState(() => _showOld = !_showOld),
                onNewToggle: () => setState(() => _showNew = !_showNew),
                onConfirmToggle: () => setState(() => _showConfirm = !_showConfirm),
                onSubmit: _submit,
                onHoverChanged: (v) => setState(() => _isHovering = v),
                closeOnTap: null,
                showLogo: true,
                asPage: true,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// =============
/// UI Form logic (bisa share untuk dialog & page)
/// =============
class _UbahPasswordForm extends StatelessWidget {
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final String? oldPasswordError;
  final String? newPasswordError;
  final String? confirmPasswordError;
  final bool showOld;
  final bool showNew;
  final bool showConfirm;
  final bool isHovering;
  final VoidCallback onOldToggle;
  final VoidCallback onNewToggle;
  final VoidCallback onConfirmToggle;
  final VoidCallback onSubmit;
  final ValueChanged<bool> onHoverChanged;
  final VoidCallback? closeOnTap;
  final bool showLogo;
  final bool asPage;

  const _UbahPasswordForm({
    Key? key,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.oldPasswordError,
    required this.newPasswordError,
    required this.confirmPasswordError,
    required this.showOld,
    required this.showNew,
    required this.showConfirm,
    required this.isHovering,
    required this.onOldToggle,
    required this.onNewToggle,
    required this.onConfirmToggle,
    required this.onSubmit,
    required this.onHoverChanged,
    this.closeOnTap,
    this.showLogo = true,
    this.asPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Web: ada close
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!asPage) // header popup
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(cardBorderRadius * 1.8),
                topRight: Radius.circular(cardBorderRadius * 1.8),
              ),
            ),
            child: Row(
              children: [
                if (closeOnTap != null)
                  GestureDetector(
                    onTap: closeOnTap,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Ubah Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        // --- Logo & Title
        if (showLogo) ...[
          const SizedBox(height: 22),
          SizedBox(
            width: 122,
            height: 44,
            child: Image(
              image: AssetImage('assets/images/JPS.png'),
              fit: BoxFit.contain,
            ),
          ),
        ],
        const SizedBox(height: 12),
        Text(
          'Silakan masukkan password lama & password baru.',
          style: TextStyle(
            fontSize: 15,
            color: primaryBlackColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 7),
        Text(
          'Pastikan password baru mudah diingat dan tidak sama dengan sebelumnya.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),

        // Fields
        _PasswordField(
          controller: oldPasswordController,
          hintText: "Password Lama",
          errorText: oldPasswordError,
          obscure: !showOld,
          onToggle: onOldToggle,
        ),
        const SizedBox(height: 18),

        _PasswordField(
          controller: newPasswordController,
          hintText: "Password Baru",
          errorText: newPasswordError,
          obscure: !showNew,
          onToggle: onNewToggle,
        ),
        const SizedBox(height: 18),

        _PasswordField(
          controller: confirmPasswordController,
          hintText: "Ulangi Password Baru",
          errorText: confirmPasswordError,
          obscure: !showConfirm,
          onToggle: onConfirmToggle,
        ),
        const SizedBox(height: 32),

        MouseRegion(
          onEnter: (_) => onHoverChanged(true),
          onExit: (_) => onHoverChanged(false),
          child: GestureDetector(
            onTap: onSubmit,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: double.infinity,
              height: 42,
              decoration: BoxDecoration(
                color: isHovering ? primaryColor.withOpacity(0.93) : primaryColor,
                borderRadius: BorderRadius.circular(7),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.14),
                    blurRadius: 9,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: const Center(
                child: Text(
                  "Simpan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final VoidCallback onToggle;
  final String? errorText;

  const _PasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscure,
    required this.onToggle,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 15,
              ),
              isDense: true,
              filled: true,
              fillColor: Colors.grey.shade50,
              constraints: const BoxConstraints(maxHeight: 44),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                borderSide: BorderSide(color: primaryColor, width: 1.7),
              ),
              errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                borderSide: BorderSide(color: Colors.red, width: 1.2),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                borderSide: BorderSide(color: Colors.red, width: 1.3),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              suffixIcon: IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey.shade600,
                ),
                onPressed: onToggle,
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }
}
