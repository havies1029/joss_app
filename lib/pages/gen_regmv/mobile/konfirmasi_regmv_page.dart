import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import '../../../blocs/gen_regmv/regmv1crud_bloc.dart';
import '../../../blocs/gen_regmv/regmv2form_bloc.dart';
import '../../../blocs/gen_regmv/regmv3form_bloc.dart';
import '../../../blocs/gen_regmv/regmv4form_bloc.dart';
import '../../../models/gen_regmv/regmv1crud_model.dart';
import '../../../models/gen_regmv/regmv2form_model.dart';
import '../../../models/gen_regmv/regmv3form_model.dart';
import '../../../models/gen_regmv/regmv4form_model.dart';
import '../../../widgets/apptheme/custom_progress_bar.dart';
import '../../../widgets/apptheme/header_card_polis.dart';
import '../../base/base_background_sidepage.dart';

class KonfirmasiRegMvPage extends StatefulWidget {
  final String viewMode;
  final String? recordId;

  const KonfirmasiRegMvPage({
    super.key,
    required this.viewMode,
    this.recordId,
  });

  @override
  State<KonfirmasiRegMvPage> createState() => _KonfirmasiRegMvPageState();
}

class _KonfirmasiRegMvPageState extends State<KonfirmasiRegMvPage> {
  Regmv1CrudModel? regmv1Record;
  Regmv2FormModel? regmv2Record;
  Regmv3FormModel? regmv3Record;

