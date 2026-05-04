import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/loading_indicator.dart';
import '../../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../../blocs/payment/paymentmethodcari_bloc.dart';
import '../../../../../blocs/payment/paymentmethodcari_event.dart';
import '../../../../../blocs/payment/paymentmethodcari_state.dart';
import '../../../../../common/constants.dart';
import '../../../../base/base_background_sidepage.dart';
import '../../../tagihan_pembayaran_page.dart';
import 'payment_list.dart';

class PaymentMethodPage extends StatefulWidget {
  final String curr;
  final double totalBayar;

  const PaymentMethodPage({
    super.key,
    required this.curr,
    required this.totalBayar,
  });

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  int? _expandedIndex;
  late final ScrollController _scrollCtrl;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController();

    context.read<PaymentMethodCariBloc>().add(PaymentResetSelectedEvent());
    context.read<PaymentMethodCariBloc>().add(PaymentMethodCariLoadEvent());
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  String _categoryIconBySortOrder(int? sortOrder) {
    switch (sortOrder) {
      case 10:
        return 'assets/icons/va.svg';
      case 20:
        return 'assets/icons/ewallet.svg';
      case 30:
        return 'assets/icons/cc.svg';
      default:
        return 'assets/icons/va.svg'; // fallback
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
                    "Keluar dari Metode Pembayaran?",
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
    return BlocBuilder<DnRekap2invBloc, DnRekap2invState>(
      builder: (context, dnState) {
        final busy = dnState.isProcessing;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            await _handleExit(context);
          },
          child: BaseBackgroundSidePage(
            onBack: () {
              if (busy) return;
              _handleExit(context);
            },
            onHome:  () {
              if (busy) return;
              _handleExit(context);
            },
            title: "Metode Pembayaran",
            child: Stack(
              children: [
                Container(
                  color: secondaryBlackColor,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    children: [
                      Expanded(
                        child: BlocBuilder<PaymentMethodCariBloc, PaymentMethodCariState>(
                          builder: (context, state) {
                            if (state.isLoading) {
                              return const Center(child: LoadingIndicator());
                            }

                            if (state.hasError) {
                              return const Center(
                                child: Text("Gagal memuat metode pembayaran"),
                              );
                            }

                            final categories = [...state.categories]
                              ..sort(
                                    (a, b) =>
                                    (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0),
                              );

                            return ScrollbarTheme(
                              data: ScrollbarThemeData(
                                thumbVisibility: WidgetStateProperty.all(false),
                                trackVisibility: WidgetStateProperty.all(false),
                                thickness: WidgetStateProperty.all(5),
                                radius: const Radius.circular(cardBorderRadius),
                                thumbColor: WidgetStateProperty.all(
                                  scrollBar.withOpacity(0.1),
                                ),
                              ),
                              child: Scrollbar(
                                controller: _scrollCtrl,
                                child: SingleChildScrollView(
                                  controller: _scrollCtrl,
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: pGrey,
                                          borderRadius: BorderRadius.circular(
                                            cardBorderRadius,
                                          ),
                                          border: Border.all(color: sGrey),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Total Pembayaran:",
                                              style: inputTextStyle(context),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "${widget.curr} ${NumberFormat("#,###").format(widget.totalBayar)}",
                                              style: headingStyle(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: pGrey,
                                          borderRadius: BorderRadius.circular(
                                            cardBorderRadius,
                                          ),
                                          border: Border.all(color: sGrey),
                                        ),
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                          const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemCount: categories.length,
                                          separatorBuilder: (_, __) => Divider(
                                            height: 1,
                                            color: sGrey.withOpacity(0.5),
                                          ),
                                          itemBuilder: (context, index) {
                                            final cat = categories[index];
                                            final icon = _categoryIconBySortOrder(
                                              cat.sortOrder,
                                            );

                                            return PaymentList(
                                              iconPath: icon,
                                              categoryName: cat.categoryName,
                                              items: cat.items,
                                              isExpanded: _expandedIndex == index,
                                              onTapHeader: () {
                                                if (busy) return;

                                                if (_expandedIndex != index) {
                                                  context
                                                      .read<PaymentMethodCariBloc>()
                                                      .add(
                                                    PaymentResetSelectedEvent(),
                                                  );
                                                }

                                                setState(() {
                                                  _expandedIndex =
                                                  _expandedIndex == index
                                                      ? null
                                                      : index;
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      BlocBuilder<PaymentMethodCariBloc, PaymentMethodCariState>(
                        builder: (context, state) {
                          if (state.selectedMethodId == null) {
                            return const SizedBox.shrink();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: AppButton.primary(
                              text: "Lanjutkan",
                              onPressed: busy ? null : _onLanjutkanPressed,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                if (busy)
                  Positioned.fill(
                    child: AbsorbPointer(
                      absorbing: true,
                      child: Container(
                        color: Colors.black.withOpacity(0.35),
                        child: const Center(
                          child: LoadingIndicator(),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onLanjutkanPressed() {
    FocusManager.instance.primaryFocus?.unfocus();
    final methodState = context.read<PaymentMethodCariBloc>().state;
    final selectedId = methodState.selectedMethodId;
    if (selectedId == null) return;

    final dnState = context.read<DnRekap2invBloc>().state;

    context.read<DnRekap2invBloc>().add(
      Invoice2PaymentViaVAEvent(
        invoiceId: dnState.invoiceId,
        methodId: selectedId,
      ),
    );
  }
}

