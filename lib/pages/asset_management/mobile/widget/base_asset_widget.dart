import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/pages/asset_management/mobile/widget/asset_list_widget.dart';
import '../../../../../../common/constants.dart';
// import '../../../../models/combobox/combocoblist_model.dart';
import '../../../../models/gen_aset_dashboard/asetdashboardcari_model.dart';
// import '../../../../repositories/combobox/combocoblist_repository.dart';
import '../../../../repositories/gen_aset_dashboard/asetdashboardcari_repository.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:joss_app/models/combobox/combomcobapp1_model.dart';
import 'package:joss_app/repositories/combobox/combomcobapp1_repository.dart';

import 'base_table/base_table_aset_widget.dart';

class BaseAssetWidget extends StatefulWidget {
  const BaseAssetWidget({super.key});

  @override
  _BaseAssetWidgetState createState() => _BaseAssetWidgetState();
}
class _BaseAssetWidgetState extends State<BaseAssetWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  ComboMCobApp1Model? _selectedCob;
  final Map<String, dynamic> _formData = {};
  late final Future<List<ComboMCobApp1Model>> _cobFuture;

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

    _cobFuture = ComboMCobApp1Repository().getComboMCobApp1("").then((list) {
      final defaultCob = list.firstWhere(
            (e) => e.mCobApp1Id.toString() == "10002",
        orElse: () => list.isNotEmpty
            ? list.first
            : ComboMCobApp1Model(mCobApp1Id: "0", cobNama: "Kosong"),
      );

      if (mounted) {
        setState(() {
          _selectedCob = defaultCob;
        });

        if (defaultCob.mCobApp1Id != "0") {
          _fetchDashboard(defaultCob.mCobApp1Id);
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

    return Expanded(
      child: Container(
        color: secondaryBlackColor,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            BaseTableAsetWidget(
              cobId: _selectedCob?.mCobApp1Id,
              cobNama: _selectedCob?.cobNama,
            ),

          ],
        ),
      ),
    );
  }
}

