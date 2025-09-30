import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
import 'package:joss_app/models/gen_aset_ringkasan/asetringkasancari_model.dart';

// ⬅️ pastikan StatusBox udah lo bikin class kayak sebelumnya
import '../../../../../../widgets/apptheme/build_status_box.dart';

class AsetListRingkasan extends StatelessWidget {
  final String searchText;
  const AsetListRingkasan({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AsetRingkasanCariBloc, AsetRingkasanCariState>(
      listener: (context, state) {},
      buildWhen: (prev, curr) =>
      prev.status != curr.status || prev.items != curr.items,
      builder: (context, state) {
        if (state.status == ListStatus.initial) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          );
        }

        if (state.status == ListStatus.success && state.items.isNotEmpty) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: hPadding, vertical: vPadding),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return _AsetRingkasanCard(item: item);
            },
          );
        }

        return const Center(
          child: Text(
            "No Data Available!!",
            style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
class _AsetRingkasanCard extends StatelessWidget {
  final AsetRingkasanCariModel item;
  const _AsetRingkasanCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: sGrey, width: 1),
      ),
      child: Column(
        children: [
          // 🔹 StatusBox paling atas
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: const [
                StatusBox(
                    assetPath: "assets/icons/edit_icon_polis.svg",
                    bgColor: Colors.green),
                SizedBox(width: hPadding),
                StatusBox(
                    assetPath: "assets/icons/delete_icon_polis.svg",
                    bgColor: Colors.orange),
                SizedBox(width: hPadding),
                StatusBox(
                    assetPath: "assets/icons/others_icon_polis.svg",
                    bgColor: Colors.red),
              ],
            ),
          ),
          _divider(), // ⬅️ Divider setelah action bar

          // 🔹 Semua data ditampilkan
          _buildDetailRow(context, "Nama Aset", item.asetNama),
          _divider(),
          _buildDetailRow(context, "ID Ringkasan", item.asetRingkasanId),
          _divider(),
          _buildDetailRow(context, "Currency", item.curr),
          _divider(),
          _buildDetailRow(context, "Jumlah",
              "${item.jmlAset} ${item.satuan}"), // jml + satuan
          _divider(),
          _buildDetailRow(
            context,
            "Nilai",
            NumberFormat.currency(locale: 'id', symbol: 'IDR ')
                .format(item.nilaiAset),
          ),
          _divider(),
          _buildDetailRow(
            context,
            "Premi",
            NumberFormat.currency(locale: 'id', symbol: 'IDR ')
                .format(item.nilaiPremi),
          ),
          _divider(),
          _buildDetailRow(context, "Nomor Urut", "${item.noUrut}"),
          _divider(),
          _buildDetailRow(context, "Satuan", item.satuan),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110, // 🔹 fix lebar kolom label biar rata
            child: Text(
              label,
              style: TextStyle(
                color: hintGrey,
                fontSize: getResponsiveFont(context, 16),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: getResponsiveFont(context, 16),
                color: primaryLightColor,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(height: 1, color: sGrey.withOpacity(0.4));
  }
}
