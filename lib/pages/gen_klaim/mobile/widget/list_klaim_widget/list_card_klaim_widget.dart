import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/gen_klaim/klaim1crud_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/models/combobox/combomstsclaim_model.dart';
import 'package:joss_app/blocs/gen_klaim/klaim1list_bloc.dart';

import '../../../../../models/gen_klaim/klaim1list_model.dart';

class ListCardKlaimWidget extends StatefulWidget {
  final Map<String, bool> isSavingById;
  final void Function(String id, Klaim1CrudModel record) onSaveExisting;
  final void Function(String id) onDelete;
  final void Function(Klaim1ListModel record) onView;

  const ListCardKlaimWidget({
    super.key,
    required this.isSavingById,
    required this.onSaveExisting,
    required this.onDelete,
    required this.onView,
  });

  @override
  State<ListCardKlaimWidget> createState() => _ListCardKlaimWidgetState();
}

class _RowCtrls {
  final formKey = GlobalKey<FormState>();
  final insuredName = TextEditingController();
  final kejadianLokasi = TextEditingController();
  final klaimAmount = TextEditingController();
  final kategoriAsuransi = "Asuransi Properti";
  DateTime? kejadianTgl;

  final mataUangKey = GlobalKey<DropdownSearchState<ComboRMatauangModel>>();
  ComboRMatauangModel? rMatauang;

  final stsClaimKey = GlobalKey<DropdownSearchState<ComboMStsclaimModel>>();
  ComboMStsclaimModel? mStsclaim;

  void dispose() {
    insuredName.dispose();
    kejadianLokasi.dispose();
    klaimAmount.dispose();
  }
}

class _ListCardKlaimWidgetState extends State<ListCardKlaimWidget> {
  final Map<String, _RowCtrls> _rowCtrls = {};
  final _today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  void dispose() {
    for (final c in _rowCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Klaim1ListBloc, Klaim1ListState>(
      buildWhen: (p, c) => p.items != c.items || p.status != c.status,
      builder: (context, state) {
        // debugPrint("📢 Klaim1ListState update:");
        // debugPrint("Status: ${state.status}");
        // debugPrint("Jumlah items: ${state.items.length}");
        //
        // for (final item in state.items) {
        //   debugPrint(
        //     "👉 ID: ${item.klaim1Id}, "
        //         "Nama: ${item.insuredName}, "
        //         "Lokasi: ${item.kejadianLokasi}, "
        //         "Tanggal: ${item.kejadianTgl}, "
        //         "Amount: ${item.klaimAmount}, "
        //         "Mata Uang: ${item.rmatauangNama}, "
        //         "Status: ${item.statusNama}",
        //   );
        // }

        // Error State
        if (state.status == ListStatus.failure) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Gagal memuat data Klaim'),
                const SizedBox(height: 8),
                TextButton(
                  onPressed:
                      () => context.read<Klaim1ListBloc>().add(
                        FetchKlaim1ListEvent(),
                      ),
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          );
        }

        _ensureRowControllers(state);

        // Empty State
        if (state.items.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: const [
                Icon(Icons.receipt_long_outlined, size: 48, color: sGrey),
                SizedBox(height: 8),
                Text('Belum ada data Klaim', style: TextStyle(color: sGrey)),
              ],
            ),
          );
        }

        // Success State dengan list klaim
        return Container(
          color: secondaryBlackColor,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: hPadding * 1.5,
              vertical: vPadding,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 15),
            itemBuilder: (ctx, idx) {
              final item = state.items[idx];
              final ctrls = _rowCtrls[item.klaim1Id]!;
              final saving = widget.isSavingById[item.klaim1Id] ?? false;
              final kategoriAsuransi = 'Asuransi Properti';

              return KlaimCardWidget(
                kategoriAsuransi: kategoriAsuransi,
                insuredNameCtrl: ctrls.insuredName,
                lokasiCtrl: ctrls.kejadianLokasi,
                initialTanggal: ctrls.kejadianTgl ?? DateTime.now(),
                amountCtrl: ctrls.klaimAmount,
                mataUang: item.curr,
                status: item.statusNama ?? "Waiting Doc",
                onView: () => widget.onView(item),
              );
            },
          ),
        );
      },
    );
  }

  void _ensureRowControllers(Klaim1ListState state) {
    if (state.items.isEmpty) {
      _rowCtrls.clear();
      return;
    }
    for (final item in state.items) {
      if (!_rowCtrls.containsKey(item.klaim1Id)) {
        final c = _RowCtrls();
        c.insuredName.text = item.insuredName ?? '';
        c.kejadianLokasi.text = item.kejadianLokasi ?? '';
        c.klaimAmount.text =
            (item.klaimAmount == 0)
                ? ''
                : NumberFormat.decimalPattern('id').format(item.klaimAmount);
        c.kejadianTgl = item.kejadianTgl ?? _today;
        c.rMatauang = ComboRMatauangModel(
          rmatauangKode: item.kursId,
          rmatauangNama: item.rmatauangNama,
        );
        c.mStsclaim = ComboMStsclaimModel(
          mstsclaimId: item.lastStsclaimId,
          statusNama: item.statusNama,
        );
        _rowCtrls[item.klaim1Id] = c;
      }
    }
    final ids = state.items.map((e) => e.klaim1Id).toSet();
    final remove = _rowCtrls.keys.where((id) => !ids.contains(id)).toList();
    for (final id in remove) {
      _rowCtrls[id]?.dispose();
      _rowCtrls.remove(id);
    }
  }
}

