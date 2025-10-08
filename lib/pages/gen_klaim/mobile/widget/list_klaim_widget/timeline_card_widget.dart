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
          backgroundAsset: "assets/images/background_gradient.png",
          fadeHeight: 300,
          title: 'Detail Klaim',
          child: Container(
            color: secondaryBlackColor, // 🔶 Background hitam sekunder
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const HeaderAsuransiCard(
                  iconPath: "assets/icons/home_icon.svg",
                  title: "Asuransi Properti",
                ),
                // 🔶 Timeline
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

                // 🔹 Ringkasan klaim
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: hPadding * 1.5, vertical: 12),
                  decoration: BoxDecoration(
                    color: primaryBlackColor,
                    borderRadius: BorderRadius.circular(cardBorderRadius),
                    border: Border.all(color: pGrey, width: 1),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow("ID Klaim", widget.record.klaim1Id ?? "-"),
                      _divider(),
                      _buildDetailRow("Nama Tertanggung",
                          widget.record.insuredName ?? "-"),
                      _divider(),
                      _buildDetailRow("Lokasi", widget.record.kejadianLokasi ?? "-"),
                      _divider(),
                      _buildDetailRow(
                          "Tanggal Kejadian",
                          widget.record.kejadianTgl?.toString() ?? "-"),
                      _divider(),
                      _buildDetailRow(
                        "Nilai Klaim",
                        NumberFormat.currency(locale: 'id', symbol: 'IDR ')
                            .format(widget.record.klaimAmount ?? 0),
                      ),
                      _divider(),

                      // 🔹 Status dengan badge
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Status Awal Klaim",
                              style: TextStyle(
                                  color: unselectedColor,
                                  fontSize: getResponsiveFont(context, 18)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: (widget.record.statusNama?.toLowerCase() ==
                                    "waiting")
                                    ? Colors.orange
                                    : Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.record.statusNama ?? "-",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: getResponsiveFont(context, 18)),
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
                    backgroundColor: primaryColor,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: unselectedColor, fontSize: getResponsiveFont(context, 18))),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: getResponsiveFont(context, 18),
                color: primaryLightColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      color: pGrey,
    );
  }

  Widget _buildHorizontalTimeline(List<dynamic> items) {
    final int lastIndex = items.length - 1;
    const double stepWidth = 90.0; // 50% lebih pendek dari 180
    const double bulletSize = 56.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
