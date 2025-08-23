import 'package:joss_app/blocs/login/change_password_bloc.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/authentication/change_password_model.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePswdForm extends StatefulWidget {
  const ChangePswdForm({super.key});

  @override
  State<ChangePswdForm> createState() => ChangePswdFormState();
}

class ChangePswdFormState extends State<ChangePswdForm> {
  final oldPasswordController = TextEditingController(text: "");
  final newPasswordController = TextEditingController(text: "");
  final confirmPasswordController = TextEditingController(text: "");
  late ChangePasswordBloc changePasswordBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  bool isObscureOldPswd = true;
  bool isObscureNewPswd = true;
  bool isObscureConfirmPswd = true;

  @override
  Widget build(BuildContext context) {
    changePasswordBloc = BlocProvider.of<ChangePasswordBloc>(context);
    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, state) {
      if (state.isSaved) {
        if (state.hasFailure) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Password Anda salah."),
            backgroundColor: Colors.red,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Password Anda berhasil diubah."),
            backgroundColor: Colors.green,
          ));
        }
        oldPasswordController.text = "";
        newPasswordController.text = "";
        confirmPasswordController.text = "";
      }
    }, builder: (context, state) {
      return SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  obscureText: isObscureOldPswd,
                  decoration: InputDecoration(
                      labelText: 'Old Password',
                      icon: const Icon(Icons.security),
                      suffixIcon: IconButton(
                          icon: Icon(isObscureOldPswd
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              isObscureOldPswd = !isObscureOldPswd;
                            });
                          })),
                  controller: oldPasswordController,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      removeError(error: "'Old Password' tidak boleh kosong.");
                    }
                  },
                  validator: (value) {
                    if ((value == null) || (value.isEmpty)) {
                      addError(error: "'Old Password' tidak boleh kosong.");
                      return "";
                    }

                    return null;
                  },
                ),
                TextFormField(
                  obscureText: isObscureNewPswd,
                  decoration: InputDecoration(
                      labelText: 'New Password',
                      icon: const Icon(Icons.security),
                      suffixIcon: IconButton(
                          icon: Icon(isObscureNewPswd
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              isObscureNewPswd = !isObscureNewPswd;
                            });
                          })),
                  controller: newPasswordController,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      removeError(error: "'New Password' tidak boleh kosong.");
                    }
                  },
                  validator: (value) {
                    if ((value == null) || (value.isEmpty)) {
                      addError(error: "'New Password' tidak boleh kosong.");
                      return "";
                    }

                    return null;
                  },
                ),
                TextFormField(
                  obscureText: isObscureConfirmPswd,
                  decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      icon: const Icon(Icons.security),
                      suffixIcon: IconButton(
                          icon: Icon(isObscureConfirmPswd
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              isObscureConfirmPswd = !isObscureConfirmPswd;
                            });
                          })),
                  controller: confirmPasswordController,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      removeError(
                          error: "'Confirm Password' tidak boleh kosong.");
                      removeError(error: "'Confirm Password' tidak sama.");
                    }
                  },
                  validator: (value) {
                    if ((value == null) || (value.isEmpty)) {
                      addError(error: "'Confirm Password' tidak boleh kosong.");
                      return "";
                    } else {
                      if (newPasswordController.text != value) {
                        addError(error: "'Confirm Password' tidak sama.");
                        return "";
                      }
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 25),
                FormError(
                  errors: errors,
                  key: null,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: AppData.kIsWeb
                      ? 80
                      : MediaQuery.of(context).size.width * 0.22,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          ChangePasswordModel pswd = ChangePasswordModel(
                              oldPassword: oldPasswordController.text,
                              newPassword: newPasswordController.text);
                          changePasswordBloc
                              .add(UserChangePasswordEvent(pswd: pswd));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }
}
