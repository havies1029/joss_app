import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/regpar/regpar1crud_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/regpar/regpar1crud_model.dart';
import 'package:joss_app/pages/tagihan_pembayaran/mobile/payment_page/payment_method/payment_method_page.dart';
import 'package:joss_app/pages/tagihan_pembayaran/mobile/payment_page/payment_process/payment_process.dart';
import 'package:joss_app/pages/tagihan_pembayaran/mobile/payment_page/payment_success/payment_success.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../blocs/payment/invbayarvaform_bloc.dart';
import '../../../blocs/payment/invoicestatuscard_bloc.dart';
import '../../../blocs/quopdf/quopdf_bloc.dart';
import '../../../blocs/quopdf/quopdf_event.dart';
import '../../../blocs/quopdf/quopdf_state.dart';
import '../../../blocs/regpar/regpar1list_bloc.dart';
import '../../../blocs/regpar/regpar2form_bloc.dart';
import '../../../blocs/regpar/regpar3form_bloc.dart';
import '../../../blocs/regpar/regpar4form_bloc.dart';
import '../../../common/loading_indicator.dart';
import '../../../helper/navigation_keys.dart';
import '../../../helper/pdf_open_helper.dart';
import '../../../models/regpar/regpar2form_model.dart';
import '../../../models/regpar/regpar3form_model.dart';
import '../../../models/regpar/regpar4form_model.dart';
import '../../../widgets/apptheme/register_client_pop_up.dart';
import '../../base/base_background_sidepage.dart';
import '../../heropage/mobile/widget/transaksi_page.dart';
import '../../tagihan_pembayaran/mobile/riwayat/riwayat_page_remake.dart';

