import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/login/login_bloc.dart';

import '../../../../blocs/reguser/reguser_bloc.dart';
import '../../../../common/app_data.dart';
import '../../../../common/constants.dart';

import '../../../../models/combobox/combomjnsclient_model.dart';
import '../../../../models/reguser/reguser_model.dart';
import '../../../../widgets/combobox/combomjnsclient_widget.dart';
import '../../../login/mobile/client/widget/popup_client_widget.dart';
import '../../welcome_header_register.dart';

class RegisterFormClient extends StatefulWidget {
  const RegisterFormClient({super.key});

  @override
  State<RegisterFormClient> createState() => _RegisterFormClientState();
}

class _RegisterFormClientState extends State<RegisterFormClient>
    with SingleTickerProviderStateMixin {

  String _selectedChoice = '';
  ComboMJnsclientModel? fieldComboJnsClient;
  late FocusNode _roleDropdownFocusNode;

  // Controller untuk input field

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _konfirmasipasswordController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _teleponFocusNode = FocusNode();
  final FocusNode _konfirmasipasswordFocusNode = FocusNode();

  bool _isPasswordVisible = false;

  // GlobalKey untuk validasi form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Untuk animasi
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _roleDropdownFocusNode = FocusNode();
    _roleDropdownFocusNode.addListener(() {
      setState(() {});
    });
    _animationController = AnimationController(
      vsync: this,
      duration: defaultDuration,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _teleponController.dispose();
    _konfirmasipasswordController.dispose();

    _animationController.dispose();

    _nameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _teleponFocusNode.dispose();
    _konfirmasipasswordFocusNode.dispose();
    _roleDropdownFocusNode.dispose();
    super.dispose();
  }

  Widget _buildNameField(double hPadding) {
    return appTextField(
      label: "Nama",
      hint: "Masukkan Nama Lengkap",
      controller: _nameController,
      focusNode: _nameFocusNode,
      keyboardType: TextInputType.name,
      padding: EdgeInsets.symmetric(horizontal: hPadding),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kNamelNullError;
        }
        return null;
      },
      onTap: () {
        _animationController.forward(from: 0);
      },
    );
  }

  Widget _buildTeleponField(double hPadding) {
    return appTextField(
      label: "Telepon",
      hint: "Masukkan telepon",
      controller: _teleponController,
      focusNode: _teleponFocusNode,
      keyboardType: TextInputType.number,
      padding: EdgeInsets.symmetric(horizontal: hPadding),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kPhoneNumberNullError;
        }
        return null;
      },
      onTap: () {
        _animationController.forward(from: 0);
      },
    );
  }

  Widget _buildPasswordField(double hPadding) {
    return appTextField(
      label: "Password",
      hint: "Masukkan password",
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: !_isPasswordVisible,
      // Gunakan state dari parent
      padding: EdgeInsets.symmetric(horizontal: hPadding),
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: sGrey,
          size: 22,
        ),
        onPressed:
            () => setState(() => _isPasswordVisible = !_isPasswordVisible),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kPassNullError;
        }
        if (value.length < 6) {
          return kShortPassError;
        }
        return null;
      },
      onTap: () {
        _animationController.forward(from: 0);
      },
    );
  }

  Widget _buildPasswordConfirmationField(double hPadding) {
    return appTextField(
      label: "Konfirmasi Kata Sandi",
      hint: "Masukkan ulang kata sandi",
      controller: _konfirmasipasswordController,
      focusNode: _konfirmasipasswordFocusNode,
      obscureText: !_isPasswordVisible,
      padding: EdgeInsets.symmetric(horizontal: hPadding),
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: sGrey,
          size: 22,
        ),
        onPressed: () =>
            setState(() => _isPasswordVisible = !_isPasswordVisible),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kPassNullError;
        }
        if (value.length < 6) {
          return kShortPassError;
        }
        if (value != _passwordController.text) {
          return "Konfirmasi password tidak sama";
        }
        return null;
      },
      onTap: () {
        _animationController.forward(from: 0);
      },
    );
  }

  Widget _buildSignUpButton() {
    return AppButton.primary(
      text: "Submit",
      width: double.infinity,
      height: buttonHeight,
      isLoading: false,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _animationController.forward(from: 0);
          onRegisterButtonPressed();
        }
      },
    );
  }

  Widget buildFieldJenisClient() {
    return buildFieldComboMJnsclient(
      labelText: 'Jenis Client',
      initItem: fieldComboJnsClient,
      onChangedCallback: (value) {
        if (value != null) {
          fieldComboJnsClient = value;
          _selectedChoice = value.mjnsclientId;
          setState(() {});
        }
      },
      onSaveCallback: (value) {},
    );
  }

  void onRegisterButtonPressed() {
    RegUserModel record = RegUserModel(
      userNama: AppData.user.username ?? "",
      personalNama: _nameController.text,
      telepon: _teleponController.text,
      password: _passwordController.text,
      jnsClientId: _selectedChoice,
      email: AppData.user.email ?? "",
    );

    context.read<RegUserBloc>().add(
        RegUserTambahEvent(record: record)
    );
  }

  /*
  bool _isSubmitting = false;

// fungsi debug + validation + confirm + send
  Future<void> onRegisterButtonPressed() async {
    final name = _nameController.text.trim();
    final phone = _teleponController.text.trim();
    final password = _passwordController.text;
    // kalau lo pakai controller konfirmasi yang namanya beda, sesuaikan.
    final confirmPassword = _konfirmasipasswordController?.text ?? '';
    final jnsClientId = _selectedChoice ?? '';

    // cepat block double submit
    if (_isSubmitting) return;

    // --- VALIDATIONS ---
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nama tidak boleh kosong'))
      );
      return;
    }

    if (jnsClientId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih jenis client dulu'))
      );
      return;
    }

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Telepon tidak boleh kosong'))
      );
      return;
    }

    // simple phone regex: +62... or digits only, 6-15 digits
    final phoneReg = RegExp(r'^\+?[0-9]{6,15}$');
    if (!phoneReg.hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Format nomor telepon tidak valid'))
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password tidak boleh kosong'))
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password minimal 6 karakter'))
      );
      return;
    }

    // cek konfirmasi (opsional kalau lo memang punya field konfirmasi)
    if (confirmPassword.isNotEmpty && password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password dan konfirmasi tidak cocok'))
      );
      return;
    }

    // cek email di AppData (kalau butuh)
    final userEmail = AppData.user.email ?? '';
    if (userEmail.isEmpty) {
      // hanya peringatan, bukan block; kalau lo mau block: return after snackbar
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Warning: email user kosong (will send empty).'))
      );
    }

    // --- BUILD MODEL ---
    final record = RegUserModel(
      userNama: AppData.user.username ?? "",
      personalNama: name,
      telepon: phone,
      password: password,
      jnsClientId: jnsClientId,
      email: userEmail,
    );

    // --- DEBUG PRINT (aman) ---
    // jangan print password di production; cuma untuk debug dev environment.
    debugPrint('=== RegUserModel preview ===');
    debugPrint('userNama: ${record.userNama}');
    debugPrint('personalNama: ${record.personalNama}');
    debugPrint('telepon: ${record.telepon}');
    debugPrint('jnsClientId: ${record.jnsClientId}');
    debugPrint('email: ${record.email}');
    debugPrint('password: ${'*' * (record.password?.length ?? 0)} (masked)');

    // --- CONFIRM DIALOG ---
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Registrasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${record.personalNama}'),
            const SizedBox(height: 6),
            Text('Telepon: ${record.telepon}'),
            const SizedBox(height: 6),
            Text('Jenis Client: ${record.jnsClientId}'),
            const SizedBox(height: 6),
            Text('Email: ${record.email.isEmpty ? "<kosong>" : record.email}'),
            const SizedBox(height: 6),
            Text('Password: ${'*' * (record.password?.length ?? 0)}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Batal')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Kirim')),
        ],
      ),
    );

    if (confirmed != true) {
      // user batal
      return;
    }

    // --- SEND EVENT (set submitting flag supaya gak double submit) ---
    setState(() => _isSubmitting = true);

    try {
      context.read<RegUserBloc>().add(RegUserTambahEvent(record: record));

      // optional: langsung tunjukin feedback loading sementara bloc menangani proses
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mengirim registrasi...'))
      );

      // note: _isSubmitting tetap true sampai bloc listener (RegUserSuccess/Failure) reset it.
      // Pastikan di BlocListener lo reset _isSubmitting = false setelah success/failure.
    } catch (e, st) {
      debugPrint('onRegisterButtonPressed error: $e\n$st');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal kirim: $e'))
      );
      setState(() => _isSubmitting = false);
    }
  }*/
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar("Username atau Password Anda salah!"),
              );
            }
          },
        ),
      ],
      child: BlocConsumer<RegUserBloc, RegUserState>(
        listener: (context, state) {
          if (state.hasFailure && state.errors.isNotEmpty) {
            final error = state.errors.first;
            if (error.toLowerCase().contains('telepon')) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        },
        builder: (context, regState) {
          // Keep LoginBloc reactivity by nesting a BlocBuilder for LoginBloc
          return BlocBuilder<LoginBloc, LoginState>(
            builder: (context, loginState) {
              final showForm = (loginState is LoginInitial) ||
                  (loginState is LoginFailure);

              if (!showForm) {
                return const Center(child: CircularProgressIndicator());
              }

              final isSaving = regState.isSaving;

              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery
                          .of(context)
                          .size
                          .height,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Header Section
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/icons/logo_jps_no_background.png',
                                  height: isDesktop(context)
                                      ? 56
                                      : isTablet(context)
                                      ? 48
                                      : 42,
                                  width: isDesktop(context)
                                      ? 180
                                      : isTablet(context)
                                      ? 140
                                      : 120,
                                ),
                                WelcomeHeaderRegister(),
                              ],
                            ),
                          ),

                          // Card Section yang akan mengambil sisa ruang
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border(
                                  top: BorderSide(
                                    color: primaryColor,
                                    width: 4.0,
                                  ),
                                ),
                              ),
                              child: Card(
                                elevation: 0,
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      _buildNameField(0),
                                      SizedBox(height: fieldSpacing),
                                      _buildTeleponField(0),
                                      SizedBox(height: fieldSpacing),
                                      _buildPasswordField(0),
                                      SizedBox(height: fieldSpacing),
                                      _buildPasswordConfirmationField(0),
                                      SizedBox(height: fieldSpacing),
                                      buildFieldJenisClient(),
                                      SizedBox(height: fieldSpacing),

                                      // Replace _buildSignUpButton with inlined button so we can pass isLoading
                                      AppButton.primary(
                                        text: isSaving
                                            ? "Mengirim..."
                                            : "Submit",
                                        width: double.infinity,
                                        height: buttonHeight,
                                        isLoading: isSaving,
                                        onPressed: isSaving
                                            ? null
                                            : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _animationController.forward(
                                                from: 0);
                                            // dispatch event
                                            final record = RegUserModel(
                                              userNama: AppData.user.username ??
                                                  "",
                                              personalNama: _nameController.text
                                                  .trim(),
                                              telepon: _teleponController.text
                                                  .trim(),
                                              password: _passwordController
                                                  .text,
                                              jnsClientId: _selectedChoice,
                                              email: AppData.user.email ?? "",
                                            );
                                            debugPrint(
                                                'Dispatching RegUserTambahEvent: ${record
                                                    .personalNama}, telepon=${record
                                                    .telepon}');
                                            context.read<RegUserBloc>().add(
                                                RegUserTambahEvent(
                                                    record: record));
                                          }
                                        },
                                      ),

                                      // Sisa ruang akan diisi oleh Card background
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}