  String toCurrency(double value) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
        .format(value);
  }

  @override
  void initState() {
    super.initState();

    // 🔥 Trigger load Form 1 saat halaman dibuka
    if (widget.viewMode == "ubah" && widget.recordId != null) {
      context.read<Regmv1CrudBloc>()
          .add(Regmv1CrudLihatEvent(recordId: widget.recordId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Konfirmasi",
      blocListeners: [
        _buildGenericListener<Regmv1CrudBloc, Regmv1CrudState, Regmv1CrudModel>(
          onPayload: (record) {
            setState(() => regmv1Record = record);

            // 🔥 Setelah Form1 load → load Form2
            context.read<Regmv2FormBloc>()
                .add(Regmv2FormLihatEvent(recordId: record.regmv1Id));
          },
        ),
        _buildGenericListener<Regmv2FormBloc, Regmv2FormState, Regmv2FormModel>(
          onPayload: (record) {
            setState(() => regmv2Record = record);

            // 🔥 Trigger Form3
            context.read<Regmv3FormBloc>()
                .add(Regmv3FormLihatEvent(recordId: regmv1Record!.regmv1Id));
          },
        ),
        _buildGenericListener<Regmv3FormBloc, Regmv3FormState, Regmv3FormModel>(
          onPayload: (record) {
            setState(() => regmv3Record = record);
            //
            // // 🔥 Trigger Form4
            // context.read<Regmv4FormBloc>()
            //     .add(Regmv4FormLihatEvent(recordId: regmv1Record!.regmv1Id));
          },
        ),
        // _buildGenericListener<Regmv4FormBloc, Regmv4FormState, Regmv4FormModel>(
        //   onPayload: (record) => setState(() => regmv4Record = record),
        // ),
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
                  // if (regmv1Record != null) _buildRegmv1Card(regmv1Record!),
                  // if (regmv2Record != null) _buildRegmv2Card(regmv2Record!),
                  // if (regmv3Record != null) _buildRegmv3Card(regmv3Record!),
                  // if (regmv4Record != null) _buildRegmv4Card(regmv4Record!),


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

                  _buildRegmv1Card(
                    regmv1Record ?? Regmv1CrudModel(
                      calmv1Id: "-",
                      regmv1Id: "-",
                      ttgNama: "-",
                      ttgAlamat: "-",
                    ),
                  ),

                  _buildRegmv2Card(
                    regmv2Record ?? Regmv2FormModel(
                      regmv2Id: "-",
                      regmv1Id: "-",
                      polisMulai: DateTime.now(),
                      polisAkhir: DateTime.now(),
                      aw: 0,
                      pad: 0,
                      pap: 0,
                      tpl: 0,
                      pll: 0,
                      passangerCount: 0,
                      isEq: false,
                      isFlood: false,
                      isSrcc: false,
                      isTbod: false,
                      isTerrorism: false,
                      currId: null,
                      comboRMatauang: null,
                      mmvjnscoverId: null,
                      comboMMvjnscover: null,
                    ),
                  ),

                  _buildRegmv3Card(
                    regmv3Record ?? Regmv3FormModel(
                      regmv3Id: "-",
                      regmv1Id: "-",
                      platNo: "-",
                      mesinNo: "-",
                      rangkaNo: "-",
                      thnBuat: 0,
                      harga: 0,
                      aksesoris: "-",
                      mmvmerkId: null,
                      comboMMvmerk: null,
                      mmvmodelId: null,
                      comboMMvmodel: null,
                      mmvpakaiId: null,
                      comboMMvpakai: null,
                      mmvtipeId: null,
                      comboMMvtipe: null,
                      mwarnaId: null,
                      comboMWarna: null,
                      mwilayahId: null,
                      comboMWilayah: null,
                    ),
                  ),

                  const SizedBox(height: hPadding),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                    child: AppButton.primary(
                      text: "Lanjutkan",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KonfirmasiRegMvPage(
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

  Widget _buildRegmv1Card(Regmv1CrudModel data) {
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
          _buildDetailRow("ID Tertanggung", data.regmv1Id),
          kDivider(color: sGrey),
          _buildDetailRow("Nama", data.ttgNama),
          kDivider(color: sGrey),
          _buildDetailRow("Alamat", data.ttgAlamat),
        ],
      ),
    );
  }


  Widget _buildRegmv2Card(Regmv2FormModel data) {
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
          _buildSectionHeader("Informasi Polis"),
          kDivider(color: sGrey),

          _buildDetailRow("ID Polis", data.regmv2Id),
          kDivider(color: sGrey),

          _buildDetailRow(
            "Periode Polis",
            "${DateFormat('dd MMM yyyy').format(data.polisMulai)} - "
                "${DateFormat('dd MMM yyyy').format(data.polisAkhir)}",
          ),
          kDivider(color: sGrey),

          _buildDetailRow(
            "Jenis Cover",
            data.comboMMvjnscover?.coverName ?? "-",
          ),
          kDivider(color: sGrey),

          _buildDetailRow(
            "Mata Uang",
            data.comboRMatauang?.rmatauangNama ?? "-",
          ),
          kDivider(color: sGrey),

          _buildSectionHeader("Perluasan Pertanggungan"),
          kDivider(color: sGrey),

          _buildDetailRowIcon("Gempa Bumi (EQ)", data.isEq),
          kDivider(color: sGrey),
          _buildDetailRowIcon("Banjir (Flood)", data.isFlood),
          kDivider(color: sGrey),
          _buildDetailRowIcon("SRCC", data.isSrcc),
          kDivider(color: sGrey),
          _buildDetailRowIcon("Terrorism", data.isTerrorism),
          kDivider(color: sGrey),
          _buildDetailRowIcon("TBOD", data.isTbod),
          kDivider(color: sGrey),
        ],
      ),
    );
  }

  Widget _buildRegmv3Card(Regmv3FormModel data) {
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
          // Header
          _buildSectionHeader("Informasi Kendaraan"),
          kDivider(color: sGrey),

          _buildDetailRow("ID Kendaraan", data.regmv3Id),
          kDivider(color: sGrey),

          _buildDetailRow("Nomor Polisi", data.platNo),
          kDivider(color: sGrey),

          _buildDetailRow("Nomor Mesin", data.mesinNo),
          kDivider(color: sGrey),

          _buildDetailRow("Nomor Rangka", data.rangkaNo),
          kDivider(color: sGrey),

          _buildDetailRow("Tahun Pembuatan", data.thnBuat.toString()),
          kDivider(color: sGrey),

          _buildDetailRow(
            "Merk Kendaraan",
            data.comboMMvmerk?.nmMerk ?? "-",
          ),
          kDivider(color: sGrey),

          _buildDetailRow(
            "Model Kendaraan",
            data.comboMMvmodel?.nmModel ?? "-",
          ),
          kDivider(color: sGrey),

          _buildDetailRow(
            "Tipe Kendaraan",
            data.comboMMvtipe?.nmTipe ?? "-",
          ),
          kDivider(color: sGrey),

          _buildDetailRow(
            "Penggunaan Kendaraan",
            data.comboMMvpakai?.pakaiNama ?? "-",
          ),
          kDivider(color: sGrey),

          _buildDetailRow(
            "Warna Kendaraan",
            data.comboMWarna?.warnaDesc ?? "-",
          ),
          kDivider(color: sGrey),

          _buildDetailRow(
            "Wilayah Pertanggungan",
            data.comboMWilayah?.wilayahNama ?? "-",
          ),
          kDivider(color: sGrey),

          _buildDetailRow("Harga Kendaraan", toCurrency(data.harga)),
          kDivider(color: sGrey),

          _buildDetailRow(
            "Aksesoris Tambahan",
            data.aksesoris.trim().isEmpty ? "-" : data.aksesoris,
          ),
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
    if (value == true) {
      return SvgPicture.asset(
        'assets/icons/dipilih.svg',
        width: 30,
        height: 30,
        fit: BoxFit.contain,
      );
    } else if (value == false) {
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
