import 'package:flutter/material.dart';
import 'package:joss_app/pages/regklaim/mobile/main_page/klaim_main_page.dart';
import 'package:joss_app/pages/regklaim/mobile/registrasi_klaim/registrasi_form/polis_detail/sppa_detail_page.dart';

import '../../../../../../blocs/authentication/authentication_bloc.dart';
import '../../../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../../../../blocs/gen_profile/mrekangeneralcmpcrud_bloc.dart';
import '../../../../../../blocs/gen_profile/mrekangeneralidvcrud_bloc.dart';
import '../../../../../../blocs/regklaim/regklaim1crud_bloc.dart';
import '../../../../../../blocs/regklaim/sppaheader_bloc.dart';
import '../../../../../../common/constants.dart';
import '../../../../../../models/regklaim/sppadetail_model.dart';
import '../../../../../../models/regklaim/sppaheader_model.dart';
import '../../../../../../models/user/user_model.dart';
import '../../../../../../widgets/apptheme/header_card_polis.dart';
import '../../../../../../widgets/apptheme/register_client_pop_up.dart';
import '../../../../../base/base_background_sidepage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../profile/mobile/profile/form_section/popup/rekan_general_cmp.dart';
import '../../../../../profile/mobile/profile/form_section/popup/rekan_general_idv.dart';
import '../../../../../register/mobile/client/register_client_page.dart';
import '../../../../../tagihan_pembayaran/mobile/payment_page/payment_success/payment_success.dart';

class UserPolisDetail extends StatefulWidget {
  final String cobKlaimId;
  final String cobKlaimNama;
  final String sppa1Id;

  const UserPolisDetail({
    super.key,
    required this.cobKlaimId,
    required this.cobKlaimNama,
    required this.sppa1Id,
  });

  @override
  State<UserPolisDetail> createState() => _UserPolisDetailState();
}

