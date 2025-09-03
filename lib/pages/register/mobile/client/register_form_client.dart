import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/login/login_bloc.dart';

import '../../../../blocs/authentication/authentication_bloc.dart';
import '../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../../blocs/networkconnection/network_bloc.dart';
import '../../../../blocs/profile/profile_download_foto_bloc.dart';
import '../../../../blocs/reguser/reguser_bloc.dart';
import '../../../../blocs/user_profile/user_profile_cubit.dart';
import '../../../../common/app_data.dart';
import '../../../../common/constants.dart';

import '../../../../models/combobox/combomjnsclient_model.dart';
import '../../../../models/reguser/reguser_model.dart';
import '../../../../widgets/combobox/combomjnsclient_widget.dart';
import '../../../base/base_background_firstpage.dart';
import '../../welcome_header_register.dart';

class RegisterFormClient extends StatefulWidget {
  const RegisterFormClient({super.key});

  @override
  State<RegisterFormClient> createState() => _RegisterFormClientState();
}

class _RegisterFormClientState extends State<RegisterFormClient>
    with SingleTickerProviderStateMixin {

  // String? _selectedRole;
  String _selectedChoice = '';
  ComboMJnsclientModel? fieldComboJnsClient;
  late FocusNode _roleDropdownFocusNode;
  // Controller untuk input field

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _konfirmasipasswordController = TextEditingController();
  final TextEditingController _dropdownController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _teleponFocusNode = FocusNode();
  final FocusNode _konfirmasipasswordFocusNode = FocusNode();
  final FocusNode _dropdownFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _rememberPassword = false; // Variabel untuk checkbox Remember Password

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
    // _dropdownController.dispose();

    _animationController.dispose();

    _nameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _teleponFocusNode.dispose();
    _konfirmasipasswordFocusNode.dispose();
    // _dropdownFocusNode.dispose();
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
      obscureText: !_isPasswordVisible, // Gunakan state dari parent
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
  // Widget _buildRoleDropdownField(double hPadding) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: hPadding),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Label
  //         // const Text(
  //         //   "Sebagai",
  //         //   style: TextStyle(
  //         //     color: Colors.white,
  //         //     fontSize: 14,
  //         //     fontWeight: FontWeight.w500,
  //         //   ),
  //         // ),
  //         // const SizedBox(height: 8),
  //
  //         // Dropdown Field
  //         Container(
  //           decoration: BoxDecoration(
  //             color: secondaryBlackColor,
  //             borderRadius: BorderRadius.circular(8),
  //             border: Border.all(
  //               color: _roleDropdownFocusNode.hasFocus ? primaryColor : sGrey,
  //               width: _roleDropdownFocusNode.hasFocus ? 2 : 1,
  //             ),
  //           ),
  //           child: DropdownButtonFormField<String>(
  //             focusNode: _roleDropdownFocusNode,
  //             decoration: const InputDecoration(
  //               hintText: "Pilih jenis klien",
  //               hintStyle: TextStyle(
  //                 color: sGrey,
  //                 fontSize: 14,
  //               ),
  //               contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  //               border: InputBorder.none,
  //               enabledBorder: InputBorder.none,
  //               focusedBorder: InputBorder.none,
  //               errorBorder: InputBorder.none,
  //               focusedErrorBorder: InputBorder.none,
  //             ),
  //             dropdownColor: secondaryBlackColor,
  //             icon: const Icon(
  //               Icons.keyboard_arrow_down,
  //               color: sGrey,
  //               size: 24,
  //             ),
  //             style: const TextStyle(
  //               color: Colors.white,
  //               fontSize: 14,
  //               fontWeight: FontWeight.w400,
  //             ),
  //             value: _selectedRole, // Gunakan variable untuk menyimpan value
  //             items: const [
  //               DropdownMenuItem(
  //                 value: "Individu",
  //                 child: Text("Individu"),
  //               ),
  //               DropdownMenuItem(
  //                 value: "Perusahaan",
  //                 child: Text("Perusahaan"),
  //               ),
  //             ],
  //             validator: (value) {
  //               if (value == null || value.isEmpty) {
  //                 return "Silakan pilih jenis klien";
  //               }
  //               return null;
  //             },
  //             onChanged: (value) {
  //               setState(() {
  //                 _selectedRole = value;
  //                 _dropdownController.text = value ?? "";
  //               });
  //             },
  //             onTap: () {
  //               _animationController.forward(from: 0);
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget buildFieldJenisClient() {
    return buildFieldComboMJnsclient(
      labelText: 'Jenis Client',
      initItem: fieldComboJnsClient,
      onChangedCallback: (value) {
        if (value != null) {
          //fieldComboJnsClient = value;
          _selectedChoice = value.mjnsclientId;
        }
      },
      onSaveCallback: (value) {},
    );
  }

// Tambahkan variable dan focus node ini di class state Anda:
// String? _selectedRole;
// late FocusNode _roleDropdownFocusNode;

// Dan di initState():
// @override
// void initState() {
//   super.initState();
//   _roleDropdownFocusNode = FocusNode();
//   _roleDropdownFocusNode.addListener(() {
//     setState(() {});
//   });
// }

// Dan di dispose():
// @override
// void dispose() {
//   _roleDropdownFocusNode.dispose();
//   super.dispose();
// }
  // Fungsi untuk memicu event login
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
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return ((state is LoginInitial) || (state is LoginFailure))
              ? Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
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
                                  // Row dengan checkbox dan forgot password
                                  SizedBox(height: fieldSpacing),
                                  buildFieldJenisClient(),

                                  SizedBox(height: fieldSpacing),
                                  _buildSignUpButton(),
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
          )
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}