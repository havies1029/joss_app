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
import '../../payment/mobile/payment_page/paymentFormPage.dart';

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

  String toPercent1(double value) {
    return '${value.toStringAsFixed(1)}%';
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

            // Form1 → Form2
            context.read<Regmv2FormBloc>().add(
              Regmv2FormLihatEvent(recordId: record.regmv1Id),
            );
          },
        ),

        _buildGenericListener<Regmv2FormBloc, Regmv2FormState, Regmv2FormModel>(
          onPayload: (record) {
            setState(() => regmv2Record = record);

            // Form2 → Form3 (PAKAI record.regmv1Id)
            context.read<Regmv3FormBloc>().add(
              Regmv3FormLihatEvent(recordId: record.regmv1Id),
            );
          },
        ),

        _buildGenericListener<Regmv3FormBloc, Regmv3FormState, Regmv3FormModel>(
          onPayload: (record) {
            setState(() => regmv3Record = record);

            // kalau mau lanjut Form4 nanti:
            // context.read<Regmv4FormBloc>().add(
            //   Regmv4FormLihatEvent(recordId: record.regmv1Id),
            // );
          },
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
                            builder: (context) => PaymentMethodsCariListPage(
                              // recordId: widget.recordId ?? '',
                              // viewMode: 'ubah',
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
          _buildDetailRow("NO SPPA:", data.regmv1Id),
          _buildDetailRow("Nama Tertanggung:", data.ttgNama),
          _buildDetailRow("Alamat:", data.ttgAlamat),
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
          _buildSectionHeader("Data Polis"),
          kDivider(color: sGrey),

          // _buildDetailRow("ID Polis", data.regmv2Id),
          // kDivider(color: sGrey),

          _buildDetailRow(
            "Tanggal Mulai:",
            DateFormat('dd MMM yyyy').format(data.polisMulai),
          ),
          _buildDetailRow(
            "Tanggal Berakhir:",
            DateFormat('dd MMM yyyy').format(data.polisAkhir),
          ),

          // _buildDetailRow(
          //   "Periode Polis",
          //   "${DateFormat('dd MMM yyyy').format(data.polisMulai)} - "
          //       "${DateFormat('dd MMM yyyy').format(data.polisAkhir)}",
          // ),

          _buildDetailRow(
            "Mata Uang:",
            data.comboRMatauang?.rmatauangNama ?? "-",
          ),

          _buildDetailRow(
            "Jenis Cover:",
            data.comboMMvjnscover?.coverName ?? "-",
          ),
          _buildDetailRowIcon("Gempa Bumi:", data.isEq),
          _buildDetailRowIcon("Banjir:", data.isFlood),
          _buildDetailRowIcon("Kerusuhan:", data.isSrcc),
          _buildDetailRowIcon("Terrorism:", data.isTerrorism),
          _buildDetailRowIcon("Kerusakan Barang Pihak ketiga:", data.isTbod),
          _buildDetailRow("Tanggung Jawab Penumpang:", toCurrency(data.pll)),
          _buildDetailRow("Tanggung Jawab Pihak Ketiga:", toCurrency(data.tpl)),
          _buildDetailRow("Kecelakaan Diri Pengemudi:", toCurrency(data.pad)),
          _buildDetailRow("Kecelakaan Diri Penumpang:", toCurrency(data.pap)),
          _buildDetailRow("Jumlah Penumpang:", data.passangerCount),
          _buildDetailRow("Bengkel Resmi:", toPercent1(data.aw)),
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
          _buildSectionHeader("Data Kendaraan"),
          kDivider(color: sGrey),

          _buildDetailRow("Harga Kendaraan:", toCurrency(data.harga)),

          _buildDetailRow("Tahun Pembuatan:", data.thnBuat.toString()),

          _buildDetailRow(
            "Wilayah Pertanggungan:",
            data.comboMWilayah?.wilayahNama ?? "-",
          ),

          _buildDetailRow("No Polisi:", data.platNo),

          _buildDetailRow("No Mesin:", data.mesinNo),

          _buildDetailRow("No Rangka:", data.rangkaNo),

          _buildDetailRow(
            "Merk:",
            data.comboMMvmerk?.nmMerk ?? "-",
          ),

          _buildDetailRow(
            "Model:",
            data.comboMMvtipe?.nmTipe ?? "-",
          ),

          _buildDetailRow(
            "Sub Model:",
            data.comboMMvmodel?.nmModel ?? "-",
          ),

          _buildDetailRow(
            "Warna:",
            data.comboMWarna?.warnaDesc ?? "-",
          ),

          _buildDetailRow(
            "Penggunaan:",
            data.comboMMvpakai?.pakaiNama ?? "-",
          ),

          _buildDetailRow(
            "Aksesoris:",
            data.aksesoris.trim().isEmpty ? "-" : data.aksesoris,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    String displayValue;

    if (value == null || value.toString().trim().isEmpty) {
      displayValue = "-";
    } else {
      displayValue = value.toString();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: hPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label kiri
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: bodyTextStyle(context).copyWith(color: hintGrey),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            flex: 6,
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                displayValue,
                style: bodyTextStyle(context),
                textAlign: TextAlign.right,
                softWrap: true,
                maxLines: null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowIcon(String label, dynamic value) {
    Widget iconWidget;

    if (value == 1 || value == true) {
      iconWidget = SvgPicture.asset('assets/icons/dipilih.svg', width: 24, height: 24);
    } else if (value == 0 || value == false) {
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
    if (value == true || value == 1) {
      return SvgPicture.asset(
        'assets/icons/dipilih.svg',
        width: 30,
        height: 30,
        fit: BoxFit.contain,
      );
    } else if (value == false || value == 0) {
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
