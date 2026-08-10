import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/tagihan_pembayaran/mobile/payment_page/payment_method/payment_method_page.dart';
import 'package:joss_app/pages/tagihan_pembayaran/mobile/payment_page/payment_process/payment_process.dart';
import 'package:joss_app/pages/tagihan_pembayaran/mobile/payment_page/payment_success/payment_success.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../blocs/gen_regmv/regmv1crud_bloc.dart';
import '../../../blocs/gen_regmv/regmv1list_bloc.dart';
import '../../../blocs/gen_regmv/regmv2form_bloc.dart';
import '../../../blocs/gen_regmv/regmv3form_bloc.dart';
import '../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../blocs/payment/invbayarvaform_bloc.dart';
import '../../../blocs/payment/invoicestatuscard_bloc.dart';
import '../../../blocs/quopdf/quopdf_bloc.dart';
import '../../../blocs/quopdf/quopdf_event.dart';
import '../../../blocs/quopdf/quopdf_state.dart';
import '../../../common/loading_indicator.dart';
import '../../../helper/navigation_keys.dart';
import '../../../helper/pdf_open_helper.dart';
import '../../../models/gen_regmv/regmv1crud_model.dart';
import '../../../models/gen_regmv/regmv2form_model.dart';
import '../../../models/gen_regmv/regmv3form_model.dart';
import '../../../widgets/apptheme/register_client_pop_up.dart';
import '../../base/base_background_sidepage.dart';
import '../../heropage/mobile/widget/transaksi_page.dart';
import '../../tagihan_pembayaran/mobile/riwayat/riwayat_page_remake.dart';
import '../../../helper/cob_access_guard.dart';

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
  bool _accessDeniedDialogShown = false;
  Regmv1CrudModel? regmv1Record;
  Regmv2FormModel? regmv2Record;
  Regmv3FormModel? regmv3Record;
  late Regmv1ListBloc regmv1ListBloc;
  //final TextEditingController _searchController = TextEditingController();
  String? globalMataUang;
  bool isSubmitting = false;
  bool isAgreementChecked = false;
  bool _isCardWebViewOpen = false;
  bool _hasHandledPaymentCancel = false;
  ScaffoldMessengerState? _scaffoldMessenger;
  NavigatorState? _navigator;
  NavigatorState? _rootNavigator;

  String toCurrency(double value) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
        .format(value);
  }

  String toPercent1(double value) {
    return '${value.toStringAsFixed(2)}%';
  }

  bool _hasRealText(String? value) {
    final text = value?.trim() ?? "";
    return text.isNotEmpty && text != "-";
  }

  String _firstRealText(List<String?> values, {String fallback = "-"}) {
    for (final value in values) {
      if (_hasRealText(value)) return value!.trim();
    }
    return fallback;
  }

  String _regmv2CurrencyName(Regmv2FormModel data) {
    return _firstRealText([
      data.comboRMatauang?.rmatauangNama,
      data.comboRMatauang?.rmatauangSimbol,
      data.currId,
    ]);
  }

  String _regmv2CurrencySymbol(Regmv2FormModel data) {
    return _firstRealText([
      data.comboRMatauang?.rmatauangSimbol,
      data.currId,
      data.comboRMatauang?.rmatauangNama,
    ]);
  }

  String _regmv2CoverName(Regmv2FormModel data) {
    return _firstRealText([
      data.comboMMvjnscover?.coverName,
      data.mmvjnscoverId,
    ]);
  }

  Regmv2FormModel _preserveRegmv2Combos(Regmv2FormModel next) {
    final current = regmv2Record;
    if (current == null) return next;

    final hasNextCurrencyId = _hasRealText(next.currId);
    final hasNextCoverId = _hasRealText(next.mmvjnscoverId);
    final sameCurrency = hasNextCurrencyId &&
        _hasRealText(current.currId) &&
        next.currId == current.currId;
    final sameCover = hasNextCoverId &&
        _hasRealText(current.mmvjnscoverId) &&
        next.mmvjnscoverId == current.mmvjnscoverId;

    return next.copyWith(
      currId: hasNextCurrencyId ? next.currId : current.currId,
      comboRMatauang: next.comboRMatauang ??
          (!hasNextCurrencyId || sameCurrency ? current.comboRMatauang : null),
      mmvjnscoverId: hasNextCoverId ? next.mmvjnscoverId : current.mmvjnscoverId,
      comboMMvjnscover: next.comboMMvjnscover ??
          (!hasNextCoverId || sameCover ? current.comboMMvjnscover : null),
    );
  }

  void _cachePaymentCurrency(Regmv2FormModel data) {
    final curr = _regmv2CurrencySymbol(data);
    if (_hasRealText(curr)) {
      globalMataUang = curr;
    }
  }

  String _paymentCurrency(String stateCurr) {
    return _firstRealText([stateCurr], fallback: "");
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
    final navigator = _rootNavigator;
    if (navigator != null && navigator.canPop()) {
      navigator.pop();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadKonfirmasiData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
    _navigator = Navigator.maybeOf(context);
    _rootNavigator = Navigator.maybeOf(context, rootNavigator: true);
  }

  void _loadKonfirmasiData() {
    final recordId = widget.recordId?.trim() ?? "";
    if (widget.viewMode != "ubah" || recordId.isEmpty) return;

    debugPrint("[KONFIRMASI REGMV] dispatch lihat regmv1/2/3: $recordId");

    context.read<Regmv1CrudBloc>().add(
          Regmv1CrudLihatEvent(recordId: recordId),
        );
    context.read<Regmv2FormBloc>().add(
          Regmv2FormLihatEvent(recordId: recordId),
        );
    context.read<Regmv3FormBloc>().add(
          Regmv3FormLihatEvent(recordId: recordId),
        );
  }

/*
  void refreshData() {
    regmv1ListBloc.add(
        RefreshRegmv1ListEvent(searchText: _searchController.text, hal: 0));
  }
  */

  void onViewPaymentMethods(String curr, double totalBayar) {
    _navigator?.push(
      MaterialPageRoute(
        builder: (_) => PaymentMethodPage(
          curr: curr,
          totalBayar: totalBayar,
        ),
      ),
    );
  }

  void _showSafeSnackBar(SnackBar snackBar) {
    final messenger = _scaffoldMessenger;
    if (messenger == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(snackBar);
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
      context.read<Regmv1CrudBloc>().add(
            Regmv1CrudHapusEvent(recordId: widget.recordId ?? ""),
          );

      final homeState = homeTabKey.currentState;

      if (homeState != null) {
        homeState.goToHeroPage();
      }

      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _handleAccessDeniedExit(BuildContext context) {
    context.read<Regmv1CrudBloc>().add(
          Regmv1CrudHapusEvent(recordId: widget.recordId ?? ""),
        );

    final homeState = homeTabKey.currentState;

    if (homeState != null) {
      homeState.goToHeroPage();
    }

    Navigator.of(context).popUntil((route) => route.isFirst);
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
        CobAccessGuard.buildHakaksesListener(
          cobId: CobAccessGuard.cobKendaraan,
          isDialogShown: () => _accessDeniedDialogShown,
          markDialogShown: () {
            _accessDeniedDialogShown = true;
          },
          onAccessDeniedReturn: () => _handleAccessDeniedExit(context),
        ),
        BlocListener<DnRekap2invBloc, DnRekap2invState>(
          listenWhen: (previous, current) {
            return previous.isProcessed != current.isProcessed ||
                previous.hasFailure != current.hasFailure;
          },
          listener: (context, state) {
            if (state.isProcessed || state.hasFailure) {
              _hideGlobalLoading();
              if (!mounted) return;

              setState(() => isSubmitting = false);
            }

            if (state.hasFailure) {
              _showSafeSnackBar(
                errorSnackBar(
                  'Gagal memproses pembayaran. Silakan coba lagi.',
                ),
              );
              return;
            }

            if (!state.isProcessed) return;

            if (state.paymentStatus == "20") {
              final curr = _paymentCurrency(state.curr);

              onViewPaymentMethods(curr, state.totalBayar);
              _showSafeSnackBar(
                successSnackBar(
                  'Proses pembayaran berhasil. Silakan lanjutkan ke metode pembayaran.',
                ),
              );
            } else if (state.paymentStatus == "30") {
              _showSafeSnackBar(
                successSnackBar('Silakan lakukan pembayaran.'),
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
            } else if (state.paymentStatus == "92") {
              if (_isCardWebViewOpen &&
                  Navigator.of(context, rootNavigator: true).canPop()) {
                _isCardWebViewOpen = false;
                Navigator.of(context, rootNavigator: true).pop();
              }

              _showSafeSnackBar(
                errorSnackBar(
                  'Nomor kartu kredit salah. Silakan masukkan ulang kartu yang benar.',
                ),
              );
            } else if (state.paymentStatus == "40") {
              if (_isCardWebViewOpen && Navigator.of(context).canPop()) {
                _isCardWebViewOpen = false;
                Navigator.of(context).pop();
              }

              _showSafeSnackBar(
                successSnackBar('Proses pembayaran Berhasil.'),
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentSuccess(
                    display: "Pembayaran berhasil!",
                    description:
                        "Selamat! Perlindungan kendaraan Anda resmi dimulai.",
                    displayButton: "Kembali",
                  ),
                ),
              );
            } else if (state.paymentStatus == "93") {
              if (_isCardWebViewOpen &&
                  Navigator.of(context, rootNavigator: true).canPop()) {
                _isCardWebViewOpen = false;
                Navigator.of(context, rootNavigator: true).pop();
              }

              _showSafeSnackBar(
                infoSnackBar(
                  'Proses pembayaran kartu kredit dibatalkan.',
                ),
              );
            } else if (state.paymentStatus == "91") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentSuccess(
                    display: "Invoice Tidak Dapat Dilanjutkan",
                    description:
                        "Invoice ini telah dibatalkan atau masa pembayarannya telah berakhir. Silakan buat pengajuan atau pembayaran baru.",
                    displayButton: "Kembali",
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
            }

            // optional: kalau kamu punya flag hasFailure dan mau tampilkan error umumnya
            // if (state.hasFailure) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(content: Text(state.failureMessage ?? 'Terjadi kesalahan')),
            //   );
            // }
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
              if (mounted) {
                setState(() => isSubmitting = false);
              }

              String message =
                  'Proses pembayaran kartu gagal. Silakan coba lagi.';

              final errorMessage = state.message.trim();

              if (errorMessage.contains(
                '"card_number" must be a credit card',
              )) {
                message =
                    'Maaf, nomor kartu yang dimasukkan tidak dikenali sebagai kartu kredit.';
              } else if (errorMessage.contains(
                'card_details.card_number must match pattern',
              )) {
                message =
                    'Maaf, nomor kartu harus terdiri dari 14 sampai 19 digit angka.';
              }

              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar(message),
              );
              return;
            }

            if (!state.isLoaded || state.record == null) return;

            if (mounted) {
              setState(() => isSubmitting = false);
            }

            final record = state.record!;
            final status = record.status.trim();
            final redirectUrl = record.redirectUrl.trim();

            if (status == "91") {
              if (_hasHandledPaymentCancel) return;
              _hasHandledPaymentCancel = true;

              // refreshData();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentSuccess(
                    display: "Invoice Tidak Dapat Dilanjutkan",
                    description:
                        "Invoice ini telah dibatalkan atau masa pembayarannya telah berakhir. Silakan buat pengajuan atau pembayaran baru.",
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
              // refreshData();

              messenger.showSnackBar(
                errorSnackBar(
                  "Nomor kartu kredit salah. Silakan masukkan ulang kartu yang benar.",
                ),
              );

              return;
            }

            if (status == "93") {
              // refreshData();

              messenger.showSnackBar(
                infoSnackBar(
                  "Proses pembayaran kartu kredit dibatalkan.",
                ),
              );

              return;
            }

            if (redirectUrl.isEmpty) {
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
                  errorSnackBar(
                    "Gagal membuka PDF penawaran.",
                  ),
                );
              }

              return;
            }

            if (state is QuotationPdfError) {
              _closePdfLoadingDialog(context);

              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar(
                  "Gagal mengunduh PDF penawaran.",
                ),
              );
            }
          },
        ),
        _buildGenericListener<Regmv1CrudBloc, Regmv1CrudState, Regmv1CrudModel>(
          onPayload: (record) {
            setState(() => regmv1Record = record);
          },
        ),
        _buildGenericListener<Regmv2FormBloc, Regmv2FormState, Regmv2FormModel>(
          onPayload: (record) {
            final pageRecordId = widget.recordId?.trim() ?? "";
            if (record.regmv1Id.trim() != pageRecordId) return;

            setState(() {
              regmv2Record = _preserveRegmv2Combos(record);
              _cachePaymentCurrency(regmv2Record!);
            });

            // Form2 ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ Form3 (PAKAI record.regmv1Id)
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

  // ÃƒÂ°Ã…Â¸Ã¢â‚¬ÂÃ‚Â¹ Generic listener tetap jalan seperti semula
  BlocListener<B, S> _buildGenericListener<B extends StateStreamable<S>, S, M>({
    required void Function(M record) onPayload,
  }) {
    return BlocListener<B, S>(
      listenWhen: (prev, curr) {
        final prevDynamic = prev as dynamic;
        final currDynamic = curr as dynamic;
        final currRecord = currDynamic.record;
        if (currDynamic.isLoaded != true || currRecord == null) return false;
        return prevDynamic.isLoaded != currDynamic.isLoaded ||
            prevDynamic.record != currRecord;
      },
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                    child: Row(
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

                  _buildRegmv1Card(
                    regmv1Record ??
                        Regmv1CrudModel(
                          calmv1Id: "-",
                          regmv1Id: "-",
                          ttgNama: "-",
                          ttgAlamat: "-",
                        ),
                  ),

                  _buildRegmv2Card(
                    regmv2Record ??
                        Regmv2FormModel(
                          regmv2Id: "-",
                          regmv1Id: "-",
                          polisMulai: DateTime.now(),
                          polisAkhir: DateTime.now(),
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
                          isAw: false,
                          currId: null,
                          comboRMatauang: null,
                          mmvjnscoverId: null,
                          comboMMvjnscover: null,
                        ),
                  ),

                  _buildRegmv3Card(
                    regmv3Record ??
                        Regmv3FormModel(
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

                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                  //   child: AppButton.primary(
                  //     text: "Lanjutkan",
                  //     isLoading: isSubmitting,
                  //     onPressed: isSubmitting
                  //         ? null
                  //         : () async {
                  //       if (mounted) {
                  //         setState(() => isSubmitting = true);
                  //       }
                  //
                  //       context.read<DnRekap2invBloc>().add(
                  //         RegMv2InvoiceEvent(
                  //           regmv1Id: widget.recordId ?? "",
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                    child: AppButton.iconLeft(
                      text: "Lihat Penawaran",
                      backgroundColor: pdfRed,
                      onPressed: isSubmitting
                          ? null
                          : () {
                              context.read<QuotationPdfBloc>().add(
                                    DownloadQuotationPdfEvent(
                                      quotationType: "mv",
                                      quotationNo: widget.recordId ?? "",
                                    ),
                                  );
                            },
                      icon: SvgPicture.asset(
                        'assets/icons/icon_pdf.svg',
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: hPadding),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(checkboxBorderRadius),
                      onTap: () {
                        setState(() {
                          isAgreementChecked = !isAgreementChecked;
                        });
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                            child: Text(
                              'Saya telah membaca dan menyetujui penawaran yang diberikan.',
                              style: bodyTextStyle(context).copyWith(
                                color: primaryLightColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: hPadding),

                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                  //   child: AppButton.primary(
                  //     text: "Pembayaran",
                  //     backgroundColor:
                  //     isAgreementChecked ? primaryColor : sGrey,
                  //     onPressed: isSubmitting || !isAgreementChecked
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
                      child: AppButton.primary(
                        text: "Pembayaran",
                        isLoading: isSubmitting,
                        backgroundColor:
                            isAgreementChecked ? primaryColor : sGrey,
                        onPressed: isSubmitting || !isAgreementChecked
                            ? null
                            : () async {
                                if (mounted) {
                                  setState(() => isSubmitting = true);
                                }

                                _showGlobalLoading();

                                context.read<DnRekap2invBloc>().add(
                                      RegMv2InvoiceEvent(
                                        regmv1Id: widget.recordId ?? "",
                                      ),
                                    );
                              },
                      )),
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
            _regmv2CurrencyName(data),
          ),

          _buildDetailRow(
            "Jenis Jaminan:",
            _regmv2CoverName(data),
          ),
          _buildDetailRowIcon("Gempa Bumi:", data.isEq),
          _buildDetailRowIcon("Banjir:", data.isFlood),
          _buildDetailRowIcon("Kerusuhan:", data.isSrcc),
          _buildDetailRowIcon("Terrorism:", data.isTerrorism),
          // _buildDetailRowIcon("Kerusakan Barang Pihak ketiga:", data.isTbod),
          _buildDetailRowIcon("Bengkel Resmi:", data.isAw),
          _buildDetailRow("Tanggung Jawab Penumpang:", toCurrency(data.pll)),
          _buildDetailRow("Tanggung Jawab Pihak Ketiga:", toCurrency(data.tpl)),
          _buildDetailRow("Kecelakaan Diri Pengemudi:", toCurrency(data.pad)),
          _buildDetailRow("Kecelakaan Diri Penumpang:", toCurrency(data.pap)),
          _buildDetailRow("Jumlah Penumpang:", data.passangerCount),
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

          _buildDetailRow("No Plat:", data.platNo),

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
            (data.aksesoris?.trim().isNotEmpty ?? false)
                ? data.aksesoris!
                : "-",
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
      iconWidget =
          SvgPicture.asset('assets/icons/dipilih.svg', width: 24, height: 24);
    } else if (value == 0 || value == false) {
      iconWidget = SvgPicture.asset('assets/icons/tidak_dipilih.svg',
          width: 24, height: 24);
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
          Text(title,
              style: bodyTextStyle(context).copyWith(color: primaryLightColor)),
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
