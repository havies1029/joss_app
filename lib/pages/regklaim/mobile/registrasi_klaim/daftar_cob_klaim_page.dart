import 'package:flutter/material.dart';

import '../../../../blocs/authentication/authentication_bloc.dart';
import '../../../../blocs/reguser/reguser_bloc.dart';
import '../../../../common/app_data.dart';
import '../../../../common/constants.dart';
import '../../../../widgets/apptheme/header_card.dart';
import '../../../base/base_background_firstpage.dart';
import '../../../base/base_background_sidepage.dart';
import 'button_klaim/button_cob_klaim.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
enum DaftarCobKlaimType { page, menu }

class DaftarCobKlaimWidget extends StatefulWidget {
  final DaftarCobKlaimType type;

  const DaftarCobKlaimWidget({
    super.key,
    this.type = DaftarCobKlaimType.page,
  });

  const DaftarCobKlaimWidget.page({super.key})
      : type = DaftarCobKlaimType.page;

  const DaftarCobKlaimWidget.menu({super.key})
      : type = DaftarCobKlaimType.menu;

  @override
  State<DaftarCobKlaimWidget> createState() => _DaftarCobKlaimWidgetState();
}

class _DaftarCobKlaimWidgetState extends State<DaftarCobKlaimWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late RegUserBloc regUserBloc;
  late AuthenticationBloc authenticationBloc;

  @override
  void initState(){
    super.initState();
    regUserBloc = context.read<RegUserBloc>();
    authenticationBloc = context.read<AuthenticationBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return widget.type == DaftarCobKlaimType.page
        ? _buildAsPage(context)
        : _buildAsMenu(context);
  }

  Widget _buildAsPage(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (regUserBloc.state.requestFrom.isNotEmpty){
          authenticationBloc.add(
            LoggedIn(user: AppData.user),
          );
          regUserBloc.add(ClearRequestFromEvent());
        }
        Navigator.pop(context);
      },
      child: BaseBackgroundSidePage(
        title: 'Lapor Klaim',
        onBack: () async {
          if (regUserBloc.state.requestFrom.isNotEmpty){
            authenticationBloc.add(
              LoggedIn(user: AppData.user),
            );
            regUserBloc.add(ClearRequestFromEvent());
            Navigator.pop(context);
          }
          Navigator.pop(context);
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: hPadding),
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildAsMenu(BuildContext context) {
    return Scaffold(
      body: BaseBackgroundFirstPage(
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: secondaryBlackColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: hPadding),
                  _buildContent(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: hPadding),
            Container(
              color: secondaryBlackColor,
              child: _buildJenisKlaimSection(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return HeaderCard(
      iconPath: "assets/icons/menu_lapor_klaim.svg",
      title: "Lapor Klaim",
      subtitle:
      "Lapor klaim Anda sesuai dengan kategori asuransi yang tersedia.",
    );
  }

  Widget _buildJenisKlaimSection(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: hPadding),
          decoration: const BoxDecoration(
            color: secondaryBlackColor,
          ),
          child: Column(
            children: [
              const SizedBox(height: hPadding),
              Text(
                "Pilih Jenis Klaim yang ingin kamu ajukan",
                style: bodyTextStyle(context),
                textAlign: widget.type == DaftarCobKlaimType.page
                    ? TextAlign.center
                    : TextAlign.left,
              ),
              const SizedBox(height: vPadding),
              kDivider(),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: hPadding,
            horizontal: hPadding * 1.5,
          ),
          decoration: const BoxDecoration(
            color: secondaryBlackColor,
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonCobKlaimWidget(),
            ],
          ),
        ),
      ],
    );
  }
}

class DaftarCobKlaimPage extends DaftarCobKlaimWidget {
  const DaftarCobKlaimPage({super.key}) : super(type: DaftarCobKlaimType.page);
}

class DaftarCobKlaimMenu extends DaftarCobKlaimWidget {
  const DaftarCobKlaimMenu({super.key}) : super(type: DaftarCobKlaimType.menu);
}