import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../blocs/gen_compro/reqcompro_bloc.dart';
import '../../../common/constants.dart';
import '../../../models/gen_compro/reqcompro_model.dart';
import '../../../repositories/gen_compro/reqcompro_repository.dart';

class CompanyProfileCard extends StatelessWidget {
  const CompanyProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReqComproBloc(repository: ReqComproRepository()),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double offsetY = kIsWeb ? -30 : -40;
          final double bgWidth =
          constraints.maxWidth > 420 ? 392 : constraints.maxWidth * 1;
          final double cardWidth =
          constraints.maxWidth > 420 ? 340 : constraints.maxWidth * 0.9;

          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: bgWidth,
                height: 134,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/compro_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, offsetY),
                child: SafeArea(
                  child: Container(
                    width: cardWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              ),
            ],
          );
        },
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

  void _sendRequest(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      String input = _controller.text.trim();

      if (input.startsWith('0')) {
        input = '62${input.substring(1)}';
      } else if (!input.startsWith('62')) {
        input = '62$input';
      }

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
                appTextField(
                  label: "No. Telp",
                  controller: _controller,
                  keyboardType: TextInputType.phone,
                  prefix: Text(
                    "+62 | ",
                    style: bodyTextStyle(context, fontSize: 16),
                  ),
                  hint: "Masukkan nomor telepon",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nomor telepon wajib diisi";
                    }
                    if (value.length < 9) {
                      return "Nomor terlalu pendek";
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
                        height: 31.58,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppButton.iconLeft(
                        text: "Lanjut",
                        height: 31.58,
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
