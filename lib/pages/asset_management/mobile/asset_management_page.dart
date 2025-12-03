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

  void onTambahData() {
    debugPrint("🔥 Tambah data ditekan");
    // nanti lu isi navigasi, popup, atau logic tambah data
  }

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
<<<<<<< HEAD

            // const DraggableBeliPolisButton(),
          Stack(
            children: [
              // konten halaman lain...

              BottomCenterAddButton(
                  actions: [
                    MiniActionButton(
                      iconPath: 'assets/icons/beli_polis1.svg',
                      gradient: yellowGradient,
                      label: "Beli Polis",
                      onTap: () {},
                    ),
                    MiniActionButton(
                      iconPath: 'assets/icons/endorse1.svg',
                      gradient: blueGradient ,
                      label: "Endorse",
                      onTap: () {},
                    ),
                    MiniActionButton(
                      iconPath: 'assets/icons/lacak_polis1.svg',
                      gradient: cyanGradient,
                      label: "Lacak Polis",
                      onTap: () {},
                    ),
                    MiniActionButton(
                      iconPath: 'assets/icons/perpanjangan1.svg',
                      gradient: purpleGradient,
                      label: "Perpanjang",
                      onTap: () {},
                    ),
                    MiniActionButton(
                      iconPath: 'assets/icons/aktifkan1.svg',
                      gradient: redGradient,
                      label: "Aktifkan",
                      onTap: () {},
                    ),
                    MiniActionButton(
                      iconPath: 'assets/icons/unduh_polis1.svg',
                      gradient: greenGradient,
                      label: "Unduh Polis",
                      onTap: () {},
                    ),
                  ],
              ),
            ],
          ),
        ],
=======
            // FloatingMenuMasterWidget(
            //   onTambah: onTambahData,
            // ),
            // const DraggableBeliPolisButton(),
            // const MenuPolisCircular(),
          ],
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
        ),
      ),
    );

  }
}