//micky 2026-02-27

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
  String? globalMataUang;
  bool isSubmitting = false;
  bool isAgreementChecked = false;
  bool _isCardWebViewOpen = false;
  bool _hasHandledPaymentCancel = false;

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
      MaterialPageRoute(
        builder: (_) => PaymentMethodPage(
          curr: curr,
          totalBayar: totalBayar,
        ),
      ),
    );
  }

  void _showPdfLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(
          child: LoadingIndicator(),
        ),
      ),
    );
  }

  void _closePdfLoadingDialog(BuildContext context) {
    final navigator = Navigator.of(context, rootNavigator: true);

    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  Future<bool?> showExitConfirmDialog(BuildContext context) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Tutup",
      barrierColor: Colors.black.withOpacity(0.45),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              decoration: BoxDecoration(
                color: formGrey,
                borderRadius: BorderRadius.circular(cardBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SVG Warning Icon
                  SizedBox(
                    width: 38,
                    height: 38,
                    child: SvgPicture.asset(
                      "assets/icons/bi_exclamation-circle.svg",
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Keluar halaman ini?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryLightColor,
                      fontSize: getResponsiveFont(context, 18),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    "Anda memiliki data yang belum disimpan. Jika keluar dari halaman ini, seluruh data akan hilang.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryLightColor.withOpacity(0.7),
                      fontSize: getResponsiveFont(context, 16),
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: sGrey,
                              foregroundColor: primaryLightColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(cardBorderRadius),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(
                              "Tidak",
                              style: TextStyle(
                                fontSize: getResponsiveFont(context, 16),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: pSlowRed,
                              foregroundColor: primaryLightColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(cardBorderRadius),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(
                              "Iya, Keluar",
                              style: TextStyle(
                                fontSize: getResponsiveFont(context, 16),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: child,
          ),
        );
      },
    );
  }

  Future<void> _handleExit(BuildContext context) async {
    final shouldLeave = await showExitConfirmDialog(context);

    if (shouldLeave == true) {
      context.read<Regpar1CrudBloc>().add(
        Regpar1CrudHapusEvent(recordId:  widget.recordId ?? ""),
      );

      final homeState = homeTabKey.currentState;

      if (homeState != null) {
        homeState.goToHeroPage();
      }

      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  bool _isGlobalLoadingShown = false;

  void _showGlobalLoading() {
    if (!mounted || _isGlobalLoadingShown) return;

    _isGlobalLoadingShown = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(
          child: LoadingIndicator(),
        ),
      ),
    );
  }

  void _hideGlobalLoading() {
    if (!mounted || !_isGlobalLoadingShown) return;

    _isGlobalLoadingShown = false;
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Konfirmasi",
      // onBack: () async {
      //   await _handleExit(context);
      // },
      onHome: () async {
        await _handleExit(context);
      },
      blocListeners: [
        BlocListener<DnRekap2invBloc, DnRekap2invState>(
          listenWhen: (previous, current) {
            return previous.isProcessed != current.isProcessed ||
                previous.hasFailure != current.hasFailure;
          },
          listener: (context, state) {
            debugPrint('DnRekap2inv listener status: ${state.paymentStatus}');

            if (state.isProcessed || state.hasFailure) {
              _hideGlobalLoading();

              if (mounted) {
                setState(() => isSubmitting = false);
              }
            }

            final messenger = ScaffoldMessenger.of(context);

            if (state.hasFailure) {
              messenger.showSnackBar(
                errorSnackBar(
                  "Gagal memproses pembayaran. Silakan coba lagi.",
                ),
              );
              return;
            }

            if (!state.isProcessed) return;

            if (state.paymentStatus == "20") {
              messenger.showSnackBar(
                successSnackBar(
                  "Invoice berhasil dibuat. Silakan lanjut ke metode pembayaran.",
                ),
              );

              final curr = (state.curr.isEmpty) ? globalMataUang ?? "" : state.curr;
              onViewPaymentMethods(curr, state.totalBayar);
              return;
            }

            if (state.paymentStatus == "30") {
              refreshData();

              messenger.showSnackBar(
                successSnackBar(
                  "Silakan lanjutkan proses pembayaran Anda.",
                ),
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

              return;
            }

            if (state.paymentStatus == "40") {
              if (_isCardWebViewOpen && Navigator.of(context).canPop()) {
                _isCardWebViewOpen = false;
                Navigator.of(context).pop();
              }

              messenger.showSnackBar(
                successSnackBar(
                  "Pembayaran berhasil diselesaikan.",
                ),
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentSuccess(
                    display: "Pembayaran berhasil!",
                    displayButton: "Kembali",
                    description:
                    "Selamat! Perlindungan kendaraan Anda resmi dimulai.",
                  ),
                ),
              );
              return;
            }

            // if (state.paymentStatus == "91") {
            //   refreshData();
            //
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => PaymentSuccess(
            //         display: "Pengajuan Tidak Dilanjutkan",
            //         description: "Karena proses pembayaran dibatalkan, pengajuan polis Anda juga telah dibatalkan. Untuk membeli polis, silakan lakukan pengajuan kembali.",
            //         displayButton: "Kembali",
            //         onButtonPressed: () {
            //           Navigator.of(context).pushAndRemoveUntil(
            //             MaterialPageRoute(
            //               builder: (_) => const TransaksiPage(),
            //             ),
            //                 (route) => route.isFirst,
            //           );
            //         },
            //       ),
            //     ),
            //   );
            //
            //   return;
            // }

            if (state.paymentStatus == "92") {
              refreshData();

              if (_isCardWebViewOpen &&
                  Navigator.of(context, rootNavigator: true).canPop()) {
                _isCardWebViewOpen = false;
                Navigator.of(context, rootNavigator: true).pop();
              }

              messenger.showSnackBar(
                errorSnackBar(
                  "Nomor kartu kredit salah. Silakan masukkan ulang kartu yang benar.",
                ),
              );

              return;
            }

            if (state.paymentStatus == "93") {
              refreshData();

              if (_isCardWebViewOpen &&
                  Navigator.of(context, rootNavigator: true).canPop()) {
                _isCardWebViewOpen = false;
                Navigator.of(context, rootNavigator: true).pop();
              }

              messenger.showSnackBar(
                infoSnackBar(
                  "Proses pembayaran kartu kredit dibatalkan.",
                ),
              );

              return;
            }

            messenger.showSnackBar(
              errorSnackBar(
                "Status pembayaran tidak dikenali. Silakan periksa kembali.",
              ),
            );
          },
        ),

        BlocListener<InvoiceStatusCardBloc, InvoiceStatusCardState>(
          listenWhen: (previous, current) {
            return previous.isLoaded != current.isLoaded ||
                previous.hasFailure != current.hasFailure;
          },
          listener: (context, state) async {
            final messenger = ScaffoldMessenger.of(context);

            if (state.hasFailure) {
              _hideGlobalLoading();

              if (mounted) {
                setState(() => isSubmitting = false);
              }

              messenger.showSnackBar(
                errorSnackBar(
                  'Proses pembayaran kartu gagal. Silakan coba lagi.',
                ),
              );
              return;
            }

            if (!state.isLoaded || state.record == null) return;

            _hideGlobalLoading();

            if (mounted) {
              setState(() => isSubmitting = false);
            }

            final record = state.record!;
            final status = record.status.trim();
            final redirectUrl = record.redirectUrl.trim();

            if (status == "91") {
              if (_hasHandledPaymentCancel) return;
              _hasHandledPaymentCancel = true;

              refreshData();

              ScaffoldMessenger.of(context).showSnackBar(
                successSnackBar('Pembayaran berhasil dibatalkan.'),
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PaymentSuccess(
                    display: "Pembayaran Berhasil Dibatalkan",
                    description: "Tagihan pembayaran telah dibatalkan.",
                    displayButton: "Kembali",
                    assetPath: "assets/icons/Logo_Gagal1.svg",
                    onButtonPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const TransaksiPage(),
                        ),
                            (route) => route.isFirst,
                      );
                    },
                  ),
                ),
              );

              return;
            }

            if (status == "92") {
              messenger.showSnackBar(
                errorSnackBar(
                  'Nomor kartu kredit salah. Silakan masukkan ulang kartu yang benar.',
                ),
              );

              refreshData();
              return;
            }

            if (status == "93") {
              messenger.showSnackBar(
                infoSnackBar(
                  'Proses pembayaran kartu kredit dibatalkan.',
                ),
              );

              refreshData();
              return;
            }

            if (redirectUrl.isEmpty) {
              messenger.showSnackBar(
                errorSnackBar(
                  'Redirect URL pembayaran tidak ditemukan.',
                ),
              );

              return;
            }

            context.read<InvbayarvaFormBloc>().add(
              CreditCardPaymentCheckingStarted(
                invoiceId: record.invoiceId,
                interval: const Duration(seconds: 4),
              ),
            );

            _isCardWebViewOpen = true;

            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return PaymentCardWebViewDialog(
                  url: redirectUrl,
                  invoiceId: record.invoiceId,
                );
              },
            );

            _isCardWebViewOpen = false;
          },
        ),

        BlocListener<QuotationPdfBloc, QuotationPdfState>(
          listener: (context, state) async {
            if (state is QuotationPdfLoading) {
              _showPdfLoadingDialog(context);
              return;
            }

            if (state is QuotationPdfLoaded) {
              _closePdfLoadingDialog(context);

              try {
                await PdfOpenHelper().openFilePdf(
                  filePath: state.filePath,
                );
              } catch (e) {
                debugPrint('Gagal buka quotation PDF: $e');

                ScaffoldMessenger.of(context).showSnackBar(
                  errorSnackBar("Gagal membuka PDF penawaran."),
                );
              }

              return;
            }

            if (state is QuotationPdfError) {
              _closePdfLoadingDialog(context);

              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar("Gagal mengunduh PDF penawaran."),
              );
            }
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
                        Expanded(
                          child: Text(
                            "Pastikan semua data sudah sesuai sebelum melanjutkan.",
                            style: bodyTextStyle(context).copyWith(
                              color: primaryLightColor,
                            ),
                          ),
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


                  // Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                  //     child: AppButton.primary(
                  //       text: "Lanjutkan",
                  //       isLoading: isSubmitting,
                  //       onPressed: isSubmitting
                  //           ? null
                  //           : () async {
                  //         if (mounted) {
                  //           setState(() => isSubmitting = true);
                  //         }
                  //
                  //         context.read<DnRekap2invBloc>().add(
                  //           RegPar2InvoiceEvent(
                  //             regpar1Id: widget.recordId ?? "",
                  //           ),
                  //         );
                  //       },
                  //     )
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                  //   child: AppButton.primary(
                  //     text: "Lanjutkan",
                  //     onPressed: isSubmitting
                  //         ? null
                  //         : () async {
                  //       showDialog(
                  //         context: context,
                  //         barrierDismissible: true,
                  //         barrierColor: Colors.black.withOpacity(0.6),
                  //         builder: (dialogContext) => RegisterClientPopUp(
                  //           showIcon: false,
                  //           header: 'Fitur pembayaran belum tersedia.',
                  //           description:
                  //           'Saat ini aplikasi masih dalam mode Demo/Uji Coba. Pembayaran belum dapat dilakukan. Silahkan tunggu hingga aplikasi Go Live.',
                  //           buttonText: 'Mengerti',
                  //           onPressed: () {
                  //             // Navigator.of(dialogContext).pop();
                  //           },
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                    child: regpar3Record == null
                        ? const Center(
                      child: LoadingIndicator(),
                    )
                        : (regpar3Record?.isEq == true)
                        ? Row(
                      children: [
                        Expanded(
                          child: AppButton.iconLeft(
                            text: "Lihat Penawaran PAR",
                            backgroundColor: pdfRed,
                            onPressed: isSubmitting
                                ? null
                                : () {
                              context.read<QuotationPdfBloc>().add(
                                DownloadQuotationPdfEvent(
                                  quotationType: "par",
                                  quotationNo: widget.recordId ?? "",
                                ),
                              );
                            },
                            icon: _pdfIcon(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppButton.iconLeft(
                            text: "Lihat Penawaran EQ",
                            backgroundColor: pdfRed,
                            onPressed: isSubmitting
                                ? null
                                : () {
                              context.read<QuotationPdfBloc>().add(
                                DownloadQuotationPdfEvent(
                                  quotationType: "pareq",
                                  quotationNo: widget.recordId ?? "",
                                ),
                              );
                            },
                            icon: _pdfIcon(),
                          ),
                        ),
                      ],
                    )
                        : AppButton.iconLeft(
                      text: "Lihat Penawaran PAR",
                      backgroundColor: pdfRed,
                      onPressed: isSubmitting
                          ? null
                          : () {
                        context.read<QuotationPdfBloc>().add(
                          DownloadQuotationPdfEvent(
                            quotationType: "par",
                            quotationNo: widget.recordId ?? "",
                          ),
                        );
                      },
                      icon: _pdfIcon(),
                    ),
                  ),

                  const SizedBox(height: hPadding),


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "*Silakan baca detail penawaran sebelum melanjutkan pembayaran.",
                            style: bodyTextStyle(context).copyWith(
                              color: primaryLightColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(checkboxBorderRadius),
                      onTap: () {
                        setState(() {
                          isAgreementChecked = !isAgreementChecked;
                        });
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: isAgreementChecked,
                            activeColor: primaryColor,
                            checkColor: Colors.white,
                            side: const BorderSide(
                              color: sGrey,
                              width: 1.4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                checkboxBorderRadius,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                isAgreementChecked = value ?? false;
                              });
                            },
                          ),

                          const SizedBox(width: 6),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                'Saya telah membaca dan menyetujui penawaran yang diberikan.',
                                style: bodyTextStyle(context).copyWith(
                                  color: primaryLightColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: hPadding),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                    child: AppButton.primary(
                      text: "Pembayaran",
                      backgroundColor:
                      isAgreementChecked ? primaryColor : sGrey,
                      onPressed: isSubmitting || !isAgreementChecked
                          ? null
                          : () async {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierColor: Colors.black.withOpacity(0.6),
                          builder: (dialogContext) => RegisterClientPopUp(
                            showIcon: false,
                            header: 'Fitur pembayaran belum tersedia.',
                            description:
                            'Saat ini aplikasi masih dalam mode Demo/Uji Coba. Pembayaran belum dapat dilakukan. Silahkan tunggu hingga aplikasi Go Live.',
                            buttonText: 'Mengerti',
                            onPressed: () {
                              // Navigator.of(dialogContext).pop();
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  // Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                  //     child: AppButton.primary(
                  //       text: "Pembayaran",
                  //       isLoading: isSubmitting,
                  //       backgroundColor:
                  //       isAgreementChecked ? primaryColor : sGrey,
                  //         onPressed: isSubmitting || !isAgreementChecked
                  //             ? null
                  //             : () async {
                  //           if (mounted) {
                  //             setState(() => isSubmitting = true);
                  //           }
                  //
                  //           _showGlobalLoading();
                  //
                  //           context.read<DnRekap2invBloc>().add(
                  //             RegPar2InvoiceEvent(
                  //               regpar1Id: widget.recordId ?? "",
                  //             ),
                  //           );
                  //         },
                  //     )
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pdfIcon() {
    return SvgPicture.asset(
      'assets/icons/icon_pdf.svg',
      width: 18,
      height: 18,
      colorFilter: const ColorFilter.mode(
        Colors.white,
        BlendMode.srcIn,
      ),
    );
  }

  Widget _buildCardLoading() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: vPadding),
      child: Center(
        child: LoadingIndicator(),
      ),
    );
  }

  Widget _buildRegpar1Card(Regpar1CrudModel? data) {
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
          if (data == null) ...[
            _buildCardLoading(),
          ] else ...[
            _buildDetailRow("NO SPPA:", data.regpar1Id),
            _buildDetailRow("Nama Tertanggung:", data.ttgNama),
            _buildDetailRow("Alamat Tertanggung:", data.ttgAlamat),
          ],
        ],
      ),
    );
  }

  Widget _buildRegpar2Card(Regpar2FormModel? data) {
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
          if (data == null) ...[
            _buildCardLoading(),
          ] else ...[
            _buildDetailRow(
              "Tanggal Mulai:",
              DateFormat('dd MMM yyyy').format(data.polisMulai),
            ),
            _buildDetailRow(
              "Tanggal Berakhir:",
              DateFormat('dd MMM yyyy').format(data.polisAkhir),
            ),
            _buildDetailRow(
              "Okupasi:",
              data.comboROkupasi?.okupasiDesc ?? "-",
            ),
            _buildDetailRow(
              "Kelas Kontruksi:",
              data.comboRKonstruksiojk?.kelasNama ?? "-",
            ),
            _buildDetailRow("Alamat Lokasi Risiko:", data.objectAlamat),
          ],
        ],
      ),
    );
  }

  Widget _buildRegpar3Card(Regpar3FormModel? data) {
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
          if (data == null) ...[
            _buildCardLoading(),
          ] else ...[
            _buildDetailRow(
              "Jenis Jaminan:",
              data.comboMJnscoverPar?.jenisNama ?? "-",
            ),
            _buildDetailRowIcon("Kebakaran/Petir:", data.isFlexas),
            _buildDetailRowIcon("Gempa Bumi:", data.isEq),
            _buildDetailRowIcon("Kerusuhan:", data.isRsmdcc),
            _buildDetailRowIcon("Banjir:", data.isTsfwd),
            _buildDetailRowIcon("Lain-lainnya:", data.isOther),
            _buildDetailRow(
              "Banjir:",
              data.comboMWilayah?.wilayahNama ?? "-",
            ),
            _buildDetailRow(
              "Gempa Bumi:",
              data.comboMKabZonaGempa?.kabupaten ?? "-",
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRegpar4Card(Regpar4FormModel? data) {
    final mataUang = data?.comboRMatauang?.rmatauangSimbol ?? "-";
    globalMataUang = mataUang;

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
          if (data == null) ...[
            _buildCardLoading(),
          ] else ...[
            _buildDetailRow("Mata Uang", mataUang),
            _buildDetailRow("Mesin:", toCurrency(data.siMachinery)),
            _buildDetailRow("Bangunan:", toCurrency(data.siBuilding)),
            _buildDetailRow("Inventaris:", toCurrency(data.siContent)),
            _buildDetailRow("Stok:", toCurrency(data.siStock)),
            _buildDetailRow("Total:", toCurrency(data.siOther)),
          ],
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
