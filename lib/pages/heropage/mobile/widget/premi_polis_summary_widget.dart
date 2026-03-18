import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/loading_indicator.dart';
import '../../../../blocs/dashboard/sumdash_bloc.dart';

class PremiPolisSummaryWidget extends StatefulWidget {
  final String userType;
  final VoidCallback? onDetailTap;

  const PremiPolisSummaryWidget({
    super.key,
    required this.userType,
    this.onDetailTap,
  });

  @override
  State<PremiPolisSummaryWidget> createState() => _PremiPolisSummaryWidgetState();
}

class _PremiPolisSummaryWidgetState extends State<PremiPolisSummaryWidget> {
  bool _isPremiumVisible = false;

  String _getStarsText(amount) => '*' * amount.length;

  @override
  Widget build(BuildContext context) {
    final String mjnsclientId = AppData.user.cstType;

    if (widget.userType != 'C' || mjnsclientId != '10') {
      return const SizedBox.shrink();
    }

    return BlocSelector<SumdashBloc, SumdashState, _SummaryVM>(
      selector: (state) {
        final record = state.record;

        return _SummaryVM(
          isLoading: state.isLoading,
          currency: record?.curr ?? '',
          polisCount: record?.jmlpolis ?? 0,
          totalPremi: record?.totalpremi ?? 0,
        );
      },
      builder: (context, vm) {
        final formattedPremi = _formatCurrency(vm.currency, vm.totalPremi);

        return _buildCard(
          context,
          premiumAmount: formattedPremi,
          polisCount: vm.polisCount,
          isLoading: vm.isLoading,
        );
      },
    );
  }

  Widget _buildCard(
      BuildContext context, {
        required String premiumAmount,
        required int polisCount,
        required bool isLoading,
      }) {
    final parts = premiumAmount.split(' ');
    final currency = parts.isNotEmpty ? parts.first : '';
    final amount = parts.length > 1 ? parts.sublist(1).join(' ') : premiumAmount;

    return IntrinsicHeight(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: pGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius * 1.6),
          border: Border.all(color: sGrey),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===== PREMI =====
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: hPadding + 6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Premi',
                      style: bodyTextStyle(context, fontSize: 16),
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          currency,
                          style: headingStyle(context).copyWith(
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),

                        const SizedBox(width: 4),

                        IntrinsicWidth(
                          child: isLoading
                              ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: LoadingIndicator(),
                          )
                              : AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(opacity: animation, child: child),
                            child: (amount.isEmpty)
                                ? const SizedBox(height: 22) // placeholder supaya ruang tetap ada
                                : (_isPremiumVisible
                                ? Text(
                              amount,
                              key: const ValueKey('visible'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: headingStyle(context).copyWith(
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                            )
                                : Text(
                              _getStarsText(amount),
                              key: const ValueKey('stars'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: headingStyle(context).copyWith(
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                            )),
                          ),
                        ),

                        if (!isLoading) ...[
                          const SizedBox(width: 4),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: GestureDetector(
                              onTap: () => setState(() {
                                _isPremiumVisible = !_isPremiumVisible;
                              }),
                              child: Icon(
                                _isPremiumVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off_outlined,
                                color: primaryColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ],
                    )
                  ],
                ),
              ),
            ),

            // Divider
            Container(width: 1, color: sGrey),

            // ===== POLIS =====
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Polis',
                    textAlign: TextAlign.center,
                    style: bodyTextStyle(context, fontSize: 16),
                  ),
                  const SizedBox(height: 2),

                  isLoading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: LoadingIndicator(),
                  )
                      : Text(
                    polisCount.toString(),
                    textAlign: TextAlign.center,
                    style: headingStyle(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(String curr, double value) {
    // Format simple tanpa package intl (biar aman dulu)
    final formatted = value.toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');

    return '$curr $formatted';
  }
}

class _SummaryVM {
  final bool isLoading;
  final String currency;
  final int polisCount;
  final double totalPremi;

  const _SummaryVM({
    required this.isLoading,
    required this.currency,
    required this.polisCount,
    required this.totalPremi,
  });
}