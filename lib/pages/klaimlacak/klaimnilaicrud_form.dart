import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/klaimlacak/klaimnilaicrud_bloc.dart';
import 'package:joss_app/models/klaimlacak/klaimnilaicrud_model.dart';

class KlaimnilaicrudFormPage extends StatefulWidget {
  final String klaim1Id;

  const KlaimnilaicrudFormPage({super.key, required this.klaim1Id});

  @override
  KlaimnilaicrudFormPageFormState createState() => KlaimnilaicrudFormPageFormState();
}

class KlaimnilaicrudFormPageFormState extends State<KlaimnilaicrudFormPage> {
  late KlaimnilaicrudBloc klaimnilaicrudBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  final fieldAlasanController = TextEditingController();

  int _nilaiSuka = 0; // 1..5, 0 = belum pilih
  bool _didInit = false;

  @override
  void dispose() {
    fieldAlasanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    klaimnilaicrudBloc = BlocProvider.of<KlaimnilaicrudBloc>(context);

    // warna mengikuti screenshot
    const bg = Color(0xFF0F0F0F);
    const card = Color(0xFF1A1A1A);
    final border = Colors.white.withOpacity(0.10);
    final textPrimary = Colors.white;
    final textSecondary = Colors.white.withOpacity(0.70);
    const orange = Color(0xFFFF7A1A);
    const starOn = Color(0xFFF2C94C);

    return BlocConsumer<KlaimnilaicrudBloc, KlaimnilaicrudState>(
      listener: (context, state) {
        // kalau ada state.record (mode ubah / prefill), isi 1x saja
        if (!_didInit && state.isLoaded && state.record != null) {
          _didInit = true;
          fieldAlasanController.text = state.record!.alasan;
          _nilaiSuka = state.record!.nilaiSuka.clamp(0, 5);
          setState(() {});
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: bg,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: _dismissDialog,
            ),
            centerTitle: true,
            title: const Text(
              'Beri Penilaianmu',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Seberapa puas Anda dengan layanan asuransi\nkami?",
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // ===== STAR RATING =====
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                        decoration: BoxDecoration(
                          color: card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _StarRating(
                              value: _nilaiSuka,
                              size: 44,
                              activeColor: starOn,
                              inactiveColor: Colors.white.withOpacity(0.20),
                              onChanged: (v) {
                                setState(() => _nilaiSuka = v);
                                // remove error rating kalau sebelumnya belum pilih
                                removeError(error: kStringNullError);
                              },
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Sangat Tidak suka',
                                    style: TextStyle(color: textSecondary, fontSize: 13)),
                                Text('Sangat suka',
                                    style: TextStyle(color: textSecondary, fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      Text(
                        "Apa alasan anda memberi penilaian ini?",
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ===== ALASAN TEXTAREA (opsional) =====
                      Container(
                        decoration: BoxDecoration(
                          color: card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: border),
                        ),
                        child: TextFormField(
                          controller: fieldAlasanController,
                          keyboardType: TextInputType.multiline,
                          minLines: 5,
                          maxLines: 7,
                          style: TextStyle(color: textPrimary, fontSize: 15),
                          decoration: InputDecoration(
                            hintText: "Tulis pengalaman atau masukan anda (Opsional)",
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.35)),
                            contentPadding: const EdgeInsets.all(14),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            // alasan optional => tidak wajib removeError
                          },
                          validator: (value) {
                            // sesuai gambar: optional => selalu valid
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, size: 18, color: Colors.white.withOpacity(0.55)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Masukan anda akan kami gunakan untuk peningkatan kualitas\ndan layanan kami",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.55),
                                fontSize: 13,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      FormError(errors: errors, key: null),
                      const SizedBox(height: 18),

                      // ===== BUTTON SIMPAN =====
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: onSaveForm,
                          child: const Text(
                            'Simpan',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _dismissDialog() {
    Navigator.pop(context);
  }

  void onSaveForm() {
    // validasi rating: minimal pilih 1 bintang
    if (_nilaiSuka <= 0) {
      addError(error: "Rating wajib dipilih"); 
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final record = KlaimnilaicrudModel(
        klaim1Id: widget.klaim1Id,
        alasan: fieldAlasanController.text,
        klaimnilaiId: '',
        nilaiSuka: _nilaiSuka,
      );

      klaimnilaicrudBloc.add(KlaimnilaicrudTambahEvent(record: record));
      _dismissDialog();
    }
  }

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() => errors.add(error));
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() => errors.remove(error));
    }
  }
}

class _StarRating extends StatelessWidget {
  final int value; // 0..5
  final int max;
  final double size;
  final ValueChanged<int> onChanged;
  final Color activeColor;
  final Color inactiveColor;

  const _StarRating({
    required this.value,
    required this.onChanged,
    this.size = 44,
    required this.activeColor,
    required this.inactiveColor,
    this.max = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(max, (i) {
        final idx = i + 1;
        final isOn = idx <= value;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged(idx),
          child: Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Icon(
              isOn ? Icons.star_rounded : Icons.star_outline_rounded,
              size: size,
              color: isOn ? activeColor : inactiveColor,
            ),
          ),
        );
      }),
    );
  }
}
