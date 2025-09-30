import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/pages/asset_management/mobile/widget/asset_list_widget.dart';
import '../../../../../../common/constants.dart';
import '../../../../models/combobox/combocoblist_model.dart';
import '../../../../models/gen_aset_dashboard/asetdashboardcari_model.dart';
import '../../../../repositories/combobox/combocoblist_repository.dart';
import '../../../../repositories/gen_aset_dashboard/asetdashboardcari_repository.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'base_table/base_table_aset_widget.dart';

class BaseAssetWidget extends StatefulWidget {
  const BaseAssetWidget({super.key});

  @override
  _BaseAssetWidgetState createState() => _BaseAssetWidgetState();
}
class _BaseAssetWidgetState extends State<BaseAssetWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  ComboCobListModel? _selectedCob;
  final Map<String, dynamic> _formData = {};
  late final Future<List<ComboCobListModel>> _cobFuture;

  // Tambah state buat hasil dashboard
  List<AsetDashboardCariModel>? _dashboard;
  bool _loadingDashboard = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: defaultDuration,
      vsync: this,
    );

    // Ambil data COB
    _cobFuture = ComboCobListRepository().getComboCobList().then((list) {
      // cari COB default dengan ID 10001
      final defaultCob = list.firstWhere(
            (e) => e.mCobApp1Id.toString() == "10001",
        orElse: () => list.isNotEmpty
            ? list.first
            : ComboCobListModel(mCobApp1Id: "0", cobNama: "Kosong"),
      );

      if (mounted) {
        setState(() {
          _selectedCob = defaultCob;
        });

        if (defaultCob.mCobApp1Id != "0") {
          _fetchDashboard(defaultCob.mCobApp1Id); // langsung fetch dashboard
        }
      }

      return list;
    });
  }


  Future<void> _fetchDashboard(String cobId) async {
    setState(() => _loadingDashboard = true);
    try {
      final repo = AsetDashboardCariRepository();
      final result = await repo.getAsetDashboardCari(cobId);
      setState(() => _dashboard = result);

      // Debug print hasil
      for (var item in result) {
        // debugPrint("Dashboard: ${item.toJson()}");
      }
    } catch (e) {
      // debugPrint("Error fetch dashboard: $e");
    } finally {
      setState(() => _loadingDashboard = false);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final headerSpacing = screenHeight * 0.025;

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: secondaryBlackColor,
          // no borderRadius
        ),
        child: Padding(
          padding: const EdgeInsets.all(hPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: hPadding),
              // COB ChoiceChip list
              AssetListWidget(
                labelText: '',
                initItem: _selectedCob,
                loader: () => _cobFuture,
                onChangedCallback: (val) {
                  if (_selectedCob?.mCobApp1Id != val?.mCobApp1Id) {
                    setState(() => _selectedCob = val);
                  }

                  if (val != null) {
                    _formData['cobId'] = val.mCobApp1Id;
                    _formData['cobNama'] = val.cobNama;

                    debugPrint("COB dipilih: ${val.mCobApp1Id} - ${val.cobNama}");
                    _fetchDashboard(val.mCobApp1Id);
                  }
                },
                onSaveCallback: (val) {
                  _formData['cobId'] = val?.mCobApp1Id;
                  _formData['cobNama'] = val?.cobNama;
                },
                validatorCallback: (val) =>
                val == null ? 'Pilih COB dulu ya' : null,
                horizontalScroll: true,
                allowDeselect: false,
              ),

              const SizedBox(height: hPadding),

              // // tampilkan loading / hasil dashboard
              // if (_loadingDashboard)
              //   const Center(child: CircularProgressIndicator())
              // else if (_dashboard != null && _dashboard!.isNotEmpty)
              //   Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: hPadding),
              //     child: Row(
              //       children: [
              //         _buildStatusBox(
              //           assetPath: "assets/icons/correct.svg",
              //           value: _dashboard!.first.aktifQty,
              //           bgColor: Colors.green,
              //         ),
              //         const SizedBox(width: vPadding), // jarak antar box
              //         _buildStatusBox(
              //           assetPath: "assets/icons/clock.svg",
              //           value: _dashboard!.first.berakhirQty,
              //           bgColor: Colors.orange,
              //         ),
              //         const SizedBox(width: vPadding),
              //         _buildStatusBox(
              //           assetPath: "assets/icons/exit.svg",
              //           value: _dashboard!.first.nonAktifQty,
              //           bgColor: Colors.red,
              //         ),
              //         const SizedBox(width: vPadding),
              //         _buildStatusBox(
              //           assetPath: "assets/icons/calender.svg",
              //           value: _dashboard!.first.onProgressQty,
              //           bgColor: Colors.blue,
              //         ),
              //       ],
              //     ),
              //   ),
              //
              // const SizedBox(height: vPadding),
              // BaseTableAsetWidget(
              //   cobId: _formData['cobId'],
              //   cobNama: _formData['cobNama'],
              // ),
              BaseTableAsetWidget(
                cobId: _selectedCob?.mCobApp1Id,
                cobNama: _selectedCob?.cobNama,
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBox({
    required String assetPath,
    required int value,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: sGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: SvgPicture.asset(
                assetPath,
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Text(
            value.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: getResponsiveFont(context, 16),
            ),
          ),
        ],
      ),
    );
  }
}

