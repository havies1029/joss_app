import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/klaim/klaim2list_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/gen_klaim/mobile/widget/list_klaim_widget/timeline/header_asuransi_card_widget.dart';
import 'package:joss_app/pages/gen_klaim/mobile/widget/list_klaim_widget/timeline/step_bullet_widget.dart';
import '../../../../../models/gen_klaim/klaim1list_model.dart';
import '../../../../base/base_background_sidepage.dart';
import '../../klaim_main_page.dart';

class TimelineCardWidget extends StatefulWidget {
  final Klaim1ListModel record;
  const TimelineCardWidget({super.key, required this.record});

  @override
  _TimelineCardWidgetState createState() => _TimelineCardWidgetState();
}

class _TimelineCardWidgetState extends State<TimelineCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ScrollController _hScroll = ScrollController();
  late Klaim2ListBloc klaim2ListBloc;
  final kategoriAsuransi = "Asuransi Properti";

  final List<IconData> _stepIcons = const [
    Icons.upload_rounded,
    Icons.access_time_rounded,
    Icons.assignment_turned_in_rounded,
    Icons.receipt_long_rounded,
    Icons.verified_rounded,
    Icons.payments_rounded,
    Icons.done_all_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: defaultDuration, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      klaim2ListBloc = context.read<Klaim2ListBloc>();
      _refreshData();
    });
  }

  void _refreshData() {
    // ⬅️ ambil klaim1Id dari record
    klaim2ListBloc.add(
      RefreshKlaim2ListEvent(klaim1Id: widget.record.klaim1Id),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlackColor,
      body: SafeArea(
        child: BaseBackgroundSidePage(
          title: 'Detail Klaim',
          child: Container(
            color: secondaryBlackColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 15),
                _headerForKategori(kategoriAsuransi),
                const SizedBox(height: 18),
                Flexible(
                  fit: FlexFit.loose,
                  child: BlocConsumer<Klaim2ListBloc, Klaim2ListState>(
                    buildWhen: (prev, curr) =>
                    prev.status != curr.status || prev.items != curr.items,
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state.status == ListStatus.initial) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                          ),
                        );
                      }
                      if (state.status == ListStatus.success && state.items.isNotEmpty) {
                        return _buildHorizontalTimeline(state.items);
                      }
                      return Center(
                        child: Text(
                          "No Data Available!!",
                          style: TextStyle(
                            color: primaryLightColor.withOpacity(0.6),
                            fontSize: getResponsiveFont(context, 18),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: hPadding * 1.5),
                  decoration: BoxDecoration(
                    color: pGrey,
                    borderRadius: BorderRadius.circular(cardBorderRadius),
                    border: Border.all(color: sGrey),
                  ),
                  child: Column(
                    children: [
                      // _buildDetailRow("ID Klaim", widget.record.klaim1Id ?? "-"),
                      // kDivider(color: sGrey),
                      _buildDetailRow("Nama Tertanggung",
                          widget.record.insuredName ?? "-"),
                      kDivider(color: sGrey),
                      _buildDetailRow("Lokasi", widget.record.kejadianLokasi ?? "-"),
                      kDivider(color: sGrey),
                      _buildDetailRow(
                          "Tanggal Kejadian",
                          widget.record.kejadianTgl.toString() ?? "-"),
                      kDivider(color: sGrey),
                      _buildDetailRow(
                        "Nilai Klaim",
                        NumberFormat.currency(locale: 'id', symbol: 'IDR ')
                            .format(widget.record.klaimAmount ?? 0),
                      ),
                      kDivider(color: sGrey),

                      // 🔹 Status dengan badge
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Status Awal Klaim",
                              style: bodyTextStyle(context).copyWith(color: hintGrey),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: (widget.record.statusNama.toLowerCase() ==
                                    "waiting")
                                    ? primaryColor
                                    : pGreen,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.record.statusNama ?? "-",
                                style: bodyTextStyle(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: vPadding),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                  child: AppButton.iconLeft(
                    text: 'Ajukan Klaim Baru',
                    icon: const Icon(Icons.add_box, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const KlaimMainPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ======= UI Builders =======
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: bodyTextStyle(context).copyWith(color: hintGrey)),
          Flexible(
            child: Text(
              value,
              style: bodyTextStyle(context),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalTimeline(List<dynamic> items) {
    final int lastIndex = items.length - 1;
    const double stepWidth = 90.0; // 50% lebih pendek dari 180
    const double bulletSize = 56.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        controller: _hScroll,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Stack(
          children: [
            // Background connector line - tidak menembus bullet
            if (items.length > 1)
              Positioned(
                top: 28, // Half of bullet size (56/2 = 28)
                left: (stepWidth / 2) + (bulletSize / 2), // Start after first bullet
                child: Container(
                  width: ((items.length - 1) * stepWidth) - bulletSize, // Total width minus bullets
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: pGrey,
                  ),
                ),
              ),
            // Progress overlay line - tidak menembus bullet
            if (lastIndex > 0)
              Positioned(
                top: 28,
                left: (stepWidth / 2) + (bulletSize / 2), // Start after first bullet
                child: Container(
                  width: (lastIndex * stepWidth) - bulletSize, // Progress width minus bullets
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: primaryColor,
                  ),
                ),
              ),
            // Bullets row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.asMap().entries.map((entry) {
                final int stepIdx = entry.key;
                final item = entry.value;

                final bool isActive = stepIdx == lastIndex;
                final bool isDone = stepIdx < lastIndex;

                final icon = _iconFor(item.statusNama, stepIdx);
                final label = (item.statusNama as String?)?.trim().isNotEmpty == true
                    ? item.statusNama
                    : 'Step ${stepIdx + 1}';

                return StepBulletWithText(
                  label: label,
                  icon: icon,
                  isActive: isActive,
                  isDone: isDone,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  HeaderAsuransiCard _headerForKategori(String kategoriAsuransi) {
    final name = kategoriAsuransi.toLowerCase();
    String iconPath;

    if (name.contains('kendaraan') || name.contains('mobil') || name.contains('motor')) {
      iconPath = 'assets/icons/claim-icon-car.svg';
    } else if (name.contains('properti') || name.contains('bangunan')) {
      iconPath = 'assets/icons/claim-icon-property.svg';
    } else if (name.contains('kesehatan') || name.contains('medis')) {
      iconPath = 'assets/icons/claim-icon-health.svg';
    } else if (name.contains('kapal') || name.contains('marine')) {
      iconPath = 'assets/icons/claim-icon-ship.svg';
    } else if (name.contains('perjalanan') || name.contains('travel')) {
      iconPath = 'assets/icons/claim-icon-travel.svg';
    } else if (name.contains('tanggung') || name.contains('gugat') || name.contains('liability')) {
      iconPath = 'assets/icons/claim-icon-liability.svg';
    } else {
      iconPath = 'assets/icons/claim-icon-default.svg';
    }

    return HeaderAsuransiCard(
      title: kategoriAsuransi,
      iconPath: iconPath,
      onTap: () => debugPrint('Tapped on header $kategoriAsuransi'),
    );
  }

  IconData _iconFor(String? statusNama, int index) {
    // kalau mau mapping spesifik status → ikon, isi di sini
    final name = (statusNama ?? '').toLowerCase();
    if (name.contains('ajukan') || name.contains('diajukan')) {
      return Icons.upload_rounded;
    }
    if (name.contains('proses') || name.contains('diproses')) {
      return Icons.access_time_rounded;
    }
    if (name.contains('verif')) {
      return Icons.verified_rounded;
    }
    if (name.contains('setuju') || name.contains('approve')) {
      return Icons.task_alt_rounded;
    }
    if (name.contains('bayar') || name.contains('pembayaran')) {
      return Icons.payments_rounded;
    }
    if (name.contains('dokumen') || name.contains('berkas')) {
      return Icons.receipt_long_rounded;
    }
    if (name.contains('selesai') || name.contains('complete')) {
      return Icons.done_all_rounded;
    }
    // fallback: loop 7 ikon
    return _stepIcons[index % _stepIcons.length];
  }
}
