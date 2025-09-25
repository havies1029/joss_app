import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';

class DetailPremiPage extends StatelessWidget {
  const DetailPremiPage({super.key});

  Widget _buildRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: bodyTextStyle(
              context,
              fontSize: 16,
            ).copyWith(color: hintGrey),
          ),
          Text(value, style: bodyTextStyle(context, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildRiwayat(
    BuildContext context,
    String tanggal,
    String nominal,
    String status,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tanggal,
            style: bodyTextStyle(
              context,
              fontSize: 16,
            ).copyWith(color: hintGrey),
          ),
          Text(nominal, style: bodyTextStyle(context, fontSize: 16)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status, style: bodyTextStyle(context, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Detail Premi",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SvgPicture.asset("assets/icons/detail_premi.svg"),
            const SizedBox(height: 23),
            // Ringkasan Premi
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
              decoration: BoxDecoration(
                color: pGrey,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: sGrey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Ringkasan Premi", style: bodyTextStyle(context)),
                  const SizedBox(height: 5),
                  kDivider(color: sGrey),
                  const SizedBox(height: 5),
                  _buildRow(context, "Total Premi:", "IDR 10.500.000.000"),
                  _buildRow(
                    context,
                    "Metode Pembayaran:",
                    "Virtual Account BCA",
                  ),
                  _buildRow(
                    context,
                    "Status Pembayaran:",
                    "Belum Bayar",
                    valueColor: pRed,
                  ),
                  _buildRow(context, "Jatuh Tempo:", "23/09/2025"),
                  const SizedBox(height: 6),
                  AppButton.primary(
                    text: "Bayar Sekarang",
                    onPressed: () {
                      // TODO: Aksi bayar
                    },
                    height: 33,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Riwayat Pembayaran
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
              decoration: BoxDecoration(
                color: pGrey,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: sGrey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Riwayat Pembayaran",
                    style: bodyTextStyle(context),
                  ),
                  const SizedBox(height: 5),
                  kDivider(color: sGrey),
                  const SizedBox(height: 5),
                  _buildRiwayat(
                    context,
                    "23/06/2025",
                    "IDR 4.500.000",
                    "Berhasil",
                    pGreen,
                  ),
                  _buildRiwayat(
                    context,
                    "23/07/2025",
                    "IDR 4.500.000",
                    "Berhasil",
                    pGreen,
                  ),
                  _buildRiwayat(
                    context,
                    "23/08/2025",
                    "IDR 4.500.000",
                    "Berhasil",
                    pGreen,
                  ),
                  _buildRiwayat(
                    context,
                    "23/09/2025",
                    "IDR 4.500.000",
                    "Belum Bayar",
                    pRed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
