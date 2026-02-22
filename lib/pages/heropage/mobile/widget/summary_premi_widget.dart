import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PremiPolisCard extends StatelessWidget {
  final String currency;   
  final num amount;       
  final int polisCount;   
  final VoidCallback? onTap;

  const PremiPolisCard({
    super.key,
    required this.currency,
    required this.amount,
    required this.polisCount,
    this.onTap,
  });

  String _formatMoney(String currency, num amount) {
    // Format 1) special untuk "Rp" pakai pemisah ribuan Indonesia
    if (currency.trim().toUpperCase() == 'RP') {
      final f = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
      return f.format(amount);
    }

    // Format 2) kalau currency lain, tampilkan "CUR 1.234.567"
    // (pakai pemisah Indonesia biar konsisten UI)
    final f = NumberFormat.decimalPattern('id_ID');
    return '${currency.trim()} ${f.format(amount)}';
  }

  @override
  Widget build(BuildContext context) {
    final amountText = _formatMoney(currency, amount);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2B2B2B), Color(0xFF1E1E1E)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SizedBox(
            height: 76,
            child: Row(
              children: [
                // LEFT (Premi + Amount + CTA)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Premi',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                amountText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2C94C),
                                borderRadius: BorderRadius.circular(99),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFF2C94C).withOpacity(0.35),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          'Lihat Detail >',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.55),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // DIVIDER
                Container(
                  width: 1,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.white.withOpacity(0.08),
                ),

                // RIGHT (Polis + Count)
                SizedBox(
                  width: 86,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Polis',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.70),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          polisCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}