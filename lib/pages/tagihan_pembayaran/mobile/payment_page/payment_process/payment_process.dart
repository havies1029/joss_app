import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/helper/ios_left_edge_swipe.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/payment/invbayarvaform_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../blocs/dashboard/sumdash_bloc.dart';
import '../../../../../blocs/notiflog/logtrscaritopx_bloc.dart';
import '../../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../../common/loading_indicator.dart';
import '../../../../../helper/navigation_keys.dart';
import '../../../../../widgets/payment/bank_logo_widget.dart';
import '../../../../base/base_background_sidepage.dart';
import '../../../tagihan_pembayaran_page.dart';

//micky 2026-02-27

class PaymentProcess extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const PaymentProcess({
    super.key,
    required this.viewMode,
    required this.recordId,
  });

  @override
  PaymentProcessFormState createState() => PaymentProcessFormState();
}

class PaymentProcessFormState extends State<PaymentProcess> {
  late final InvbayarvaFormBloc invbayarvaFormBloc;

  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  Timer? _countdownTimer;
  DateTime _now = DateTime.now();

  final fieldBatasBayarController =
      TextEditingController(text: DateTime.now().toIso8601String());
  final fieldVaNoController = TextEditingController();
  final fieldTotalBayarController = TextEditingController();
  final fieldCurrController = TextEditingController();

