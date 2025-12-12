import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common/constants.dart';
import '../../widgets/apptheme/header_card.dart';
import '../base/base_background_sidepage.dart';

class TagihanPembayaranPage extends StatefulWidget {
  const TagihanPembayaranPage({super.key});

  @override
  _TagihanPembayaranPageState createState() => _TagihanPembayaranPageState();
}

class _TagihanPembayaranPageState extends State<TagihanPembayaranPage>
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
              title: 'Tagihan Pembayaran',
              child: Form(
                key: _formKey,
                child: Column(
                  children: const [
                    HeaderCard(
                      iconPath: "assets/icons/menu_tagihan_pembayaran.svg",
                      title: "Tagihan Pembayaran",
                      subtitle:
                      "Pilih kategori asuransi untuk keamanan Anda dan keluarga, Yuk!",
                    ),
                    // BaseAssetWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
