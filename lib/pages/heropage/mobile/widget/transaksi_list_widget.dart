import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';

class TransaksiListWidget extends StatelessWidget {
  const TransaksiListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: hPadding * 1.5,
        vertical: vPadding,
      ),
      decoration: BoxDecoration(color: secondaryBlackColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icons/transaksi.svg",
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Transaksi',
                style: headingStyle(context).copyWith(fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 13),
          _transaksiWidget(context),
        ],
      ),
    );
  }

  Widget _transaksiWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: sGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(hPadding),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: sGrey, width: 0.5)),
            ),
            child: Text(
              "Transaksi terbaru",
              style: bodyTextStyle(context, fontSize: 20),
            ),
          ),
          // Item Transaksi
          ...items.map((item) => _buildTransactionItem(context, item)).toList(),
          Padding(
            padding: const EdgeInsets.all(hPadding),
            child: AppButton.primary(
              backgroundColor: secondaryBlackColor,
              text: "Lihat Semua Transaksi  ›",
              onPressed: () {
                // TODO: Aksi lihat semua
              },
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    return Container(
      padding: const EdgeInsets.all(hPadding),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: sGrey, width: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(item["icon"], width: 40, height: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["title"],
                  style: bodyTextStyle(context, fontSize: 20),
                ),
                Text(
                  "${item["date"]}   ${item["time"]}",
                  style: bodyTextStyle(
                    context,
                    fontSize: 16,
                  ).copyWith(color: hintGrey),
                ),
              ],
            ),
          ),
          // Jumlah & status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(item["amount"], style: bodyTextStyle(context)),
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: pGreen,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  item["status"],
                  style: bodyTextStyle(context, fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> items = [
  {
    "icon": "assets/icons/pembayaran_premi.svg",
    "title": "Pembayaran Premi",
    "amount": "Rp 750.000",
    "status": "Berhasil",
    "date": "10 Agu 2025",
    "time": "11:21 AM",
  },
  {
    "icon": "assets/icons/klaim_asuransi.svg",
    "title": "Klaim Asuransi",
    "amount": "Rp 250.000",
    "status": "Berhasil",
    "date": "9 Agu 2025",
    "time": "10:22 AM",
  },
  {
    "icon": "assets/icons/tagihan_pembayaran.svg",
    "title": "Tagihan dan Pembayaran",
    "amount": "Rp 2.350.000",
    "status": "Berhasil",
    "date": "2 Agu 2025",
    "time": "16:01",
  },
  {
    "icon": "assets/icons/pembayaran_premi.svg",
    "title": "Pembayaran Premi",
    "amount": "Rp 750.000",
    "status": "Berhasil",
    "date": "1 Juli 2025",
    "time": "14:00",
  },
];
