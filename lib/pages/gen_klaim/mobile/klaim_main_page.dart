import 'package:flutter/material.dart';
import 'package:joss_app/pages/gen_klaim/mobile/widget/crud_klaim_widget/klaim1_inline_editor_page.dart';
import '../../../../common/constants.dart';
import '../../base/base_background_firstpage.dart';
import '../../base/base_background_sidepage.dart';

enum KlaimPageType { page, menu }

class KlaimMainPage extends StatefulWidget {
  final KlaimPageType type;

  const KlaimMainPage({super.key, this.type = KlaimPageType.page});

  const KlaimMainPage.page({super.key})
      : type = KlaimPageType.page;

  const KlaimMainPage.menu({super.key})
      : type = KlaimPageType.menu;
  @override
  _KlaimMainPageState createState() => _KlaimMainPageState();
}

class _KlaimMainPageState extends State<KlaimMainPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

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
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.type == KlaimPageType.page
        ? _buildAsPage(context)
        : _buildAsMenu(context);
  }

  Widget _buildAsPage(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Lapor Klaim",
      child: _buildContent(context)
    );
  }

  Widget _buildAsMenu(BuildContext context) {
    return Scaffold(
      body: BaseBackgroundFirstPage(
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: secondaryBlackColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: hPadding),
                // HeaderCard(
                //   iconPath: "assets/icons/menu_lapor_klaim.svg",
                //   title: "Klaim",
                //   subtitle:
                //   "Ajukan klaim sesuai ketentuan polis Anda dengan mengisi formulir berikut secara lengkap.",
                // ),
                Expanded(
                  child: _buildContent(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return const Klaim1InlineEditorPage();
  }
}

class KlaimPage extends KlaimMainPage {
  const KlaimPage({super.key}) : super(type: KlaimPageType.page);
}

class KlaimMenu extends KlaimMainPage {
  const KlaimMenu({super.key}) : super(type: KlaimPageType.menu);
}