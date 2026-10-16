import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekanpic_contact_change_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/helper/international_phone_result.dart';
import 'package:joss_app/models/gen_profile/mrekanpic_contact_change_model.dart';

class MRekanPicContactChangePage extends StatefulWidget {
  final int changeTypeId;
  final String currentValue;

  const MRekanPicContactChangePage({
    super.key,
    required this.changeTypeId,
    required this.currentValue,
  });

  @override
  State<MRekanPicContactChangePage> createState() =>
      _MRekanPicContactChangePageState();
}

class _MRekanPicContactChangePageState
    extends State<MRekanPicContactChangePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _currentController;
  final _newController = TextEditingController();
  final _confirmationController = TextEditingController();

  bool _showErrors = false;
  bool _closedAfterPrepare = false;
  String _submittedValue = '';

  bool get _isEmail => widget.changeTypeId == MRekanPicContactChangeType.email;

  String get _title => _isEmail ? 'Ubah Email PIC' : 'Ubah No. HP PIC';

  String get _currentNormalized {
    if (_isEmail) return widget.currentValue.trim().toLowerCase();
    final digits = InternationalPhoneHelper.clean(widget.currentValue);
    if (digits.startsWith('62')) return digits;
    if (digits.startsWith('0')) return '62${digits.substring(1)}';
    return '62$digits';
  }

  String get _newNormalized => _isEmail
      ? _newController.text.trim().toLowerCase()
      : '62${_newController.text.trim()}';

  @override
  void initState() {
    super.initState();
    _currentController = TextEditingController(
      text: _isEmail ? _currentNormalized : '+$_currentNormalized',
    );
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  String? _validateNewValue(String? value) {
    final input = (value ?? '').trim();
    if (input.isEmpty) {
      return _isEmail ? 'Email baru wajib diisi' : 'No. HP baru wajib diisi';
    }

    if (_isEmail) {
      final normalized = input.toLowerCase();
      if (!emailValidatorRegExp.hasMatch(normalized)) {
        return 'Format email baru tidak valid';
      }
      if (normalized == _currentNormalized) {
        return 'Email baru harus berbeda dari email lama';
      }
      return null;
    }

    if (!RegExp(r'^\d+$').hasMatch(input)) {
      return 'No. HP hanya boleh berisi angka';
    }
    if (!input.startsWith('8')) {
      return 'No. HP harus dimulai dengan angka 8';
    }
    if (input.length < 8 || input.length > 20) {
      return 'No. HP harus terdiri dari 8 sampai 20 digit';
    }
    if ('62$input' == _currentNormalized) {
      return 'No. HP baru harus berbeda dari No. HP lama';
    }
    return null;
  }

  String? _validateConfirmation(String? value) {
    final input = (value ?? '').trim();
    if (input.isEmpty) {
      return _isEmail
          ? 'Konfirmasi email baru wajib diisi'
          : 'Konfirmasi No. HP baru wajib diisi';
    }

    final current = _isEmail ? input.toLowerCase() : input;
    final expected = _isEmail
        ? _newController.text.trim().toLowerCase()
        : _newController.text.trim();
    if (current != expected) {
      return _isEmail
          ? 'Konfirmasi email tidak sama'
          : 'Konfirmasi No. HP tidak sama';
    }
    return null;
  }

  void _submit() {
    setState(() => _showErrors = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    _submittedValue = _newNormalized;
    context.read<MRekanPicContactChangeBloc>().add(
          MRekanPicContactChangePrepareRequested(
            newValue: _submittedValue,
          ),
        );
  }

  Widget _buildRequirement(bool valid, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          valid ? Icons.radio_button_checked : Icons.radio_button_unchecked,
          size: 15,
          color: valid ? primaryColor : hintGrey,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: bodyTextStyle(context, fontSize: 13).copyWith(
            color: valid ? primaryColor : hintGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRequirements() {
    final value = _newController.text.trim();
    if (_isEmail) {
      final normalized = value.toLowerCase();
      return Wrap(
        spacing: 14,
        runSpacing: 8,
        children: [
          _buildRequirement(
            emailValidatorRegExp.hasMatch(normalized),
            'Format email valid',
          ),
          _buildRequirement(
            normalized.isNotEmpty && normalized != _currentNormalized,
            'Berbeda dari email lama',
          ),
        ],
      );
    }

    return Wrap(
      spacing: 14,
      runSpacing: 8,
      children: [
        _buildRequirement(value.startsWith('8'), 'Dimulai angka 8'),
        _buildRequirement(
          value.length >= 8 && value.length <= 20,
          '8 sampai 20 digit',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MRekanPicContactChangeBloc,
        MRekanPicContactChangeState>(
      listenWhen: (previous, current) =>
          previous.phase != current.phase ||
          previous.message != current.message ||
          previous.hasFailure != current.hasFailure,
      listener: (context, state) {
        if (state.phase == MRekanPicContactChangePhase.prepared &&
            !_closedAfterPrepare) {
          _closedAfterPrepare = true;
          Navigator.of(context).pop(
            MRekanPicPreparedContactChange(
              changeRequestId: state.changeRequestId,
              newValue: _submittedValue,
            ),
          );
          return;
        }

        if (state.hasFailure) {
          final message = state.message.trim().isNotEmpty
              ? state.message
              : 'Gagal menyiapkan perubahan kontak PIC.';
          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(message));

          if (state.phase == MRekanPicContactChangePhase.expired) {
            Navigator.of(context).pop();
          }
        }
      },
      builder: (context, state) {
        final isSubmitting =
            state.phase == MRekanPicContactChangePhase.preparing;

        return Scaffold(
          backgroundColor: secondaryBlackColor,
          appBar: AppBar(
            backgroundColor: primaryBlackColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(_title, style: headingStyle(context, fontSize: 20)),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: hPadding * 1.5,
                horizontal: hPadding * 1.5,
              ),
              child: Form(
                key: _formKey,
                autovalidateMode: _showErrors
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: pGrey,
                        border: Border.all(color: sGrey),
                        borderRadius: BorderRadius.circular(cardBorderRadius),
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          appTextField(
                            controller: _currentController,
                            label: _isEmail ? 'Email Lama' : 'No. HP Lama',
                            enabled: false,
                          ),
                          const SizedBox(height: 12),
                          appTextField(
                            controller: _newController,
                            label: _isEmail ? 'Email Baru' : 'No. HP Baru',
                            keyboardType: _isEmail
                                ? TextInputType.emailAddress
                                : TextInputType.phone,
                            inputFormatters: _isEmail
                                ? [
                                    FilteringTextInputFormatter.deny(
                                      RegExp(r'\s'),
                                    ),
                                    LengthLimitingTextInputFormatter(200),
                                  ]
                                : [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(20),
                                  ],
                            prefix: _isEmail
                                ? null
                                : Text(
                                    '+62 ',
                                    style: bodyTextStyle(context),
                                  ),
                            validator: _validateNewValue,
                            onChanged: (_) => setState(() {}),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: _buildRequirements(),
                          ),
                          appTextField(
                            controller: _confirmationController,
                            label: _isEmail
                                ? 'Konfirmasi Email Baru'
                                : 'Konfirmasi No. HP Baru',
                            keyboardType: _isEmail
                                ? TextInputType.emailAddress
                                : TextInputType.phone,
                            inputFormatters: _isEmail
                                ? [
                                    FilteringTextInputFormatter.deny(
                                      RegExp(r'\s'),
                                    ),
                                    LengthLimitingTextInputFormatter(200),
                                  ]
                                : [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(20),
                                  ],
                            prefix: _isEmail
                                ? null
                                : Text(
                                    '+62 ',
                                    style: bodyTextStyle(context),
                                  ),
                            validator: _validateConfirmation,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    AppButton.primary(
                      text: 'Konfirmasi',
                      isLoading: isSubmitting,
                      onPressed: isSubmitting ? null : _submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
