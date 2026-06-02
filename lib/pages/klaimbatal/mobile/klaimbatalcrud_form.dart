import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/klaimbatal/klaimbatalcrud_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/klaimbatal/klaimbatalcrud_model.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';

import '../../../blocs/klaimrinci/mstatusrincicari_bloc.dart';
import '../../gen_klaim/mobile/klaim_main_page.dart';
import '../../perbaruiklaimpar/mobile/perbaruisuccess_page.dart';

class KlaimbatalcrudFormPage extends StatefulWidget {
  final String klaim1Id;

  const KlaimbatalcrudFormPage({super.key, required this.klaim1Id});

  @override
  State<KlaimbatalcrudFormPage> createState() => _KlaimbatalcrudFormPageState();
}

class _KlaimbatalcrudFormPageState extends State<KlaimbatalcrudFormPage> {
  late KlaimbatalcrudBloc klaimbatalcrudBloc;

  final fieldAlasanBatalController = TextEditingController();

  final Map<String, String?> fieldErrors = {};
  String? err(String key) => fieldErrors[key];

  void setErr(String key, String? msg) {
    setState(() => fieldErrors[key] = msg);
  }

  void clearErr(String key) {
    if (!fieldErrors.containsKey(key)) return;
    setState(() => fieldErrors.remove(key));
  }

  void clearErrsByPrefix(String prefix) {
    setState(() {
      fieldErrors.removeWhere((k, _) => k.startsWith(prefix));
    });
  }

  @override
  void dispose() {
    fieldAlasanBatalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    klaimbatalcrudBloc = BlocProvider.of<KlaimbatalcrudBloc>(context);

    return BlocConsumer<KlaimbatalcrudBloc, KlaimbatalcrudState>(
      listener: (context, state) {
        if (state.isSaved || !state.hasFailure) {
          context.read<MstatusrinciCariBloc>().add(
            SelectedIdChanged("30"),
          );

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PerbaruiSuccessPage(
                display: "Klaim Kamu Berhasil Dibatalkan",
                description: "Permintaan pembatalan klaim kamu telah kami terima.",
                displayButton: "Kembali",
                onButtonPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const KlaimMainPage(),
                    ),
                        (route) => route.isFirst,
                  );
                },
              ),
            ),
          );
        }

        if (state.isSaved || state.hasFailure) {
          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar('Pembatalan klaim gagal'));
        }
      },
      builder: (context, state) {
        return BaseBackgroundSidePage(
          title: 'Membatalkan',
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              color: secondaryBlackColor,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Isi alasan pembatalan untuk proses verifikasi permintaan Anda.",
                            style: bodyTextStyle(
                              context,
                              fontSize: getResponsiveFont(context, 16),
                            ),
                          ),
                          const SizedBox(height: hPadding),
                          _buildAlasanField(),
                          const SizedBox(height: 8),
                          Text(
                            "* Pastikan alasan pembatalan sesuai dengan dokumen Anda.",
                            style: TextStyle(
                              color: hintGrey,
                              fontSize: getResponsiveFont(context, 12),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: AppButton.primary(
                      text: "Batalkan",
                      onPressed: _onPressBatalkan,
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
      errorText: err('form.alasanBatal'),
      validator: (_) => err('form.alasanBatal'),
      onChanged: (value) {
        if (value.trim().isNotEmpty) {
          clearErr('form.alasanBatal');
        }
      },
    );
  }

  bool validateForm() {
    clearErrsByPrefix('form.');

    bool ok = true;

    if (fieldAlasanBatalController.text.trim().isEmpty) {
      setErr('form.alasanBatal', kStringNullError);
      ok = false;
    }

    return ok;
  }

  void _onPressBatalkan() async {
    FocusScope.of(context).unfocus();

    final okValidate = validateForm();
    if (!okValidate) return;

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Apakah kamu yakin Klaim ini dibatalkan?",
                  textAlign: TextAlign.center,
                  style: headingStyle(context, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  "Setelah dibatalkan, proses klaim akan dihentikan.",
                  textAlign: TextAlign.center,
                  style: bodyTextStyle(context, fontSize: 14),
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