import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/klaimlacak/klaimnilaicrud_bloc.dart';
import 'package:joss_app/models/klaimlacak/klaimnilaicrud_model.dart';

import '../../../blocs/gen_review/reviewcari_bloc.dart';
import '../../gen_klaim/mobile/klaim_main_page.dart';
import '../../perbaruiklaimpar/mobile/perbaruisuccess_page.dart';

class KlaimnilaicrudFormPage extends StatefulWidget {
  final String klaim1Id;

  const KlaimnilaicrudFormPage({super.key, required this.klaim1Id});

  @override
  KlaimnilaicrudFormPageFormState createState() => KlaimnilaicrudFormPageFormState();
}

class KlaimnilaicrudFormPageFormState extends State<KlaimnilaicrudFormPage> {
  late KlaimnilaicrudBloc klaimnilaicrudBloc;
  late ReviewCariBloc reviewCariBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  final fieldAlasanController = TextEditingController();

  int _nilaiSuka = 0; // 1..5, 0 = belum pilih
  bool _didInit = false;

  @override
  void initState(){
    super.initState();
    klaimnilaicrudBloc = context.read<KlaimnilaicrudBloc>();
    reviewCariBloc = context.read<ReviewCariBloc>();
}

  @override
  void dispose() {
    fieldAlasanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const starOn = Color(0xFFFBBF24);

    return BlocListener<KlaimnilaicrudBloc, KlaimnilaicrudState>(
      listenWhen: (prev, curr) =>
      prev.isSaved != curr.isSaved ||
          prev.isLoaded != curr.isLoaded,
      listener: (context, state) {
        if (!_didInit && state.isLoaded && state.record != null) {
          _didInit = true;
          fieldAlasanController.text = state.record!.alasan;
          _nilaiSuka = state.record!.nilaiSuka.clamp(0, 5);
          setState(() {});
        }

        if (state.isSaved) {
          if (!state.hasFailure) {
            reviewCariBloc.add(RefreshReviewCariEvent());

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => PerbaruiSuccessPage(
                  display: "Masukan Anda telah berhasil kami terima.",
                  description: "Terima kasih atas masukan Anda.",
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
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              errorSnackBar("Data gagal disimpan!"),
            );
          }
        }
      },
      child: BaseBackgroundSidePage(
        title: 'Beri Penilaianmu',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          color: secondaryBlackColor,
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
                          "Seberapa puas Anda dengan layanan asuransi kami?",
                          style: headingStyle(context, fontSize: 20),
                        ),
                        const SizedBox(height: 24),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _StarRating(
                              max: 5,
                              value: _nilaiSuka,
                              size: 50,
                              activeColor: starOn,
                              inactiveColor: pGrey,
                              onChanged: (v) {
                                setState(() => _nilaiSuka = v);
                                removeError(error: 'Rating wajib dipilih');
                              },
                            ),
                            const SizedBox(height: hPadding),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sangat Tidak suka',
                                  style: headingStyle(
                                    context,
                                    fontSize: getResponsiveFont(context, 16),
                                  ),
                                ),
                                Text(
                                  'Sangat suka',
                                  style: headingStyle(
                                    context,
                                    fontSize: getResponsiveFont(context, 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: vPadding),

                        Text(
                          "Apa alasan anda memberi penilaian ini?",
                          style: headingStyle(context, fontSize: 16),
                        ),
                        const SizedBox(height: hPadding),

                        Container(
                          decoration: BoxDecoration(
                            color: formGrey,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: sGrey),
                          ),
                          child: TextFormField(
                            controller: fieldAlasanController,
                            keyboardType: TextInputType.multiline,
                            minLines: 5,
                            maxLines: 7,
                            style: bodyTextStyle(context, fontSize: 16),
                            decoration: InputDecoration(
                              hintText: "Tulis pengalaman atau masukan anda",
                              hintStyle: bodyTextStyle(context, fontSize: 16)
                                  .copyWith(color: hintGrey),
                              contentPadding: const EdgeInsets.all(10),
                              border: InputBorder.none,
                              errorText: err('form.alasan'),
                            ),
                            onChanged: (value) {
                              if (value.trim().isNotEmpty) {
                                clearErr('form.alasan');
                              }
                            },
                          ),
                        ),

                        const SizedBox(height: vPadding),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: Colors.white.withOpacity(0.55),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                "Masukan anda akan kami gunakan untuk peningkatan kualitas dan layanan kami",
                                style: bodyTextStyle(context, fontSize: 14)
                                    .copyWith(color: hintGrey),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        FormError(errors: errors, key: null),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: AppButton.primary(
                  text: 'Selesai',
                  onPressed: onSaveForm,
                  height: 45,
                  backgroundColor: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateForm() {
    clearErrsByPrefix('form.');

    setState(() {
      errors.clear();
    });

    bool ok = true;

    if (_nilaiSuka <= 0) {
      addError(error: 'Rating wajib dipilih');
      ok = false;
    }

    // final alasan = fieldAlasanController.text.trim();
    // if (alasan.isEmpty) {
    //   setErr('form.alasan', 'Alasan penilaian wajib diisi');
    //   ok = false;
    // } else if (alasan.length < 5) {
    //   setErr('form.alasan', 'Alasan penilaian minimal 5 karakter');
    //   ok = false;
    // }

    return ok;
  }

  void _dismissDialog() {
    Navigator.pop(context);
  }

  void onSaveForm() {
    FocusScope.of(context).unfocus();

    final ok = validateForm();
    if (!ok) return;

    final record = KlaimnilaicrudModel(
      klaim1Id: widget.klaim1Id,
      alasan: fieldAlasanController.text.trim(),
      klaimnilaiId: '',
      nilaiSuka: _nilaiSuka,
    );

    klaimnilaicrudBloc.add(KlaimnilaicrudTambahEvent(record: record));
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
}

class _StarRating extends StatelessWidget {
  final int value;
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
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(max, (i) {
        final idx = i + 1;
        final isOn = idx <= value;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged(idx),
          child: Icon(
            isOn ? Icons.star_rounded : Icons.star_outline_rounded,
            size: size,
            color: isOn ? activeColor : inactiveColor,
          ),
        );
      }),
    );
  }
}