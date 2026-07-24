import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../blocs/gen_compro/reqcompro_bloc.dart';
import '../../../common/constants.dart';
import '../../../helper/international_phone_result.dart';
import '../../../models/gen_compro/reqcompro_model.dart';
import '../../../repositories/gen_compro/reqcompro_repository.dart';
import '../../../widgets/apptheme/phone_number_field.dart';

class CompanyProfileCard extends StatelessWidget {
  const CompanyProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReqComproBloc(repository: ReqComproRepository()),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double offsetY = kIsWeb ? -30 : -40;
          final double screenWidth = MediaQuery.sizeOf(context).width;
          final double bgWidth =
              constraints.maxWidth > 420 ? 392 : screenWidth;
          final double cardWidth =
              constraints.maxWidth > 420 ? 340 : constraints.maxWidth * 0.9;

          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: constraints.maxWidth,
                height: 134,
              ),
              Positioned(
                top: 0,
                left: (constraints.maxWidth - bgWidth) / 2,
                width: bgWidth,
                height: 134,
                child: _ComproBackground(
                  width: bgWidth,
                ),
              ),
              Transform.translate(
                offset: Offset(0, offsetY),
                child: Container(
                  width: cardWidth,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: pGrey,
                    borderRadius: BorderRadius.circular(cardBorderRadius),
                    border: Border.all(color: sGrey),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/employee_shield.svg',
                        height: 40,
                      ),
                      const SizedBox(height: 6),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: bodyTextStyle(
                            context,
                            fontSize: 24,
                          ).copyWith(fontFamily: "Delm-Regular"),
                          children: [
                            const TextSpan(text: 'Company '),
                            TextSpan(
                              text: 'Profile',
                              style: TextStyle(color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Semua tentang Proteksi Plus dalam satu dokumen.',
                        textAlign: TextAlign.center,
                        style: bodyTextStyle(
                          context,
                          fontSize: 16,
                        ).copyWith(color: hintGrey),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton.iconLeft(
                          text: 'Dapatkan Company Profile',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => BlocProvider.value(
                                value: context.read<ReqComproBloc>(),
                                child: const ComproContactDialog(),
                              ),
                            );
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/chat.svg',
                            height: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ComproBackground extends StatelessWidget {
  const _ComproBackground({
    required this.width,
  });

  final double width;

  static const double _height = 134;
  static const double _baseWidth = 390;
  static const double _watermarkWidth = 127;

  @override
  Widget build(BuildContext context) {
    final double responsiveWatermarkWidth =
        width * (_watermarkWidth / _baseWidth);

    return SizedBox(
      width: width,
      height: _height,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFE99427),
                    Color(0xFFE4A244),
                    Color(0xFFD97914),
                    Color(0xFFBC530F),
                  ],
                  stops: [0, 0.38, 0.68, 1],
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.7, 0.35),
                  radius: 0.85,
                  colors: [
                    const Color(0xFFF0B044).withOpacity(0.55),
                    Colors.transparent,
                  ],
                  stops: const [0, 0.72],
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.2, -1),
                  radius: 0.8,
                  colors: [
                    const Color(0xFF9A3704).withOpacity(0.2),
                    Colors.transparent,
                  ],
                  stops: const [0, 0.78],
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              height: _height,
              width: responsiveWatermarkWidth,
              child: SvgPicture.asset(
                'assets/images/jps_dikanan.svg',
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ComproContactDialog extends StatefulWidget {
  const ComproContactDialog({super.key});

  @override
  State<ComproContactDialog> createState() => _ComproContactDialogState();
}

class _ComproContactDialogState extends State<ComproContactDialog> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _countryCode = InternationalPhoneHelper.defaultCountryCode;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendRequest(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final phoneRes = InternationalPhoneHelper.normalize(
        _controller.text.trim(),
        countryCode: _countryCode,
      );
      final input = phoneRes.phone ?? '';

      final bloc = context.read<ReqComproBloc>();
      final record = ReqComproModel(
        regTgl: DateTime.now(),
        sendTo: input,
      );

      bloc.add(ReqComproTambahEvent(record: record));
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<ReqComproBloc, ReqComproState>(
      listener: (context, state) {
        if (state.isSaving) {
          // 🔹 Tampilkan loading overlay
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(
              child: CircularProgressIndicator(color: primaryColor),
            ),
          );
        } else if (state.isSaved && !state.hasFailure) {
          Navigator.pop(context);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(successSnackBar('Permintaan Company Profile berhasil dikirim!'));
        } else if (state.isSaved && state.hasFailure) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar('Gagal mengirim permintaan. Coba lagi.'));
        }
      },
      child: Dialog(
        backgroundColor: pGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardBorderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Masukan No. Telephone Anda",
                  style: bodyTextStyle(context, fontSize: 16),
                ),
                const SizedBox(height: 15),
                AppPhoneNumberField(
                  label: "No. Telp",
                  controller: _controller,
                  countryCode: _countryCode,
                  onCountryCodeChanged: (value) {
                    setState(() {
                      _countryCode = value;
                    });
                  },
                  hint: "Masukkan nomor telepon",
                  validator: (value) {
                    final phoneRes = InternationalPhoneHelper.normalize(
                      value ?? '',
                      countryCode: _countryCode,
                    );
                    if (!phoneRes.isValid) {
                      return phoneRes.error ?? "Nomor telepon tidak valid";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppButton.iconLeft(
                        icon: const Icon(Icons.close,
                            color: Colors.white, size: 16),
                        text: "Batal",
                        textStyle: headingStyle(context, fontSize: 16),
                        onPressed: () => Navigator.pop(context),
                        isOutlined: true,
                        backgroundColor: formGrey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppButton.iconLeft(
                        text: "Lanjut",
                        icon: const Icon(Icons.check,
                            color: Colors.white, size: 16),
                        backgroundColor: primaryColor,
                        textStyle: headingStyle(context, fontSize: 16),
                        onPressed: () => _sendRequest(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
