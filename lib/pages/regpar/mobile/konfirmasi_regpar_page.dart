import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/regpar/regpar1crud_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/regpar/regpar1crud_model.dart';
import '../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../blocs/regpar/regpar1list_bloc.dart';
import '../../../blocs/regpar/regpar2form_bloc.dart';
import '../../../blocs/regpar/regpar3form_bloc.dart';
import '../../../blocs/regpar/regpar4form_bloc.dart';
import '../../../models/regpar/regpar2form_model.dart';
import '../../../models/regpar/regpar3form_model.dart';
import '../../../models/regpar/regpar4form_model.dart';
import '../../base/base_background_sidepage.dart';
import '../../payment/mobile/payment_page/payment_method/payment_method_page.dart';
import '../../payment/mobile/payment_page/payment_process/payment_process.dart';
import '../../payment/mobile/payment_page/payment_success/payment_success.dart';



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
  late Regpar1ListBloc regpar1listBloc;
  final TextEditingController _searchController = TextEditingController();

  String toCurrency(double value) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
        .format(value);
  }

  @override
  void initState() {
    super.initState();
    regpar1listBloc = context.read<Regpar1ListBloc>();
    if (widget.viewMode == "ubah" && widget.recordId != null) {
      context.read<Regpar1CrudBloc>()
          .add(Regpar1CrudLihatEvent(recordId: widget.recordId!));
    }
  }

  void refreshData() {
    regpar1listBloc.add(
        RefreshRegpar1ListEvent(searchText: _searchController.text, hal: 0));
  }

  void onViewPaymentMethods(String curr, double totalBayar) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentMethodPage(curr: curr, totalBayar: totalBayar)),
    ); // Implement your ta
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Konfirmasi",
      blocListeners: [
        BlocListener<DnRekap2invBloc, DnRekap2invState>(
          listenWhen: (previous, current) {
            return previous.isProcessed != current.isProcessed ||
                previous.hasFailure != current.hasFailure;
          },
          listener: (context, state) {
            if (state.isProcessed) {
              if (state.paymentStatus == "20") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Proses pembayaran berhasil. Silakan lanjutkan ke metode pembayaran.',
                    ),
                  ),
                );
                onViewPaymentMethods(state.curr, state.totalBayar);
              } else if (state.paymentStatus == "30") {
                refreshData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Silakan lakukan pembayaran.')),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentProcess(
                      viewMode: "ubah",
                      recordId: state.invoiceId,
                    ),
                  ),
                );
              } else if (state.paymentStatus == "40") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Proses pembayaran Berhasil.')),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentSuccess(display: "Pembayaran berhasil!",displayButton: "Kembali", description: "Selamat! Perlindungan kendaraan Anda resmi dimulai.",)),
                );
              } else if (state.paymentStatus == "91") {
                refreshData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Proses pembayaran gagal. Silakan coba lagi.'),
                  ),
                );
              }
            }

            // optional: kalau kamu punya flag hasFailure dan mau tampilkan error umumnya
            // if (state.hasFailure) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(content: Text(state.failureMessage ?? 'Terjadi kesalahan')),
            //   );
            // }
          },
        ),

        _buildGenericListener<Regpar1CrudBloc, Regpar1CrudState, Regpar1CrudModel>(
          onPayload: (record) {
            setState(() => regpar1Record = record);

            context.read<Regpar2FormBloc>().add(
              Regpar2FormLihatEvent(recordId: record.regpar1Id),
            );
          },
        ),

        _buildGenericListener<Regpar2FormBloc, Regpar2FormState, Regpar2FormModel>(
          onPayload: (record) {
            setState(() => regpar2Record = record);

            context.read<Regpar3FormBloc>().add(
              Regpar3FormLihatEvent(recordId: record.regpar1Id),
            );
          },
        ),

        _buildGenericListener<Regpar3FormBloc, Regpar3FormState, Regpar3FormModel>(
          onPayload: (record) {
            setState(() => regpar3Record = record);

            // Form3 → Form4 (PAKAI record)
            context.read<Regpar4FormBloc>().add(
              Regpar4FormLihatEvent(recordId: record.regpar1Id),
            );
          },
        ),

        _buildGenericListener<Regpar4FormBloc, Regpar4FormState, Regpar4FormModel>(
          onPayload: (record) {
            setState(() => regpar4Record = record);
          },
        ),
      ],
      child: _buildForm(),
    );
  }

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

                  _buildRegpar4Card(regpar4Record ?? Regpar4FormModel(
                    siBuilding: 0,
                    siContent: 0,
                    siMachinery: 0,
                    siOther: 0,
                    siStock: 0, regpar1Id: widget.recordId!,
                  )),

                  _buildRegpar3Card(regpar3Record ?? Regpar3FormModel(
                    regpar3Id: "-",
                    isEq: false, regpar1Id: widget.recordId!,
                  )),
                  const SizedBox(height: hPadding),


                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                    child: AppButton.primary(
                      text: "Lanjutkan",
                      onPressed: () {
                        context.read<DnRekap2invBloc>().add(
                            RegPar2InvoiceEvent(regpar1Id: widget.recordId ?? ""));
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
          _buildDetailRow("NO SPPA:", data.regpar1Id),
          _buildDetailRow("Nama Tertanggung:", data.ttgNama),
          _buildDetailRow("Alamat Tertanggung:", data.ttgAlamat),
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

          // _buildDetailRow("ID Polis", data.regpar2Id),
          // kDivider(color: sGrey),

          _buildDetailRow(
            "Tanggal Mulai:",
            DateFormat('dd MMM yyyy').format(data.polisMulai),
          ),
          _buildDetailRow(
            "Tanggal Berakhir:",
            DateFormat('dd MMM yyyy').format(data.polisAkhir),
          ),

          // _buildDetailRow("Periode Polis",
          //     "${DateFormat('dd MMM yyyy').format(data.polisMulai)} - "
          //         "${DateFormat('dd MMM yyyy').format(data.polisAkhir)}"),
          // kDivider(color: sGrey),

          _buildDetailRow("Okupasi:",
              data.comboROkupasi?.okupasiDesc ?? "-"),

          _buildDetailRow("Kelas Kontruksi:",
              data.comboRKonstruksiojk?.kelasNama ?? "-"),

          _buildDetailRow("Alamat Lokasi Risiko:", data.objectAlamat),

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
          _buildSectionHeader("Perhitungan Tarif"),
          kDivider(color: sGrey),

          // _buildDetailRow("ID Rate", data.regpar3Id),
          // kDivider(color: sGrey),

          _buildDetailRow("Jenis Jaminan:",
              data.comboMJnscoverPar?.jenisNama ?? "-"),

          _buildDetailRowIcon("Kebakaran/Petir:", data.isFlexas),

          _buildDetailRowIcon("Gempa Bumi:", data.isEq),

          _buildDetailRowIcon("Kerusuhan:", data.isRsmdcc),

          _buildDetailRowIcon("Banjir:", data.isTsfwd),

          _buildDetailRowIcon("Lain-lainnya:", data.isOther),

          _buildDetailRow("Banjir:",
              data.comboMWilayah?.wilayahNama ?? "-"),

          _buildDetailRow("Gempa Bumi:",
              data.comboMKabZonaGempa?.kabupaten ?? "-"),
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

          _buildDetailRow("Mata Uang",
              data.comboRMatauang?.rmatauangNama ?? "-"),

          // _buildDetailRow("ID Pertanggungan", data.regpar4Id),
          // kDivider(color: sGrey),
          _buildDetailRow("Mesin:", toCurrency(data.siMachinery)),

          _buildDetailRow("Bangunan:", toCurrency(data.siBuilding)),

          _buildDetailRow("Inventaris:", toCurrency(data.siContent)),

          _buildDetailRow("Stok:", toCurrency(data.siStock)),

          _buildDetailRow("Total:", toCurrency(data.siOther)),

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


/*

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
import '../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../blocs/regpar/regpar1list_bloc.dart';
import '../../../blocs/regpar/regpar2form_bloc.dart';
import '../../../blocs/regpar/regpar3form_bloc.dart';
import '../../../blocs/regpar/regpar4form_bloc.dart';
import '../../../models/regpar/regpar2form_model.dart';
import '../../../models/regpar/regpar3form_model.dart';
import '../../../models/regpar/regpar4form_model.dart';
import '../../../widgets/apptheme/custom_progress_bar.dart';
import '../../../widgets/apptheme/header_card_polis.dart';
import '../../base/base_background_sidepage.dart';
import '../../payment/mobile/payment_page/payment_method/payment_method_page.dart';
import '../../payment/mobile/payment_page/payment_process/payment_process.dart';
import '../../payment/mobile/payment_page/payment_success/payment_success.dart';
import '../../payment/paymentmethodcari_list.dart';



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
  // Regpar1CrudModel? regpar1Record;
  // Regpar2FormModel? regpar2Record;
  // Regpar3FormModel? regpar3Record;
  // Regpar4FormModel? regpar4Record;
  late Regpar1ListBloc regpar1listBloc;
  final TextEditingController _searchController = TextEditingController();

  String toCurrency(double value) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
        .format(value);
  }

  @override
  void initState() {
    super.initState();
    regpar1listBloc = context.read<Regpar1ListBloc>();

    if (widget.viewMode == "ubah" && widget.recordId != null) {
      final draft1 = context.read<Regpar1CrudBloc>().state.record;
      if (draft1 == null) {
        context.read<Regpar1CrudBloc>()
            .add(Regpar1CrudLihatEvent(recordId: widget.recordId!));
      }
    }
  }


  void refreshData() {
    regpar1listBloc.add(
        RefreshRegpar1ListEvent(searchText: _searchController.text, hal: 0));
  }

  void onViewPaymentMethods(String curr, double totalBayar) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentMethodPage(curr: curr, totalBayar: totalBayar)),
    ); // Implement your ta
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Konfirmasi",
      blocListeners: [
        BlocListener<DnRekap2invBloc, DnRekap2invState>(
          listenWhen: (previous, current) {
            return previous.isProcessed != current.isProcessed ||
                previous.hasFailure != current.hasFailure;
          },
          listener: (context, state) {
            if (state.isProcessed) {
              if (state.paymentStatus == "20") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Proses pembayaran berhasil. Silakan lanjutkan ke metode pembayaran.',
                    ),
                  ),
                );
                onViewPaymentMethods(state.curr, state.totalBayar);
              } else if (state.paymentStatus == "30") {
                refreshData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Silakan lakukan pembayaran.')),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentProcess(
                      viewMode: "ubah",
                      recordId: state.invoiceId,
                    ),
                  ),
                );
              } else if (state.paymentStatus == "40") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Proses pembayaran Berhasil.')),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentSuccess(display: "Pembayaran berhasil!"),
                  ),
                );
              } else if (state.paymentStatus == "91") {
                refreshData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Proses pembayaran gagal. Silakan coba lagi.'),
                  ),
                );
              }
            }
          },
        ),
      ],
      child: _buildForm(),
    );
  }

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
    final r1 = context.watch<Regpar1CrudBloc>().state.record;
    final r2 = context.watch<Regpar2FormBloc>().state.record;
    final r3 = context.watch<Regpar3FormBloc>().state.record;
    final r4 = context.watch<Regpar4FormBloc>().state.record;

    // regpar1Id sumbernya:
    // 1) dari draft r1 kalau ada
    // 2) fallback widget.recordId (kalau mode ubah dari list)
    final regpar1Id = r1?.regpar1Id ?? (widget.recordId ?? "");

    return Scaffold(
      backgroundColor: secondaryBlackColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),

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

                  _buildRegpar1Card(
                    r1 ??
                        Regpar1CrudModel(
                          regpar1Id: regpar1Id.isEmpty ? "-" : regpar1Id,
                          ttgNama: "-",
                          ttgAlamat: "-",
                        ),
                  ),

                  _buildRegpar2Card(
                    r2 ??
                        Regpar2FormModel(
                          regpar2Id: "-",
                          polisMulai: DateTime.now(),
                          polisAkhir: DateTime.now(),
                          regpar1Id: regpar1Id,
                          objectAlamat: '',
                        ),
                  ),

                  _buildRegpar4Card(
                    r4 ??
                        Regpar4FormModel(
                          siBuilding: 0,
                          siContent: 0,
                          siMachinery: 0,
                          siOther: 0,
                          siStock: 0,
                          regpar1Id: regpar1Id,
                        ),
                  ),

                  _buildRegpar3Card(
                    r3 ??
                        Regpar3FormModel(
                          regpar3Id: "-",
                          isEq: false,
                          regpar1Id: regpar1Id,
                        ),
                  ),

                  const SizedBox(height: hPadding),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                    child: AppButton.primary(
                      text: "Lanjutkan",
                      onPressed: () {
                        // pakai regpar1Id dari draft
                        context.read<DnRekap2invBloc>().add(
                          RegPar2InvoiceEvent(regpar1Id: regpar1Id),
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
          _buildDetailRow("NO SPPA:", data.regpar1Id),
          _buildDetailRow("Nama Tertanggung:", data.ttgNama),
          _buildDetailRow("Alamat Tertanggung:", data.ttgAlamat),
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

          // _buildDetailRow("ID Polis", data.regpar2Id),
          // kDivider(color: sGrey),

          _buildDetailRow(
            "Tanggal Mulai:",
            DateFormat('dd MMM yyyy').format(data.polisMulai),
          ),
          _buildDetailRow(
            "Tanggal Berakhir:",
            DateFormat('dd MMM yyyy').format(data.polisAkhir),
          ),

          // _buildDetailRow("Periode Polis",
          //     "${DateFormat('dd MMM yyyy').format(data.polisMulai)} - "
          //         "${DateFormat('dd MMM yyyy').format(data.polisAkhir)}"),
          // kDivider(color: sGrey),

          _buildDetailRow("Okupasi:",
              data.comboROkupasi?.okupasiDesc ?? "-"),

          _buildDetailRow("Kelas Kontruksi:",
              data.comboRKonstruksiojk?.kelasNama ?? "-"),

          _buildDetailRow("Alamat Lokasi Risiko:", data.objectAlamat),

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
          _buildSectionHeader("Perhitungan Tarif"),
          kDivider(color: sGrey),

          // _buildDetailRow("ID Rate", data.regpar3Id),
          // kDivider(color: sGrey),

          _buildDetailRow("Jenis Jaminan:",
              data.comboMJnscoverPar?.jenisNama ?? "-"),

          _buildDetailRowIcon("Kebakaran/Petir:", data.isFlexas),

          _buildDetailRowIcon("Gempa Bumi:", data.isEq),

          _buildDetailRowIcon("Kerusuhan:", data.isRsmdcc),

          _buildDetailRowIcon("Banjir:", data.isTsfwd),

          _buildDetailRowIcon("Lain-lainnya:", data.isOther),

          _buildDetailRow("Banjir:",
              data.comboMWilayah?.wilayahNama ?? "-"),

          _buildDetailRow("Gempa Bumi:",
              data.comboMKabZonaGempa?.kabupaten ?? "-"),
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

          _buildDetailRow("Mata Uang",
              data.comboRMatauang?.rmatauangNama ?? "-"),

          // _buildDetailRow("ID Pertanggungan", data.regpar4Id),
          // kDivider(color: sGrey),
          _buildDetailRow("Mesin:", toCurrency(data.siMachinery)),

          _buildDetailRow("Bangunan:", toCurrency(data.siBuilding)),

          _buildDetailRow("Inventaris:", toCurrency(data.siContent)),

          _buildDetailRow("Stok:", toCurrency(data.siStock)),

          _buildDetailRow("Total:", toCurrency(data.siOther)),

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

 */