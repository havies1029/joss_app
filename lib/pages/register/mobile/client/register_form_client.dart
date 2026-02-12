import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/login/login_bloc.dart';

import '../../../../blocs/reguser/reguser_bloc.dart';
import '../../../../common/app_data.dart';
import '../../../../common/constants.dart';

import '../../../../models/combobox/combomjnsclient_model.dart';
import '../../../../models/reguser/reguser_model.dart';
import '../../../../widgets/combobox/combomjnsclient_widget.dart';
import '../../../login/mobile/client/widget/otp_client_widget.dart';
import '../../../login/welcome_header.dart';

class RegisterFormClient extends StatefulWidget {
  final String requestFrom;
  const RegisterFormClient({super.key, required this.requestFrom});

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
  bool _isConfirmPasswordVisible = false;
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
    // _konfirmasipasswordController.addListener(() {
    //   if (_formKey.currentState != null) {
    //     _formKey.currentState!.validate(); // paksa validator jalan setiap kali ngetik
    //   }
    // });
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

  Widget _buildNameField() {
    return appTextField(
      label: "Nama",
      hint: "Masukkan Nama Lengkap",
      controller: _nameController,
      focusNode: _nameFocusNode,
      keyboardType: TextInputType.name,

      validator: (value) {
        if (value == null || value.isEmpty) {
          return kNameNullError;
        }
        return null;
      },
      onTap: () {
        _animationController.forward(from: 0);
      },
    );
  }
  Widget _buildTeleponField() {
    return appTextField(
      label: "Telepon",
      hint: "8123456789",
      controller: _teleponController,
      keyboardType: TextInputType.phone,
      focusNode: _teleponFocusNode,
      prefix: Text(
        "62 | ",
        style: inputTextStyle(context, color: primaryLightColor),
      ),
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




  Widget _buildPasswordField() {
    return appTextField(
      label: "Password",
      hint: "Masukkan password",
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: !_isPasswordVisible,

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

  Widget _buildPasswordConfirmationField() {
    return appTextField(
      label: "Konfirmasi Kata Sandi",
      hint: "Masukkan ulang kata sandi",
      controller: _konfirmasipasswordController,
      focusNode: _konfirmasipasswordFocusNode,
      obscureText: !_isConfirmPasswordVisible,

      suffixIcon: IconButton(
        icon: Icon(
          _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: sGrey,
          size: 22,
        ),
        onPressed: () =>
            setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
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
      telepon: "62${_teleponController.text.trim()}",
      password: _passwordController.text,
      jnsClientId: _selectedChoice,
      email: AppData.user.email ?? "",
    );

    context.read<RegUserBloc>().add(
        RegUserTambahEvent(record: record, requestFrom: widget.requestFrom)
    );
  }

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
                errorSnackBar(error),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                successSnackBar(error
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
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: vPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 🔹 Logo
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

                                // Spasi antara logo & tombol
                                SizedBox(height: vPadding * 0.6),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4), // sesuaikan biar sejajar
                                    child: TextButton.icon(
                                      onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      icon: Icon(
                                        Icons.arrow_back_ios_new,
                                        color: primaryColor,
                                        size: getResponsiveFont(context, 18),
                                      ),
                                      label: Text(
                                        "Kembali",
                                        style: bodyTextStyle(context).copyWith(
                                          color: primaryColor
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Spasi antara tombol & header
                                SizedBox(height: vPadding * 0.8),

                                // 🔹 Welcome Header
                                WelcomeHeader(type: "register_client"),
                              ],
                            ),
                          ),

                          // Card Section
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: cardBorderGradient,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: secondaryBlackColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Card(
                                  color: secondaryBlackColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        _buildNameField(),
                                        SizedBox(height: vPadding),
                                        _buildTeleponField(),
                                        SizedBox(height: vPadding),
                                        _buildPasswordField(),
                                        SizedBox(height: vPadding),
                                        _buildPasswordConfirmationField(),
                                        SizedBox(height: vPadding),
                                        buildFieldJenisClient(),
                                        SizedBox(height: vPadding),

                                        AppButton.primary(
                                          text: isSaving ? "Mengirim..." : "Submit",
                                          isLoading: isSaving,
                                          onPressed: isSaving
                                              ? null
                                              : () {
                                            if (_formKey.currentState!.validate()) {
                                              _animationController.forward(from: 0);

                                              final record = RegUserModel(
                                                userNama: AppData.user.username ?? "",
                                                personalNama: _nameController.text.trim(),
                                                telepon: "62${_teleponController.text.trim()}",
                                                password: _passwordController.text,
                                                jnsClientId: _selectedChoice,
                                                email: AppData.user.email ?? "",
                                              );

                                              context.read<RegUserBloc>().add(
                                                RegUserTambahEvent(record: record, requestFrom: widget.requestFrom),
                                              );
                                            }
                                          },
                                        ),

                                        Spacer(),
                                      ],
                                    ),
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