import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/regpar/regpar1crud_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/regpar/regpar1crud_model.dart';
import 'package:joss_app/pages/regpar/mobile/regpar/regpar_form1.dart';
import 'package:joss_app/pages/regpar/mobile/regpar/regpar_form2.dart';
import 'package:joss_app/pages/regpar/mobile/regpar/regpar_form3.dart';
import 'package:joss_app/pages/regpar/mobile/regpar/regpar_form4.dart';
import '../../../blocs/regpar/regpar2form_bloc.dart';
import '../../../blocs/regpar/regpar3form_bloc.dart';
import '../../../blocs/regpar/regpar4form_bloc.dart';
import '../../../models/regpar/regpar2form_model.dart';
import '../../../models/regpar/regpar3form_model.dart';
import '../../../models/regpar/regpar4form_model.dart';
import '../../../widgets/apptheme/custom_progress_bar.dart';
import '../../../widgets/apptheme/header_card_polis.dart';
import '../../base/base_background_sidepage.dart';



class KonfirmasiRegParPage extends StatefulWidget {
  final String viewMode;
  final String? recordId;

  const KonfirmasiRegParPage({
    super.key,
    required this.viewMode,
    this.recordId,
  });

  @override
  State<KonfirmasiRegParPage> createState() => _KonfirmasiRegParPageState();
}

class _KonfirmasiRegParPageState extends State<KonfirmasiRegParPage> {
  Regpar1CrudModel? regpar1Record;
  Regpar2FormModel? regpar2Record;
  Regpar3FormModel? regpar3Record;
  Regpar4FormModel? regpar4Record;

