import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/klaimbatal/klaimbatalcrud_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/klaimbatal/klaimbatalcrud_model.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';

class KlaimbatalcrudFormPage extends StatefulWidget {
  final String klaim1Id;

  const KlaimbatalcrudFormPage({super.key, required this.klaim1Id});

  @override
  State<KlaimbatalcrudFormPage> createState() => _KlaimbatalcrudFormPageState();
}

class _KlaimbatalcrudFormPageState extends State<KlaimbatalcrudFormPage> {
  late KlaimbatalcrudBloc klaimbatalcrudBloc;

  final _formKey = GlobalKey<FormState>();
  final fieldAlasanBatalController = TextEditingController();

  // ===== colors (sesuaikan kalau kamu sudah punya Constants/MyColors) =====
  static const _bg = Color(0xFF0F0F0F);
  static const _panel = Color(0xFF2A2A2A);
  static const _panelInner = Color(0xFF333333);
  static const _orange = Color(0xFFFF7A18); // mendekati oranye di gambar
  static const _textDim = Color(0xFFBDBDBD);

  @override
  void dispose() {
    fieldAlasanBatalController.dispose();
    super.dispose();
  }

  bool get _isReasonFilled =>
      fieldAlasanBatalController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    klaimbatalcrudBloc = BlocProvider.of<KlaimbatalcrudBloc>(context);

    return BlocConsumer<KlaimbatalcrudBloc, KlaimbatalcrudState>(
      listener: (context, state) {
        // kalau kamu mau handle sukses/gagal dari bloc, taruh di sini
      },
      builder: (context, state) {
        return BaseBackgroundSidePage(
          title: 'Membatalkan',
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              color: secondaryBlackColor,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Isi alasan pembatalan untuk proses verifikasi permintaan Anda.",
                              style: bodyTextStyle(context, fontSize: 16),
                            ),

                            const SizedBox(height: hPadding),
                            // panel input besar
                            Container(
                              decoration: BoxDecoration(
                                color: pGrey,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: sGrey,),
                              ),
                              padding: const EdgeInsets.all(5),
                              child: _buildAlasanField(),
                            ),

                            const SizedBox(height: 8),
                            const Text(
                              "* Pastikan alasan pembatalan sesuai dengan dokumen Anda.",
                              style: TextStyle(
                                color: hintGrey,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: AppButton.primary(
                      text: "Batalkan",
                      onPressed: _isReasonFilled ? _onPressBatalkan : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlasanField() {
    return appTextField(
      label: 'Alasan Pembatalan',
      hint: 'Contoh: "Ingin Membatalkan Klaim Properti".',
      controller: fieldAlasanBatalController,
      keyboardType: TextInputType.multiline,
      maxLines: 15,
      onChanged: (_) => setState(() {}),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          // kamu bisa pakai kStringNullError kalau mau,
          // tapi biar mirip UX gambar, cukup validasi sederhana
          return "";
        }
        return null;
      },
    );
  }

  void _onPressBatalkan() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final ok = await _showConfirmDialog();
    if (ok != true) return;

    final record = KlaimbatalcrudModel(
      alasanBatal: fieldAlasanBatalController.text.trim(),
      klaim1Id: widget.klaim1Id,
    );

    klaimbatalcrudBloc.add(KlaimbatalcrudUbahEvent(record: record));

    if (mounted) Navigator.pop(context);
  }

  Future<bool?> _showConfirmDialog() {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (ctx) {
        return Dialog(
          backgroundColor: formGrey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding:EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Apakah kamu yakin Klaim ini dibatalkan?",
                  textAlign: TextAlign.center,
                  style: headingStyle(context, fontSize: 18)
                ),
                const SizedBox(height: 8),
                Text(
                  "Setelah dibatalkan, proses klaim akan dihentikan.",
                  textAlign: TextAlign.center,
                  style: bodyTextStyle(context, fontSize: 14)
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppButton.primary(
                        onPressed: () => Navigator.pop(ctx, false),
                        text: 'Tidak',
                        height: 36,
                        backgroundColor: sGrey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppButton.primary(
                        text: 'Iya',
                        height: 36,
                        onPressed: () => Navigator.pop(ctx, true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
