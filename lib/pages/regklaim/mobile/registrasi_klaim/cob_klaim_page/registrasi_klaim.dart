import 'package:flutter/material.dart';

import '../../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../../../blocs/gen_profile/mrekangeneralcmpcrud_bloc.dart';
import '../../../../../blocs/gen_profile/mrekangeneralidvcrud_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../../widgets/apptheme/header_card_polis.dart';
import '../../../../base/base_background_sidepage.dart';
import '../base_polis_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class RegistrasiKlaim extends StatefulWidget {
  final String cobKlaimId;
  final String cobKlaimNama;

  const RegistrasiKlaim({
    super.key,
    required this.cobKlaimId,
    required this.cobKlaimNama,
  });

  @override
  State<RegistrasiKlaim> createState() => _RegistrasiKlaimState();
}

class _RegistrasiKlaimState extends State<RegistrasiKlaim> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String get _iconPath {
    final name = widget.cobKlaimNama.trim().toLowerCase();
    return "assets/icons/$name.svg";
  }

  String get _headerTitle => "Klaim ${widget.cobKlaimNama}";

  late MRekanGeneralCmpCrudBloc mRekanGeneralCmpCrudBloc;
  late MRekanGeneralIdvCrudBloc mRekanGeneralIdvCrudBloc;

  @override
  void initState() {
    super.initState();
    mRekanGeneralIdvCrudBloc = context.read<MRekanGeneralIdvCrudBloc>();
    mRekanGeneralCmpCrudBloc = context.read<MRekanGeneralCmpCrudBloc>();

    final mjenisClient =
        context.read<MRekan1CrudBloc>().state.record?.mjnsclientId;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mjenisClient == "10") {
        mRekanGeneralIdvCrudBloc.add(MRekanGeneralIdvCrudLihatEvent());
      }else if (mjenisClient == "20"){
        mRekanGeneralCmpCrudBloc.add(MRekanGeneralCmpCrudLihatEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseBackgroundSidePage(
        title: widget.cobKlaimNama,
        child: Scaffold(
          backgroundColor: secondaryBlackColor,
          body: Form(
            // key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: vPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: hPadding * 1.5,
                      vertical: vPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FormSectionHeader(
                          iconPath: _iconPath,
                          title: _headerTitle,
                          subtitle:
                          "Sebelum lanjut, pastikan data kamu sudah lengkap, ya!",
                        ),
                        const SizedBox(height: vPadding),

                        // same for all COB types
                        BasePolisPage(
                          cobKlaimId: widget.cobKlaimId,
                          cobKlaimNama: widget.cobKlaimNama,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
