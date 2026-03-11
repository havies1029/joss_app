
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/payment/invbayarvaform_bloc.dart';
import 'package:intl/intl.dart';

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

  final fieldBatasBayarController =
      TextEditingController(text: DateTime.now().toIso8601String());
  final fieldVaNoController = TextEditingController();
  final fieldTotalBayarController = TextEditingController();
  final fieldCurrController = TextEditingController();

  @override
  void initState() {
    super.initState();
    invbayarvaFormBloc = context.read<InvbayarvaFormBloc>();
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

    fieldBatasBayarController.dispose();
    fieldVaNoController.dispose();
    fieldTotalBayarController.dispose();
    fieldCurrController.dispose();
    super.dispose();
  }

  void _dismissDialog() {
    context.read<InvbayarvaFormBloc>().add(const InvbayarvaPollingStopped());
    Navigator.pop(context);
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
                    "Keluar dari Pembayaran?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryLightColor,
                      fontSize: getResponsiveFont(context, 18),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Jika Anda keluar dari halaman metode pembayaran, data transaksi akan tersimpan di menu Riwayat Pembayaran.",
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
                                borderRadius: BorderRadius.circular(cardBorderRadius),
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
                                borderRadius: BorderRadius.circular(cardBorderRadius),
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
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const TagihanPembayaranPage(initialTab: 2),
        ),
            (route) => route.isFirst,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleExit(context);
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<InvbayarvaFormBloc, InvbayarvaFormState>(
            listenWhen: (prev, curr) =>
            prev.record != curr.record && curr.record != null,
            listener: (context, state) {
              final r = state.record!;

              fieldVaNoController.text = (r.vaNo).toString();
              fieldCurrController.text = (r.curr).toString();
              final formatter = NumberFormat('#,###', 'id_ID');
              fieldTotalBayarController.text = formatter.format(r.totalBayar);
              fieldBatasBayarController.text = (r.batasBayar).toString();
            },
          ),
        ],
        child: BlocBuilder<InvbayarvaFormBloc, InvbayarvaFormState>(
          buildWhen: (prev, curr) =>
          prev.record != curr.record ||
              prev.isPollingVa != curr.isPollingVa ||
              prev.isPollingStatus != curr.isPollingStatus,
          builder: (context, state) {
            final bankTitle = (state.record?.bankNama ?? '').trim();
            final title = bankTitle.isNotEmpty ? bankTitle : "Pembayaran";

            return BaseBackgroundSidePage(
              title: title,
              onBack: () async => _handleExit(context),
              child: Container(
                color: secondaryBlackColor,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

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

                        const SizedBox(height: 12),

                        _buildPaymentStatus(state),

                        const SizedBox(height: 6),
                        buildFieldTotalBayar(),
                        const SizedBox(height: 8),
                        buildFieldVaNo(),
                        const SizedBox(height: 18),
                        buildFieldBatasBayar(),
                        const SizedBox(height: 18),
                        buildInstruksiPembayaran(state),
                        const SizedBox(height: hPadding),

                        AppButton.primary(
                          text: "Kembali",
                          onPressed: () => _handleExit(context),
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
    );
  }

  // ================== STATUS WIDGET ==================

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
              "Pembayaran Berakhir pada:",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: hintGrey),
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
                      successSnackBar("Nomor Virtual Account Berhasil Disalin!"),
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
                  Text("${item.urutan}. ", style: bodyTextStyle(context)),
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
