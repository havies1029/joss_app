import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/pages/asset_management/mobile/widget/asset_list_widget.dart';
import 'package:joss_app/pages/asset_management/mobile/widget/base_asset_widget.dart';
import '../../../../../../common/constants.dart';
import '../../../models/combobox/combocoblist_model.dart';
import '../../../repositories/combobox/combocoblist_repository.dart';
import '../../../widgets/apptheme/header_card.dart';
import '../../base/base_background_sidepage.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;
    final headerSpacing = screenHeight * 0.025;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryBlackColor,
      body: SafeArea(
        child: BaseBackgroundSidePage(
          backgroundAsset: "assets/images/background_gradient.png",
          fadeHeight: 300,
          title: 'Aset',
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const HeaderCard(
                  iconPath: "assets/icons/aset-3.svg",
                  title: "Aset",
                  subtitle: "Kelola dan pantau semua aset Anda dalam satu aplikasi.",
                ),
                const SizedBox(height: 12),
                // kotak hitam di bawah HeaderCard
                BaseAssetWidget(),
              ],
            ),
          ),

        ),
      ),
    );
  }
}
