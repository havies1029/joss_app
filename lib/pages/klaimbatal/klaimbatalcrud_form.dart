import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/klaimbatal/klaimbatalcrud_bloc.dart';
import 'package:joss_app/models/klaimbatal/klaimbatalcrud_model.dart';

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
        return Scaffold(
          backgroundColor: _bg,
          appBar: AppBar(
            backgroundColor: _bg,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: const Text(
              "Membatalkan",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // tombol bawah (full width) seperti gambar
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isReasonFilled ? _onPressBatalkan : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _orange,
                    disabledBackgroundColor: _orange.withOpacity(0.35),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Batalkan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),

          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Isi alasan pembatalan untuk proses verifikasi permintaan Anda.",
                      style: TextStyle(color: _textDim, fontSize: 13),
                    ),
                    const SizedBox(height: 14),

                    // panel input besar
                    Container(
                      decoration: BoxDecoration(
                        color: _panel,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _panelInner,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: _buildAlasanField(),
                      ),
                    ),

                    const SizedBox(height: 10),
                    const Text(
                      "* Pastikan alasan pembatalan sesuai dengan dokumen Anda.",
                      style: TextStyle(
                        color: _textDim,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
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
  }

  Widget _buildAlasanField() {
    return TextFormField(
      controller: fieldAlasanBatalController,
      keyboardType: TextInputType.multiline,
      minLines: 10, // bikin tinggi seperti di gambar
      maxLines: 14,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      cursorColor: _orange,
      decoration: InputDecoration(
        labelText: "Alasan Pembatalan",
        labelStyle: const TextStyle(color: _orange, fontWeight: FontWeight.w700),
        hintText: 'Contoh: "Ingin Membatalkan Klaim Properti."',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.35)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isDense: true,
        filled: true,
        fillColor: _panelInner,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _orange.withOpacity(0.85), width: 1.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _orange, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300, width: 1.6),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300, width: 1.8),
        ),
      ),
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
          backgroundColor: const Color(0xFF3A3A3A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Apakah kamu yakin Klaim ini dibatalkan?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Setelah dibatalkan, proses klaim akan dihentikan.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5A5A5A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Tidak",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Iya",
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
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