class ThousandsFormatterId extends TextInputFormatter {
  final _nf = NumberFormat.decimalPattern('id');
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldV,
    TextEditingValue newV,
  ) {
    final digits = newV.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    final oldDigitsBefore = _countDigitsBefore(
      oldV.text,
      oldV.selection.baseOffset,
    );
    final newDigitsBefore = _countDigitsBefore(
      newV.text,
      newV.selection.baseOffset,
    );
    final number = int.parse(digits);
    final newText = _nf.format(number);
    final targetDigitIndex = newDigitsBefore.clamp(0, digits.length);
    final caretOffset = _offsetForDigitIndex(newText, targetDigitIndex);
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: caretOffset),
    );
  }

  int _countDigitsBefore(String t, int off) {
    if (off <= 0) return 0;
    off = off.clamp(0, t.length);
    return RegExp(r'[0-9]').allMatches(t.substring(0, off)).length;
  }

  int _offsetForDigitIndex(String f, int idx) {
    if (idx <= 0) return 0;
    int c = 0;
    for (int i = 0; i < f.length; i++) {
      if (RegExp(r'[0-9]').hasMatch(f[i])) {
        c++;
        if (c == idx) return i + 1;
      }
    }
    return f.length;
  }
}

class KlaimCardWidget extends StatelessWidget {
  final TextEditingController insuredNameCtrl;
  final TextEditingController lokasiCtrl;
  final DateTime initialTanggal;
  final TextEditingController amountCtrl;
  final String mataUang;
  final String status;
  final VoidCallback? onView;
  final String kategoriAsuransi;


  const KlaimCardWidget({
    super.key,
    required this.kategoriAsuransi,
    required this.insuredNameCtrl,
    required this.lokasiCtrl,
    required this.initialTanggal,
    required this.amountCtrl,
    required this.mataUang,
    required this.status,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: pGrey,
        border: Border.all(color: sGrey),
        borderRadius: BorderRadius.circular(cardBorderRadius),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row (Icon + Asuransi Properti + Amount)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Icon
              SvgPicture.asset(
                _iconForKategori(kategoriAsuransi),
                width: 52,
                height: 52,
              ),
              const SizedBox(width: 12),

              /// Info Asuransi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Asuransi + Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          kategoriAsuransi, // dummy
                          style: headingStyle(context, fontSize: 18),
                        ),
                        Text(
                          "$mataUang ${amountCtrl.text}",
                          style: headingStyle(context, fontSize: 18),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    /// Nama
                    RichText(
                      text: TextSpan(
                        style: headingStyle(context, fontSize: 16).copyWith(fontFamily: 'Delm-Regular'),
                        children: [
                          TextSpan(
                            text: "Nama: ",
                            style: headingStyle(context, fontSize: 16).copyWith(color: hintGrey, fontFamily: 'Delm-Regular'),
                          ),
                          TextSpan(text: insuredNameCtrl.text),
                        ],
                      ),
                    ),
                    const SizedBox(height: 3),
                    /// No Klaim → sementara ambil dari lokasiCtrl
                    RichText(
                      text: TextSpan(
                        style: headingStyle(context, fontSize: 16).copyWith(fontFamily: 'Delm-Regular'),
                        children: [
                          TextSpan(
                            text: "No Klaim: ",
                            style: headingStyle(context, fontSize: 16).copyWith(color: hintGrey, fontFamily: 'Delm-Regular'),
                          ),
                          TextSpan(text: lokasiCtrl.text),
                        ],
                      ),
                    ),
                    const SizedBox(height: 3),

                    /// Tanggal
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: headingStyle(context, fontSize: 16).copyWith(fontFamily: 'Delm-Regular'),
                            children: [
                              TextSpan(
                                text: "Tanggal: ",
                                style: headingStyle(context, fontSize: 16).copyWith(color: hintGrey, fontFamily: 'Delm-Regular'),
                              ),
                              TextSpan(text: _formatTanggal(initialTanggal)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                status == "Disetujui"
                                    ? pGreen
                                    : status == "Waiting Doc"
                                    ? primaryColor
                                    : hintGrey,
                            borderRadius: BorderRadius.circular(
                              cardBorderRadius,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 12,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                status,
                                style: headingStyle(context, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: AppButton.iconLeft(
              text: 'Lihat Detail Klaim',
              backgroundColor: formGrey,
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: onView,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTanggal(DateTime date) {
    return "${date.day} ${_bulan(date.month)} ${date.year}";
  }

  String _bulan(int bulan) {
    const bulanStr = [
      "Jan", "Feb", "Mar", "Apr", "Mei", "Jun",
      "Jul", "Agt", "Sep", "Okt", "Nov", "Des"
    ];
    return bulanStr[bulan - 1];
  }

  String _iconForKategori(String kategoriAsuransi) {
    final name = kategoriAsuransi.toLowerCase();

    if (name.contains('kendaraan') || name.contains('mobil') || name.contains('motor')) {
      return 'assets/icons/kendaraan.svg';
    } else if (name.contains('properti') || name.contains('bangunan')) {
      return 'assets/icons/properti.svg';
    } else if (name.contains('kesehatan') || name.contains('medis')) {
      return 'assets/icons/claim-icon-health.svg';
    } else if (name.contains('kapal') || name.contains('marine')) {
      return 'assets/icons/claim-icon-ship.svg';
    } else if (name.contains('perjalanan') || name.contains('travel')) {
      return 'assets/icons/claim-icon-travel.svg';
    } else if (name.contains('tanggung') || name.contains('gugat') || name.contains('liability')) {
      return 'assets/icons/claim-icon-liability.svg';
    } else {
      return 'assets/icons/claim-icon-default.svg';
    }
  }
}