class _UserPolisDetailState extends State<UserPolisDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String get _iconPath {
    final name = widget.cobKlaimNama.trim().toLowerCase();
    return "assets/icons/$name.svg";
  }

  String get _headerTitle => "Klaim ${widget.cobKlaimNama}";

  final fieldCobNamaController = TextEditingController();
  final fieldInsuredNamaController = TextEditingController();
  final fieldObjectAlamat1Controller = TextEditingController();
  final fieldObjectAlamat2Controller = TextEditingController();
  List<SppaDetailModel?> listSppaDetail = [];
  late SppaHeaderBloc sppaHeaderBloc;
  late Regklaim1CrudBloc regklaim1crudbloc;

  @override
  void initState() {
    super.initState();
    regklaim1crudbloc = context.read<Regklaim1CrudBloc>();
    sppaHeaderBloc = context.read<SppaHeaderBloc>();
    Future.delayed(const Duration(milliseconds: 500), () {
      context.read<SppaHeaderBloc>()
          .add(SppaHeaderLihatEvent(recordId: widget.sppa1Id));
    });
  }

  @override
  void dispose(){
    fieldCobNamaController.dispose();
    fieldInsuredNamaController.dispose();
    fieldObjectAlamat1Controller.dispose();
    fieldObjectAlamat2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
      BlocListener<Regklaim1CrudBloc, Regklaim1CrudState>(
        listener: (context, state) {
          if (state.isSaved) {
            if (!state.hasFailure) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentSuccess(
                    display: "Klaim Kamu Berhasil Didaftarkan!",
                    description:
                    "Departemen kami akan segera menghubungi kamu. untuk menindaklanjuti klaim ini.",
                    displayButton: "Kembali",
                    onButtonPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const KlaimMainPage(),
                        ),
                            (route) => route.isFirst,
                      );
                    },
                  ),
                ),
              );
              // _dismissDialog();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gagal melaporkan klaim')),
              );
            }
          }
        }
      ),
        BlocListener<SppaHeaderBloc, SppaHeaderState>(
          listener: (context, state) {
            if (!mounted) return;
            if (state.record != null) {
              setState(() {
                _payloadform(state.record!);
              });
            }
          },
        ),
      ],
      child: SafeArea(
        child: BaseBackgroundSidePage(
          title: widget.cobKlaimNama,
          child: Scaffold(
            backgroundColor: secondaryBlackColor,
            body: Form(
              child: Column(
                children: [
                  // =====================
                  // CONTENT (SCROLLABLE)
                  // =====================
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: vPadding),
                      child: Padding(
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
                              "Periksa detail polis sebelum melanjutkan proses klaim.",
                            ),
                            const SizedBox(height: vPadding),
                            _buildPolisVerifiedInfo(),
                            const SizedBox(height: vPadding),
                            _buildSppaDetailTableSection(),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // =====================
                  // BOTTOM BUTTON (FIXED)
                  // =====================
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      hPadding * 1.5,
                      12,
                      hPadding * 1.5,
                      vPadding,
                    ),
                    child: AppButton(
                      text: "Lapor Klaim",
                      onPressed: () {
                        final mjenisClient =
                            context.read<MRekan1CrudBloc>().state.record?.mjnsclientId;
                        if (context.read<AuthenticationBloc>().state is AuthenticationAuthenticated) {
                          User user = (context.read<AuthenticationBloc>().state as AuthenticationAuthenticated).user;
                          if (user.userType == "C"){
                            if (mjenisClient == "10") {
                              final mRekanNama1 =
                                  context.read<MRekanGeneralIdvCrudBloc>().state.record?.rekanNama ?? "";
                              debugPrint("MREKANNAMA! = ${mRekanNama1}");
                              if (mRekanNama1.isEmpty) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true, // klik luar = close
                                  barrierColor: Colors.black.withOpacity(0.6), // background gelap transparan
                                  builder: (context) => RegisterClientPopUp(
                                    header: 'Isi Data Pribadi Anda1',
                                    description:
                                    'Lengkapi data pribadi Anda terlebih dahulu untuk melanjutkan proses ini.',
                                    buttonText: 'Lengkapi Data Pribadi',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MRekanGeneralIdvPopUpPage(popTwice: false,),
                                        ),
                                      );
                                    },
                                  ),
                                );
                                return;
                              }
                            }
                            else if (mjenisClient == "20") {
                              final mRekanNama2 =
                                  context.read<MRekanGeneralCmpCrudBloc>().state.record?.rekanNama ?? "";

                              if (mRekanNama2.isEmpty) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true, // klik luar = close
                                  barrierColor: Colors.black.withOpacity(0.6), // background gelap transparan
                                  builder: (context) => RegisterClientPopUp(
                                    header: 'Isi Data Pribadi Anda2',
                                    description:
                                    'Lengkapi data pribadi Anda terlebih dahulu untuk melanjutkan proses ini.',
                                    buttonText: 'Lengkapi Data Pribadi',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MRekanGeneralCmpPopUpPage(popTwice: false,),
                                        ),
                                      );
                                    },
                                  ),
                                );
                                return;
                              }
                            }
                            regklaim1crudbloc.add(
                                Regklaim1Tambah4PolisJpsEvent(
                                    sppa1Id: widget.sppa1Id));
                          }else {
                            showDialog(
                              context: context,
                              barrierDismissible: true, // klik luar = close
                              barrierColor: Colors.black.withOpacity(0.6), // background gelap transparan
                              builder: (context) => RegisterClientPopUp(
                                header: 'Data Klien Belum Terdaftar!',
                                description:
                                'Untuk melanjutkan ke proses Klaim Baru, Anda perlu mendaftarkan data klien terlebih dahulu.',
                                buttonText: 'Daftar Klien',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterClient(requestFrom: 'regispolis_page')
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        }
                      },
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

  void _payloadform(SppaHeaderModel record) {
    if (fieldCobNamaController.text.trim().isEmpty) {
      fieldCobNamaController.text = record.cobNama.toString();
    }

    if (fieldInsuredNamaController.text.trim().isEmpty) {
      fieldInsuredNamaController.text = record.insuredNama.toString();
    }

    if (fieldObjectAlamat1Controller.text.trim().isEmpty) {
      fieldObjectAlamat1Controller.text = record.objectAlamat1.toString();
    }

    if (fieldObjectAlamat2Controller.text.trim().isEmpty) {
      fieldObjectAlamat2Controller.text = record.objectAlamat2.toString();
    }

    setState(() {
      listSppaDetail = record.sppaDetail;
    });
  }

  Widget _buildPolisVerifiedInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(
          color: sGrey,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Data Polis Ditemukan",
                style: TextStyle(
                  color: primaryLightColor,
                  fontSize: getResponsiveFont(context, 16),
                  // fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              SvgPicture.asset(
                "assets/icons/centang2.svg",
                width: 18,
                height: 18,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Data polis berhasil di verifikasi",
            style: TextStyle(
              color: hintGrey,
              fontSize: getResponsiveFont(context, 14),
            ),
          ),
          const SizedBox(height: 2),
          const Divider(
            thickness: 1,
            color: sGrey,
          ),
          const SizedBox(height: 2),
          _buildPolisDetailSection(),
          //this is a place for another widget
        ],
      ),
    );
  }

  Widget _buildPolisDetailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDetailRow(
          label: "Nama Tertanggung:",
          value: fieldInsuredNamaController.text,
        ),
        const SizedBox(height: vPadding),

        _buildDetailRow(
          label: "Alamat Resiko:",
          value: "${fieldObjectAlamat1Controller.text},\n${fieldObjectAlamat2Controller.text}",
          valueMultiline: true,
        ),
        // const SizedBox(height: vPadding),

        _buildDetailRow(
          label: "Jenis Asuransi:",
          value: fieldCobNamaController.text,
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    bool valueMultiline = false,
  }) {
    return Row(
      crossAxisAlignment:
      valueMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: hintGrey,
            fontSize: getResponsiveFont(context, 16),
          ),
        ),
        SizedBox(width: hPadding),

        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: primaryLightColor,
              fontSize: getResponsiveFont(context, 16),
            ),
            maxLines: valueMultiline ? 3 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSppaDetailTableSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SppaDetailTableWidget(items: listSppaDetail),
      ],
    );
  }
}
