import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/common/constants.dart';
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

  String _getStarsText() => '-' * 6;

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
          currency: record?.curr ?? 'Rp',
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Premi',
                      style: bodyTextStyle(context, fontSize: 16),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(opacity: animation, child: child),
                          child: _isPremiumVisible
                              ? Text(
                            isLoading ? '...' : premiumAmount,
                            key: const ValueKey('visible'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: headingStyle(context),
                          )
                              : Text(
                            _getStarsText(),
                            key: const ValueKey('stars'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: headingStyle(context),
                          ),
                        ),
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
                    ),
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
                  Text(
                    isLoading ? '...' : polisCount.toString(),
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