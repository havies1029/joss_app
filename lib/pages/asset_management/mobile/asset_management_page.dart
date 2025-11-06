import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/pages/asset_management/mobile/widget/asset_list_widget.dart';
import 'package:joss_app/pages/asset_management/mobile/widget/base_asset_widget.dart';
import '../../../../../../common/constants.dart';
import '../../../models/combobox/combocoblist_model.dart';
import '../../../repositories/combobox/combocoblist_repository.dart';
import '../../../widgets/apptheme/header_card.dart';
import '../../base/base_background_sidepage.dart';
import '../circular_spread.dart';
import '../draggable_beli_polis_button.dart';

class AssetManagementPage extends StatefulWidget {
  const AssetManagementPage({super.key});

  @override
  _AssetManagementPageState createState() => _AssetManagementPageState();
}

class _AssetManagementPageState extends State<AssetManagementPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: defaultDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlackColor,
      body: SafeArea(
        child: Stack(
          children: [
            BaseBackgroundSidePage(
              title: 'Polis',
              child: Form(
                key: _formKey,
                child: Column(
                  children: const [
                    HeaderCard(
                      iconPath: "assets/icons/menu_polis.svg",
                      title: "Polis",
                      subtitle:
                      "Kelola dan pantau semua polis Anda dalam satu aplikasi.",
                    ),
                    BaseAssetWidget(),
                  ],
                ),
              ),
            ),

            const DraggableBeliPolisButton(),
            const DraggableHalfCircleButton(),
          ],
        ),
      ),
    );

  }
}
