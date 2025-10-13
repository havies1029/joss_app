import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/blocs/gen_dn1/dn1cari_bloc.dart';
import 'package:joss_app/models/gen_dn1/dn1cari_model.dart';

class DetailPremiPage extends StatefulWidget {
  final String sppa1Id;
  const DetailPremiPage({super.key, required this.sppa1Id});

  @override
  State<DetailPremiPage> createState() => _DetailPremiPageState();
}

class _DetailPremiPageState extends State<DetailPremiPage> {
  late Dn1CariBloc dn1Bloc;
  final _currency = NumberFormat.currency(locale: 'id', symbol: 'IDR ', decimalDigits: 0);
  final _dateFmt = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    dn1Bloc = context.read<Dn1CariBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dn1Bloc.add(RefreshDn1CariEvent(sppa1Id: widget.sppa1Id));
    });
  }

  Widget _buildRow(BuildContext context, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: bodyTextStyle(context, fontSize: 16)
                  .copyWith(color: hintGrey)),
          Text(value,
              style: bodyTextStyle(context, fontSize: 16)
                  .copyWith(color: valueColor)),
        ],
      ),
    );
  }

  Widget _buildRiwayat(BuildContext context, Dn1CariModel item) {
    final status = item.stsLunas.toLowerCase() == 'lunas' ? 'Berhasil' : 'Belum Bayar';
    final color = status == 'Berhasil' ? pGreen : pRed;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(_dateFmt.format(item.jthTempo),
              style: bodyTextStyle(context, fontSize: 16).copyWith(color: hintGrey)),
          Text(_currency.format(item.dnNilai), style: bodyTextStyle(context, fontSize: 16)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
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
      child: BlocBuilder<Dn1CariBloc, Dn1CariState>(
        builder: (context, state) {
          if (state.status == ListStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ListStatus.failure) {
            return const Center(
              child: Text(
                "Gagal memuat data premi.",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            );
          }

          final dnItems = state.items.where((e) => e.sppa1Id == widget.sppa1Id).toList();
          if (dnItems.isEmpty) {
            return const Center(child: Text("Belum ada data DN untuk premi ini"));
          }

          final totalPremi = dnItems.fold<double>(0.0, (sum, e) => sum + e.dnNilai);
          final belumLunas = dnItems.any((e) => e.stsLunas.toLowerCase() != 'lunas');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SvgPicture.asset("assets/icons/detail_premi.svg"),
                const SizedBox(height: 23),

                // === RINGKASAN PREMI ===
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
                      _buildRow(context, "Total Premi:", _currency.format(totalPremi)),
                      _buildRow(context, "Metode Pembayaran:", "Virtual Account BCA"),
                      _buildRow(
                        context,
                        "Status Pembayaran:",
                        belumLunas ? "Belum Lunas" : "Lunas",
                        valueColor: belumLunas ? pRed : pGreen,
                      ),
                      _buildRow(context, "Jatuh Tempo:",
                          _dateFmt.format(dnItems.last.jthTempo)),
                      const SizedBox(height: 6),
                      AppButton.primary(
                        text: "Bayar Sekarang",
                        onPressed: () {
                          // TODO: panggil Bloc event untuk update status pembayaran
                        },
                        height: 33,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // === RIWAYAT PEMBAYARAN ===
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
                      Text("Riwayat Pembayaran", style: bodyTextStyle(context)),
                      const SizedBox(height: 5),
                      kDivider(color: sGrey),
                      const SizedBox(height: 5),
                      ...dnItems.map((e) => _buildRiwayat(context, e)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