  String toCurrency(double value) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
        .format(value);
  }

  @override
  void initState() {
    super.initState();

    // 🔥 Trigger load Form 1 saat halaman dibuka
    if (widget.viewMode == "ubah" && widget.recordId != null) {
      context.read<Regpar1CrudBloc>()
          .add(Regpar1CrudLihatEvent(recordId: widget.recordId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Konfirmasi",
      blocListeners: [
        _buildGenericListener<Regpar1CrudBloc, Regpar1CrudState, Regpar1CrudModel>(
          onPayload: (record) {
            setState(() => regpar1Record = record);

            // 🔥 Setelah Form1 load → load Form2
            context.read<Regpar2FormBloc>()
                .add(Regpar2FormLihatEvent(recordId: record.regpar1Id));
          },
        ),
        _buildGenericListener<Regpar2FormBloc, Regpar2FormState, Regpar2FormModel>(
          onPayload: (record) {
            setState(() => regpar2Record = record);

            // 🔥 Trigger Form3
            context.read<Regpar3FormBloc>()
                .add(Regpar3FormLihatEvent(recordId: regpar1Record!.regpar1Id));
          },
        ),
        _buildGenericListener<Regpar3FormBloc, Regpar3FormState, Regpar3FormModel>(
          onPayload: (record) {
            setState(() => regpar3Record = record);

            // 🔥 Trigger Form4
            context.read<Regpar4FormBloc>()
                .add(Regpar4FormLihatEvent(recordId: regpar1Record!.regpar1Id));
          },
        ),
        _buildGenericListener<Regpar4FormBloc, Regpar4FormState, Regpar4FormModel>(
          onPayload: (record) => setState(() => regpar4Record = record),
        ),
      ],
      child: _buildForm(),
    );
  }

  // 🔹 Generic listener tetap jalan seperti semula
  BlocListener<B, S> _buildGenericListener<B extends StateStreamable<S>, S, M>({
    required void Function(M record) onPayload,
  }) {
    return BlocListener<B, S>(
      listenWhen: (prev, curr) =>
      (prev as dynamic).isLoaded != (curr as dynamic).isLoaded &&
          (curr as dynamic).isLoaded == true,
      listener: (context, state) {
        final record = (state as dynamic).record;
        if (record != null && record is M) {
          onPayload(record);
        }
      },
    );
  }

  Widget _buildForm() {
    return Scaffold(
      backgroundColor: secondaryBlackColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  //
                  // if (regpar1Record != null) _buildRegpar1Card(regpar1Record!),
                  // if (regpar2Record != null) _buildRegpar2Card(regpar2Record!),
                  // if (regpar3Record != null) _buildRegpar3Card(regpar3Record!),
                  // if (regpar4Record != null) _buildRegpar4Card(regpar4Record!),


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Pastikan semua data sudah sesuai sebelum melanjutkan.",
                          style: bodyTextStyle(context).copyWith(color: primaryLightColor),
                        ),
                      ],
                    ),
                  ),

                  _buildRegpar1Card(regpar1Record ?? Regpar1CrudModel(
                    regpar1Id: "-",
                    ttgNama: "-",
                    ttgAlamat: "-",
                  )),
                  _buildRegpar2Card(regpar2Record ?? Regpar2FormModel(
                    regpar2Id: "-",
                    polisMulai: DateTime.now(),
                    polisAkhir: DateTime.now(), regpar1Id: widget.recordId!, objectAlamat: '',
                  )),
                  _buildRegpar3Card(regpar3Record ?? Regpar3FormModel(
                    regpar3Id: "-",
                    isEq: false, regpar1Id: widget.recordId!,
                  )),
                  _buildRegpar4Card(regpar4Record ?? Regpar4FormModel(
                    siBuilding: 0,
                    siContent: 0,
                    siMachinery: 0,
                    siOther: 0,
                    siStock: 0, regpar1Id: widget.recordId!,
                  )),
                  const SizedBox(height: hPadding),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                    child: AppButton.primary(
                      text: "Lanjutkan",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KonfirmasiRegParPage(
                              recordId: widget.recordId ?? '',
                              viewMode: 'ubah',
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegpar1Card(Regpar1CrudModel data) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: hPadding * 1.5, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: sGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Data Tertanggung"),
          kDivider(color: sGrey),
          _buildDetailRow("ID Tertanggung", data.regpar1Id),
          kDivider(color: sGrey),
          _buildDetailRow("Nama", data.ttgNama),
          kDivider(color: sGrey),
          _buildDetailRow("Alamat", data.ttgAlamat),
        ],
      ),
    );
  }



  Widget _buildRegpar2Card(Regpar2FormModel data) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: hPadding * 1.5, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: sGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          _buildSectionHeader("Informasi Polis"),
          kDivider(color: sGrey),

          _buildDetailRow("ID Polis", data.regpar2Id),
          kDivider(color: sGrey),

          _buildDetailRow("Periode Polis",
              "${DateFormat('dd MMM yyyy').format(data.polisMulai)} - "
                  "${DateFormat('dd MMM yyyy').format(data.polisAkhir)}"),
          kDivider(color: sGrey),

          _buildDetailRow("Konstruksi Bangunan",
              data.comboRKonstruksiojk?.kelasNama ?? "-"),
          kDivider(color: sGrey),

          _buildDetailRow("Okupasi",
              data.comboROkupasi?.okupasiDesc ?? "-"),
        ],
      ),
    );
  }



  Widget _buildRegpar3Card(Regpar3FormModel data) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: hPadding * 1.5, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: sGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(" Perhitungan Tarif"),
          kDivider(color: sGrey),

          _buildDetailRow("ID Rate", data.regpar3Id),
          kDivider(color: sGrey),

          _buildDetailRow("Jenis Cover",
              data.comboMJnscoverPar?.jenisNama ?? "-"),
          kDivider(color: sGrey),

          _buildDetailRow("Wilayah Pertanggungan",
              data.comboMWilayah?.wilayahNama ?? "-"),
          kDivider(color: sGrey),

          // _buildDetailRow("Rate EQ (Gempa)", "${data.rateEqvet}%"),
          // kDivider(color: sGrey),
          // _buildDetailRow("Rate PAR", "${data.ratePar}%"),
          // kDivider(color: sGrey),
          // _buildDetailRow("Rate RSMDCC", "${data.rateRsmdcc}%"),
          // kDivider(color: sGrey),
          // _buildDetailRow("Rate TSFWD", "${data.rateTsfwd}%"),
          // kDivider(color: sGrey),
          // _buildDetailRow("Rate Other", "${data.rateOther}%"),
          // kDivider(color: sGrey),
          //
          // _buildDetailRow("Total Rate", "${data.rateTotal}%"),
        ],
      ),
    );
  }



  Widget _buildRegpar4Card(Regpar4FormModel data) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: hPadding * 1.5, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: sGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Nilai Pertanggungan"),
          kDivider(color: sGrey),

          // _buildDetailRow("ID Pertanggungan", data.regpar4Id),
          // kDivider(color: sGrey),
          _buildDetailRow("SI Building", toCurrency(data.siBuilding)),
          kDivider(color: sGrey),

          _buildDetailRow("SI Machinery", toCurrency(data.siMachinery)),
          kDivider(color: sGrey),

          _buildDetailRow("SI Stock", toCurrency(data.siStock)),
          kDivider(color: sGrey),

          _buildDetailRow("SI Content", toCurrency(data.siContent)),
          kDivider(color: sGrey),

          _buildDetailRow("SI Other", toCurrency(data.siOther)),
          kDivider(color: sGrey),

          _buildDetailRow("Mata Uang",
              data.comboRMatauang?.rmatauangNama ?? "-"),
        ],
      ),
    );
  }

  // ======= UI Builders =======
  Widget _buildDetailRow(String label, dynamic value) {
    String displayValue;

    if (value == null || value.toString().trim().isEmpty) {
      displayValue = "-"; // dummy default
    } else {
      displayValue = value.toString();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: hPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: bodyTextStyle(context).copyWith(color: hintGrey)),
          Flexible(
            child: Text(
              displayValue,
              style: bodyTextStyle(context),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowIcon(String label, dynamic value) {
    Widget iconWidget;

    if (value == 1) {
      iconWidget = SvgPicture.asset('assets/icons/dipilih.svg', width: 24, height: 24);
    } else if (value == 0) {
      iconWidget = SvgPicture.asset('assets/icons/tidak_dipilih.svg', width: 24, height: 24);
    } else {
      iconWidget = const Text("-");
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: hPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: bodyTextStyle(context).copyWith(color: hintGrey)),
          iconWidget,
        ],
      ),
    );
  }


  Widget _buildSectionHeader(String title) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: hPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: bodyTextStyle(context).copyWith(color: primaryLightColor)),
       ],
      ),
    );
  }

  Widget siValueWidget(dynamic value) {
    if (value == 1) {
      return SvgPicture.asset(
        'assets/icons/dipilih.svg',
        width: 30,
        height: 30,
        fit: BoxFit.contain,
      );
    } else if (value == 0) {
      return SvgPicture.asset(
        'assets/icons/tidak_dipilih.svg',
        width: 30,
        height: 30,
        fit: BoxFit.contain,
      );
    } else {
      return const Text("-");
    }
  }

}
