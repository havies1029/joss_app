import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../common/constants.dart';

class CompanyProfileCard extends StatelessWidget {

  const CompanyProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double offsetY = kIsWeb ? -30 : -50;
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                        'Semua tentang JPS dalam satu dokumen.',
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
                              builder: (_) => const ComproContactDialog(),
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
    );
  }
}

class ComproContactDialog extends StatefulWidget {
  const ComproContactDialog({Key? key}) : super(key: key);

  @override
  State<ComproContactDialog> createState() => ComproContactDialogState();
}

class ComproContactDialogState extends State<ComproContactDialog> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                      icon:
                      const Icon(Icons.check, color: Colors.white, size: 16),
                      backgroundColor: primaryColor,
                      textStyle: headingStyle(context, fontSize: 16),
                      onPressed: () {
                        // 🔹 Jalankan validasi form
                        if (_formKey.currentState!.validate()) {
                          final phone = _controller.text.trim();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Nomor: +62 $phone')),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}