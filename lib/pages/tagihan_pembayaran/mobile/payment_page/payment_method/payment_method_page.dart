import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:joss_app/helper/ios_left_edge_swipe.dart';
import '../../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../../blocs/payment/invoicestatuscard_bloc.dart';
import '../../../../../blocs/payment/paymentmethodcari_bloc.dart';
import '../../../../../blocs/payment/paymentmethodcari_event.dart';
import '../../../../../blocs/payment/paymentmethodcari_state.dart';
import '../../../../../common/constants.dart';
import '../../../../../helper/creditcard_inputformatter.dart';
import '../../../../../helper/navigation_keys.dart';
import '../../../../../models/payment/paymentcard_model.dart';
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

  final fieldNomorKartuController = TextEditingController();

  DateTime? fieldMasaBerlakuKartu;

  String get expiryMonth => fieldMasaBerlakuKartu == null
      ? ''
      : fieldMasaBerlakuKartu!.month.toString().padLeft(2, '0');

  String get expiryYear => fieldMasaBerlakuKartu == null
      ? ''
      : fieldMasaBerlakuKartu!.year.toString();

  final fieldCvnController = TextEditingController();
  final fieldNamaDepanPemilikKartuController = TextEditingController();
  final fieldNamaBelakangPemilikKartuController = TextEditingController();

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
    fieldNomorKartuController.dispose();
    fieldCvnController.dispose();
    fieldNamaDepanPemilikKartuController.dispose();
    fieldNamaBelakangPemilikKartuController.dispose();
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

  Future<void> _handleHomeExit(BuildContext context) async {
    final shouldLeave = await showExitConfirmDialog(context);

    if (shouldLeave == true) {
      final homeState = homeTabKey.currentState;

      if (homeState != null) {
        homeState.goToHeroPage();
      }

      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DnRekap2invBloc, DnRekap2invState>(
      builder: (context, dnState) {
        final busy = dnState.isProcessing;

        return IosLeftEdgeSwipe(
          onSwipeBack: () async {
            if (busy) return;
            await _handleExit(context);
          },
          child: PopScope(
            canPop: Platform.isAndroid ? false : true,
            onPopInvokedWithResult: (didPop, result) async {
              if (Platform.isIOS) return;
              if (didPop) return;
              await _handleExit(context);
            },
            child: BaseBackgroundSidePage(
              onBack: () {
                if (busy) return;
                _handleExit(context);
              },
              onHome: () {
                if (busy) return;
                _handleHomeExit(context);
              },
              title: "Metode Pembayaran",
              child: Stack(
                children: [
                  Container(
                    color: secondaryBlackColor,
                    padding:
                        const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                    child: Column(
                      children: [
                        Expanded(
                          child: BlocBuilder<PaymentMethodCariBloc,
                              PaymentMethodCariState>(
                            builder: (context, state) {
                              if (state.isLoading) {
                                return const Center(child: LoadingIndicator());
                              }

                              if (state.hasError) {
                                return const Center(
                                  child: Text("Gagal memuat metode pembayaran"),
                                );
                              }

                              final categories = [...state.categories]..sort(
                                  (a, b) => (a.sortOrder ?? 0)
                                      .compareTo(b.sortOrder ?? 0),
                                );

                              return ScrollbarTheme(
                                data: ScrollbarThemeData(
                                  thumbVisibility:
                                      WidgetStateProperty.all(false),
                                  trackVisibility:
                                      WidgetStateProperty.all(false),
                                  thickness: WidgetStateProperty.all(5),
                                  radius:
                                      const Radius.circular(cardBorderRadius),
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
                                            separatorBuilder: (_, __) =>
                                                Divider(
                                              height: 1,
                                              color: sGrey.withOpacity(0.5),
                                            ),
                                            itemBuilder: (context, index) {
                                              final cat = categories[index];
                                              final icon =
                                                  _categoryIconBySortOrder(
                                                cat.sortOrder,
                                              );

                                              final isCreditCard =
                                                  cat.categoryId.toString() ==
                                                      '20';

                                              return PaymentList(
                                                iconPath: icon,
                                                categoryName: cat.categoryName,
                                                items: cat.items,
                                                isExpanded:
                                                    _expandedIndex == index,
                                                isCreditCard: isCreditCard,
                                                creditCardForm:
                                                    buildFormKartuKredit(),
                                                onTapHeader: () {
                                                  if (busy) return;

                                                  if (_expandedIndex != index) {
                                                    context
                                                        .read<
                                                            PaymentMethodCariBloc>()
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
                        BlocBuilder<PaymentMethodCariBloc,
                            PaymentMethodCariState>(
                          builder: (context, state) {
                            return BlocSelector<InvoiceStatusCardBloc,
                                InvoiceStatusCardState, bool>(
                              selector: (cardState) => cardState.isLoading,
                              builder: (context, cardLoading) {
                                final sortedCategories = [...state.categories]
                                  ..sort((a, b) => (a.sortOrder ?? 0)
                                      .compareTo(b.sortOrder ?? 0));

                                final isCreditCardExpanded = _expandedIndex !=
                                        null &&
                                    _expandedIndex! < sortedCategories.length &&
                                    sortedCategories[_expandedIndex!]
                                            .categoryId
                                            .toString() ==
                                        '20';

                                final canShowButton = isCreditCardExpanded ||
                                    state.selectedMethodId != null;

                                if (!canShowButton) {
                                  return const SizedBox.shrink();
                                }

                                final submitBusy = busy || cardLoading;

                                return AppButton.primary(
                                  text: "Konfirmasi",
                                  isLoading: submitBusy,
                                  backgroundColor: submitBusy
                                      ? secondaryBlackColor
                                      : primaryColor,
                                  onPressed: submitBusy
                                      ? null
                                      : () {
                                          if (submitBusy) return;

                                          if (isCreditCardExpanded) {
                                            final ok =
                                                validateFormKartuKredit();
                                            if (!ok) return;
                                          }

                                          _onLanjutkanPressed(
                                            isCreditCard: isCreditCardExpanded,
                                          );
                                        },
                                );
                              },
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
          ),
        );
      },
    );
  }

  Widget buildFormKartuKredit() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: hPadding * 1.5,
        vertical: vPadding,
      ),
      child: Column(
        children: [
          buildFieldNomorKartu(),
          const SizedBox(height: hPadding),
          buildFieldNamaDepanPemilikKartu(),
          const SizedBox(height: hPadding),
          buildFieldNamaBelakangPemilikKartu(),
          const SizedBox(height: hPadding),
          Row(
            children: [
              Expanded(
                flex: 7,
                child: buildFieldMasaBerlakuKartu(),
              ),
              const SizedBox(width: hPadding),
              Expanded(
                flex: 3,
                child: buildFieldCvn(),
              ),
            ],
          )
        ],
      ),
    );
  }

  bool validateFormKartuKredit() {
    bool ok = true;

    setState(() {
      fieldErrors.removeWhere((key, value) => key.startsWith('kartuKredit.'));

      final nomorKartu = fieldNomorKartuController.text.trim();
      final cvn = fieldCvnController.text.trim();
      final namaDepan = fieldNamaDepanPemilikKartuController.text.trim();
      final namaBelakang = fieldNamaBelakangPemilikKartuController.text.trim();

      if (nomorKartu.length < 12) {
        setErr('kartuKredit.nomorKartu', kStringNullError);
        ok = false;
      }

      if (namaDepan.isEmpty) {
        setErr('kartuKredit.namaDepan', kStringNullError);
        ok = false;
      }

      if (namaBelakang.isEmpty) {
        setErr('kartuKredit.namaBelakang', kStringNullError);
        ok = false;
      }

      if (fieldMasaBerlakuKartu == null) {
        setErr('kartuKredit.masaBerlaku', kStringNullError);
        ok = false;
      }

      if (cvn.length < 3) {
        setErr('kartuKredit.cvn', kStringNullError);
        ok = false;
      }
    });

    return ok;
  }

  void _onLanjutkanPressed({
    required bool isCreditCard,
  }) {
    FocusManager.instance.primaryFocus?.unfocus();

    final dnState = context.read<DnRekap2invBloc>().state;

    if (isCreditCard) {
      context.read<InvoiceStatusCardBloc>().add(
            InvToBayarViaCardEvent(
              invoiceId: dnState.invoiceId,
              cardNumber: fieldNomorKartuController.text.replaceAll(' ', ''),
              expiryMonth: expiryMonth,
              expiryYear: expiryYear,
              cvn: fieldCvnController.text.trim(),
              cardholderFirstName:
                  fieldNamaDepanPemilikKartuController.text.trim(),
              cardholderLastName:
                  fieldNamaBelakangPemilikKartuController.text.trim(),
            ),
          );
      return;
    }

    final methodState = context.read<PaymentMethodCariBloc>().state;
    final selectedId = methodState.selectedMethodId;

    if (selectedId == null) return;

    context.read<DnRekap2invBloc>().add(
          Invoice2PaymentViaVAEvent(
            invoiceId: dnState.invoiceId,
            methodId: selectedId,
          ),
        );
  }

  Widget buildFieldNomorKartu() => appTextField(
        label: "Nomor Kartu Kredit",
        controller: fieldNomorKartuController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(19), // max 19 digit kartu
          CreditCardInputFormatter(),
        ],
        errorText: err('kartuKredit.nomorKartu'),
        validator: (_) => err('kartuKredit.nomorKartu'),
        onChanged: (v) {
          if (v.trim().isNotEmpty) {
            clearErr('kartuKredit.nomorKartu');
          }
        },
      );

  // Widget buildFieldBulanKedaluwarsa() => appTextField(
  //   label: "Bulan Kedaluwarsa",
  //   controller: fieldBulanKedaluwarsaController,
  //   keyboardType: TextInputType.number,
  //   inputFormatters: [
  //     FilteringTextInputFormatter.digitsOnly,
  //     LengthLimitingTextInputFormatter(2),
  //   ],
  //   errorText: err('kartuKredit.bulanKedaluwarsa'),
  //   validator: (_) => err('kartuKredit.bulanKedaluwarsa'),
  //   onChanged: (v) {
  //     if (v.trim().isNotEmpty) clearErr('kartuKredit.bulanKedaluwarsa');
  //   },
  // );
  //
  // Widget buildFieldTahunKedaluwarsa() => appTextField(
  //   label: "Tahun Kedaluwarsa",
  //   controller: fieldTahunKedaluwarsaController,
  //   keyboardType: TextInputType.number,
  //   inputFormatters: [
  //     FilteringTextInputFormatter.digitsOnly,
  //     LengthLimitingTextInputFormatter(4),
  //   ],
  //   errorText: err('kartuKredit.tahunKedaluwarsa'),
  //   validator: (_) => err('kartuKredit.tahunKedaluwarsa'),
  //   onChanged: (v) {
  //     if (v.trim().isNotEmpty) clearErr('kartuKredit.tahunKedaluwarsa');
  //   },
  // );

  Widget buildFieldMasaBerlakuKartu() => AppDateField(
        label: "Masa Berlaku Kartu",
        initialValue: fieldMasaBerlakuKartu,
        firstDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
        lastDate: DateTime(DateTime.now().year + 15, 12, 1),
        mode: AppDateFieldMode.monthYear,
        errorText: err('kartuKredit.masaBerlaku'),
        validator: (_) => err('kartuKredit.masaBerlaku'),
        onChanged: (dt) {
          setState(() {
            fieldMasaBerlakuKartu = dt;
            if (dt != null) {
              fieldErrors.remove('kartuKredit.masaBerlaku');
            }
          });
        },
      );

  Widget buildFieldCvn() => appTextField(
        label: "CVN",
        controller: fieldCvnController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
        ],
        errorText: err('kartuKredit.cvn'),
        validator: (_) => err('kartuKredit.cvn'),
        onChanged: (v) {
          if (v.trim().isNotEmpty) clearErr('kartuKredit.cvn');
        },
      );

  Widget buildFieldNamaDepanPemilikKartu() => appTextField(
        label: "Nama Depan",
        controller: fieldNamaDepanPemilikKartuController,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
        ],
        errorText: err('kartuKredit.namaDepan'),
        validator: (_) => err('kartuKredit.namaDepan'),
        onChanged: (v) {
          if (v.trim().isNotEmpty) clearErr('kartuKredit.namaDepan');
        },
      );

  Widget buildFieldNamaBelakangPemilikKartu() => appTextField(
        label: "Nama Belakang",
        controller: fieldNamaBelakangPemilikKartuController,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
        ],
        errorText: err('kartuKredit.namaBelakang'),
        validator: (_) => err('kartuKredit.namaBelakang'),
        onChanged: (v) {
          if (v.trim().isNotEmpty) clearErr('kartuKredit.namaBelakang');
        },
      );

  final Map<String, String?> fieldErrors = {};
  String? err(String key) => fieldErrors[key];

  void setErr(String key, String? msg) {
    setState(() => fieldErrors[key] = msg);
  }

  void clearErr(String key) {
    if (!fieldErrors.containsKey(key)) return;
    setState(() => fieldErrors.remove(key));
  }

  void clearErrsByPrefix(String prefix) {
    setState(() {
      fieldErrors.removeWhere((k, _) => k.startsWith(prefix));
    });
  }
}