  @override
  void initState() {
    super.initState();

    invbayarvaFormBloc = context.read<InvbayarvaFormBloc>();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (widget.viewMode == "ubah") {
        invbayarvaFormBloc.add(
          InvbayarvaPollingStarted(
            invoiceId: widget.recordId,
            interval: const Duration(seconds: 4),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    invbayarvaFormBloc.add(const InvbayarvaPollingStopped());
    _countdownTimer?.cancel();

    fieldBatasBayarController.dispose();
    fieldVaNoController.dispose();
    fieldTotalBayarController.dispose();
    fieldCurrController.dispose();

    super.dispose();
  }

  String formatCountdown(DateTime? batasBayar) {
    if (batasBayar == null) return "-";

    final diff = batasBayar.difference(_now);
    if (diff.isNegative) return "00:00:00";

    final hours = diff.inHours.toString().padLeft(2, '0');
    final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');

    return "$hours:$minutes:$seconds";
  }

  void _refreshHeaderData() {
    context.read<SumdashBloc>().add(SumdashLihatEvent());
    context.read<LogtrscaritopxBloc>().add(RefreshLogtrscaritopxEvent());
  }

  Future<bool?> showLeavePaymentDialog(BuildContext context) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Tutup",
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              decoration: BoxDecoration(
                color: formGrey,
                borderRadius: BorderRadius.circular(cardBorderRadius),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/icons/Information2.svg',
                    width: 40,
                    height: 40,
                    colorFilter: const ColorFilter.mode(
                      primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: hPadding),
                  const Text(
                    "Keluar dari Pembayaran?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: primaryLightColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Pembayaran Anda belum selesai. Jika keluar dari halaman ini, Anda dapat melanjutkan pembayaran kapan saja melalui menu Riwayat Pembayaran selama pembayaran masih berlaku.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.35,
                      color: dGrey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton.primary(
                          text: "Lanjutkan Pembayaran",
                          backgroundColor: sGrey,
                          borderside: const BorderSide(color: sGrey),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 5),
                          textStyle: const TextStyle(
                            fontSize: 16,
                          ),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppButton.primary(
                          text: "Iya, Keluar",
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 5),
                          textStyle: const TextStyle(
                            fontSize: 16,
                          ),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      ),
                    ],
                  )
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

  Future<bool?> showCancelPaymentDialog(BuildContext context) {
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
                    "Batalkan Pembayaran?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryLightColor,
                      fontSize: getResponsiveFont(context, 18),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Pembayaran yang dibatalkan tidak dapat dilanjutkan kembali. Anda dapat membuat pembayaran baru kapan saja.",
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
                                borderRadius: BorderRadius.circular(
                                  cardBorderRadius,
                                ),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(
                              "Kembali",
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
                                borderRadius: BorderRadius.circular(
                                  cardBorderRadius,
                                ),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              context.read<DnRekap2invBloc>().add(
                                    BatalInvByIdEvent(
                                      invoiceId: widget.recordId,
                                    ),
                                  );

                              Navigator.pop(context, true);
                            },
                            child: Text(
                              "Iya, Batal",
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

  Future<void> _handleBackExit(BuildContext context) async {
    final shouldLeave = await showLeavePaymentDialog(context);

    if (shouldLeave == true) {
      _refreshHeaderData();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const TagihanPembayaranPage(initialTab: 2),
        ),
        (route) => route.isFirst,
      );
    }
  }

  Future<void> _handleHomeExit(BuildContext context) async {
    final shouldLeave = await showLeavePaymentDialog(context);

    if (shouldLeave == true) {
      _refreshHeaderData();
      final homeState = homeTabKey.currentState;

      if (homeState != null) {
        homeState.goToHeroPage();
      }

      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Future<void> _handleCancelPayment(BuildContext context) async {
    await showCancelPaymentDialog(context);

    // Tidak perlu navigasi di sini.
    // Setelah BatalInvByIdEvent sukses dan status 91 diterima,
    // listener parent yang akan arahkan ke PaymentSuccess.
  }

  @override
  Widget build(BuildContext context) {
    return IosLeftEdgeSwipe(
      onSwipeBack: () async {
        await _handleBackExit(context);
      },
      child: PopScope(
        canPop: Platform.isAndroid ? false : true,
        onPopInvokedWithResult: (didPop, result) async {
          if (Platform.isIOS) return;
          if (didPop) return;
          await _handleBackExit(context);
        },
        child: MultiBlocListener(
          listeners: [
            BlocListener<InvbayarvaFormBloc, InvbayarvaFormState>(
              listenWhen: (prev, curr) =>
                  prev.record != curr.record && curr.record != null,
              listener: (context, state) {
                final r = state.record!;

                fieldVaNoController.text = r.vaNo.toString();
                fieldCurrController.text = r.curr.toString();

                final formatter = NumberFormat('#,###', 'id_ID');
                fieldTotalBayarController.text = formatter.format(r.totalBayar);

                fieldBatasBayarController.text = r.batasBayar.toString();
              },
            ),
          ],
          child: BlocBuilder<InvbayarvaFormBloc, InvbayarvaFormState>(
            builder: (context, state) {
              if (state.isInitialLoading) {
                return const Scaffold(
                  backgroundColor: secondaryBlackColor,
                  body: Center(child: LoadingIndicator()),
                );
              }

              final bankNama = state.record?.bankNama ?? "-";

              return BaseBackgroundSidePage(
                title: bankNama,
                onBack: () => _handleBackExit(context),
                onHome: () => _handleHomeExit(context),
                child: Container(
                  color: secondaryBlackColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: hPadding * 1.5,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: hPadding),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: primaryLightColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(cardBorderRadius),
                              ),
                            ),
                            width: 120,
                            height: 60,
                            alignment: Alignment.center,
                            child: buildBankLogo(
                              state.record?.iconId ?? '',
                              state.record?.iconUrl ?? '',
                              size: 120,
                            ),
                          ),
                          const SizedBox(height: hPadding),
                          _buildPaymentStatus(state),
                          const SizedBox(height: hPadding),
                          buildFieldTotalBayar(),
                          const SizedBox(height: hPadding),
                          buildFieldVaNo(),
                          const SizedBox(height: hPadding),
                          buildFieldBatasBayar(),
                          const SizedBox(height: hPadding),
                          buildInstruksiPembayaran(state),
                          const SizedBox(height: hPadding),
                          AppButton.iconLeft(
                            text: 'Batal Pembayaran',
                            backgroundColor: redPayment,
                            icon: SvgPicture.asset(
                              'assets/icons/gg_trash.svg',
                              width: 18,
                              height: 18,
                            ),
                            onPressed: () => _handleCancelPayment(context),
                          ),
                          FormError(errors: errors, key: null),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentStatus(InvbayarvaFormState state) {
    final r = state.record;

    final va = (r?.vaNo ?? '').toString().trim();
    final status = (r?.paymentStatus ?? '').toString().trim().toUpperCase();

    if (r == null) {
      return _badge(
        icon: Icons.hourglass_bottom,
        text: "Memuat data pembayaran...",
        color: primaryColor,
      );
    }

    // Menunggu VA
    if (va.isEmpty && state.isPollingVa) {
      return _badge(
        icon: Icons.hourglass_bottom,
        text: "Menunggu Nomor Virtual Account...",
        color: primaryColor,
      );
    }

    // VA sudah ada, menunggu pembayaran
    if (va.isNotEmpty && state.isPollingStatus && status != "PAID") {
      return _badge(
        icon: Icons.hourglass_bottom,
        text: "Menunggu Pembayaran",
        color: primaryColor,
      );
    }

    // Paid
    if (status == "PAID") {
      return _badge(
        icon: Icons.check_circle,
        text: "Pembayaran Berhasil",
        color: Colors.green,
      );
    }

    // Expired
    if (status == "EXPIRED") {
      return _badge(
        icon: Icons.error,
        text: "Pembayaran Kadaluarsa",
        color: Colors.red,
      );
    }

    // Default
    return _badge(
      icon: Icons.hourglass_bottom,
      text: "Menunggu Pembayaran",
      color: primaryColor,
    );
  }

  Widget _badge({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: pGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius),
          border: Border.all(color: sGrey),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(fontSize: 14, color: color),
            ),
          ],
        ),
      ),
    );
  }

  // ================== FIELD WIDGETS ==================

  Widget buildFieldBatasBayar() {
    final batasBayar = DateTime.tryParse(fieldBatasBayarController.text);

    final batasBayarText = batasBayar == null
        ? "-"
        : DateFormat('dd/MM/yyyy HH:mm:ss').format(batasBayar);

    final countdownText = formatCountdown(batasBayar);

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
          color: pGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius),
          border: Border.all(color: sGrey),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Sisa Waktu Pembayaran",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: hintGrey),
            ),
            const SizedBox(height: 4),
            Text(
              countdownText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, color: redPayment),
            ),
            const SizedBox(height: 4),
            Text(
              batasBayarText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: primaryLightColor),
            ),
          ],
        ),
      ),
    );
  }

  String formatVa4(String input) {
    final digitsOnly = input.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digitsOnly.length; i++) {
      if (i != 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digitsOnly[i]);
    }

    return buffer.toString().trim();
  }

  Widget buildFieldVaNo() {
    final rawVa = fieldVaNoController.text.trim();
    final digitsOnly = rawVa.replaceAll(RegExp(r'\D'), '');
    final formattedVa = formatVa4(rawVa);

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Nomor Virtual Account:",
            textAlign: TextAlign.center,
            style: bodyTextStyle(context),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  digitsOnly.isEmpty ? "-" : formattedVa,
                  style: bodyTextStyle(context),
                ),
                const SizedBox(width: hPadding),
                InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () async {
                    if (digitsOnly.isEmpty) return;

                    await Clipboard.setData(ClipboardData(text: digitsOnly));
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      successSnackBar(
                          "Nomor Virtual Account Berhasil Disalin!"),
                    );
                  },
                  child: const Icon(Icons.copy, color: Colors.white, size: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFieldTotalBayar() {
    final curr = fieldCurrController.text.trim();
    final totalRaw = fieldTotalBayarController.text.trim();

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Total Pembayaran:",
            style: TextStyle(fontSize: 16, color: hintGrey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                curr.isEmpty ? "-" : curr,
                style: headingStyle(context, fontSize: 24),
              ),
              const SizedBox(width: 2),
              Text(
                totalRaw.isEmpty ? "-" : totalRaw,
                style: headingStyle(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInstruksiPembayaran(InvbayarvaFormState state) {
    final instruksi = state.record?.instruksi ?? [];

    if (instruksi.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: pGrey,
        border: Border.all(color: sGrey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Instruksi Pembayaran:",
            style: bodyTextStyle(context),
          ),
          ...instruksi.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${item.nomor} ", style: bodyTextStyle(context)),
                  Expanded(
                    child: Text(item.tahapDesc, style: bodyTextStyle(context)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
