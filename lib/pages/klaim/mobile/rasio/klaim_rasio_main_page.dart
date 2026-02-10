import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/models/klaimrasio/klaimrasiodetailcari_model.dart';
import 'package:joss_app/pages/klaim/mobile/rasio/klaim_rasio_table_widget.dart';
import '../../../../blocs/klaimrasio/klaimrasiocobcari_bloc.dart';
import '../../../../common/constants.dart';
import '../../../../helper/expert_helper.dart';
import '../../../../helper/mobile_expert_helper.dart';
import '../../../../widgets/apptheme/polis_button.dart';
import '../../../../widgets/apptheme/popup_widget.dart';

class KlaimRasioMainPage extends StatefulWidget {
  const KlaimRasioMainPage({super.key});

  @override
  State<KlaimRasioMainPage> createState() => _KlaimRasioMainPageState();
}

class _KlaimRasioMainPageState extends State<KlaimRasioMainPage> {
  late KlaimrasiocobCariBloc klaimrasiocobCariBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      refreshData();
    });
  }

  void refreshData() {
    klaimrasiocobCariBloc
        .add(RefreshKlaimrasiocobCariEvent(searchText: _searchController.text));
  }

  IconButton buildSearchButton() {
    return IconButton(
        icon: const Icon(
          Icons.autorenew_rounded,
          size: 35.0,
        ),
        onPressed: () {
          klaimrasiocobCariBloc.add(RefreshKlaimrasiocobCariEvent(
              searchText: _searchController.text));
        });
  }

  @override
  Widget build(BuildContext context) {
    klaimrasiocobCariBloc = BlocProvider.of<KlaimrasiocobCariBloc>(context);

    return Scaffold(
      backgroundColor: secondaryBlackColor,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: hPadding * 1.5,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PolisButton(
                  assetPath: "assets/icons/unduh.svg",
                  bgColor: const Color(0xFFA1A1AA),
                  borderColor: const Color(0xFFBCBCC7),
                  onTap: () => _showExportDialog(context),
                  iconSize: 16,
                  height: 36,
                  width: 36,
                ),
                const SizedBox(width: 8),
                PolisButton(
                  assetPath: "assets/icons/bagikan.svg",
                  bgColor: const Color(0xFF295EFF),
                  borderColor: const Color(0xFF5D86FF),
                  onTap: () => _onShare(context),
                  iconSize: 16,
                  height: 36,
                  width: 36,
                ),
              ],
            ),
          ),
          Expanded(child: KlaimRasioTableWidget()),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    final state = klaimrasiocobCariBloc.state;

    if (state.status != ListStatus.success || state.klaimRasio.cobs.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(infoSnackBar("Tidak ada data untuk diexport"));
      return;
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Tutup",
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: PopupWidget(
              title: "Pilih format file untuk diunduh",
              subtitle: "Tersedia Excel dan PDF",
              button1Text: "Excel",
              button2Text: "PDF",
              onExportSelected: (format) async {
                // ambil semua detail dari semua cobs
                final allDetails =
                    state.klaimRasio.cobs.expand((h) => h.details).toList();

                if (allDetails.isEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      errorSnackBar("Tidak ada data yang dipilih"));
                  return;
                }

                // mapping export
                final data =
                    allDetails.map((d) => _detailToExportMap(d)).toList();

                Navigator.pop(context);
                await _exportDataRincian(context, format, data);
              },
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        ),
      ),
    );
  }

  Map<String, dynamic> _detailToExportMap(KlaimrasiodetailCariModel d) {
    return {
      "No": d.nourut,
      "No Polis": d.polisNo,
      "Periode Mulai": d.periodeMulai.toString().substring(0, 10),
      "Periode Akhir": d.periodeAkhir.toString().substring(0, 10),
      "Curr": d.curr,
      "Premi": d.premiAmount,
      "Klaim": d.klaimAmount,
      "Rasio": d.rasio,
    };
  }

  Future<void> _exportDataRincian(
    BuildContext context,
    ExportFormat format,
    List<Map<String, dynamic>> data,
  ) async {
    final fileName =
        "KlaimRasio_${DateTime.now().millisecondsSinceEpoch}.${format == ExportFormat.excel ? "xlsx" : "pdf"}";

    try {
      if (format == ExportFormat.excel) {
        if (kIsWeb) {
          await ExportHelper.export("excel", data, CategoryType.klaimrasio);
        } else {
          await MobileDownloadHelper.download(
            context: context,
            fileName: fileName,
            data: data,
            format: "excel",
          );
        }
      } else {
        if (kIsWeb) {
          await ExportHelper.export("pdf", data, CategoryType.klaimrasio);
        } else {
          await MobileDownloadHelper.download(
            context: context,
            fileName: fileName,
            data: data,
            format: "pdf",
          );
        }
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          successSnackBar("Berhasil ekspor ${data.length} item"),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(errorSnackBar("Gagal ekspor: $e"));
      }
    }
  }

  void _onShare(BuildContext context) {
    final state = klaimrasiocobCariBloc.state;

    if (state.status != ListStatus.success || state.klaimRasio.cobs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        infoSnackBar("Tidak ada data untuk dibagikan"),
      );
      return;
    }

    final allDetails = state.klaimRasio.cobs.expand((h) => h.details).toList();

    if (allDetails.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        infoSnackBar("Tidak ada data untuk dibagikan"),
      );
      return;
    }

    final Map<String, num> totalPremiByCurr = {};
    final Map<String, num> totalKlaimByCurr = {};

    for (final d in allDetails) {
      totalPremiByCurr[d.curr] =
          (totalPremiByCurr[d.curr] ?? 0) + d.premiAmount;
      totalKlaimByCurr[d.curr] =
          (totalKlaimByCurr[d.curr] ?? 0) + d.klaimAmount;
    }

    final totalPolis = allDetails.length;

    String fmt(num v) => NumberFormat.decimalPattern().format(v);

    final totalText = totalPremiByCurr.keys.map((curr) {
      final premi = fmt(totalPremiByCurr[curr]!);
      final klaim = fmt(totalKlaimByCurr[curr]!);
      return "• $curr → Premi: $premi | Klaim: $klaim";
    }).join("\n");

    final detailText = allDetails.take(20).map((d) {
      final periode =
          "${d.periodeMulai.toString().substring(0, 10)} → ${d.periodeAkhir.toString().substring(0, 10)}";
      return "• ${d.polisNo}\n  $periode\n  Premi: ${d.curr} ${fmt(d.premiAmount)} | "
          "Klaim: ${d.curr} ${fmt(d.klaimAmount)} | "
          "Rasio: ${fmt(d.rasio)}%";
    }).join("\n\n");

    final more = allDetails.length > 20
        ? "\n\n…dan ${allDetails.length - 20} polis lainnya"
        : "";

    final message = '''
📊 Laporan Klaim Rasio

Jumlah Polis: $totalPolis

Total:
$totalText

Detail Polis:
$detailText$more
''';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Container(
          color: secondaryBlackColor,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  Icon(Icons.share, color: primaryColor),
                  const SizedBox(width: 10),
                  Text(
                    "Bagikan Laporan Klaim Rasio",
                    style: bodyTextStyle(context),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                "Total polis terpilih: $totalPolis",
                style: bodyTextStyle(context, fontSize: 14),
              ),

              const SizedBox(height: 20),

              // ACTION
              AppButton.iconLeft(
                text: "Salin Laporan",
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: message));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    successSnackBar("Laporan berhasil disalin"),
                  );
                },
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
