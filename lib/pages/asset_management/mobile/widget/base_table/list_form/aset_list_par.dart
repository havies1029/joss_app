import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import '../../../../../../blocs/gen_aset_par/asetparcari_bloc.dart';
import '../../../../../../blocs/share_cubit/share_par_state_cubit.dart';
import '../../../../../../models/gen_aset_par/asetparcari_model.dart';
import '../tables/reusable_aset_table.dart';

class AsetListPar extends StatelessWidget {
  final String searchText;
  const AsetListPar({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShareParStateCubit>();

    return ReusableAsetTable<
        AsetParCariBloc,
        AsetParCariState,
        AsetParCariModel>(
      bloc: context.read<AsetParCariBloc>(),
      cubit: cubit,
      getItems: (state) => state.items,
      getStatus: (state) => state.status,
      getItemId: (item) => item.asetParId,
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth(),
        3: IntrinsicColumnWidth(),
        4: IntrinsicColumnWidth(),
        5: IntrinsicColumnWidth(),
        6: IntrinsicColumnWidth(),
        7: IntrinsicColumnWidth(),
        8: IntrinsicColumnWidth(),
        9: IntrinsicColumnWidth(),
        10: IntrinsicColumnWidth(),
        11: IntrinsicColumnWidth(),
      },
      headerCells: const [
        _HeaderCell("No", center: true),
        _HeaderCell("Alamat"),
        _HeaderCell("ID Aset PAR"),
        _HeaderCell("Currency"),
        _HeaderCell("Klausula Bank"),
        _HeaderCell("Rekan ID"),
        _HeaderCell("Polis No"),
        _HeaderCell("Sum Insured"),
        _HeaderCell("Premi"),
        _HeaderCell("Status", center: true),
        _HeaderCell("Aksi"),
      ],
      rowBuilder: (context, item, rowNumber, cubit) => [
        _CellText("$rowNumber", center: true),
        _CellText(item.alamat),
        _CellText(item.asetParId),
        _CellText(item.curr),
        _CellText(item.klausulaBank),
        _CellText(item.mrekanId),
        _CellText(item.polisNo),
        _CellText(
          NumberFormat.currency(locale: 'id', symbol: 'IDR ')
              .format(item.sumInsured),
        ),
        _CellText(
          NumberFormat.currency(locale: 'id', symbol: 'IDR ')
              .format(item.premi),
        ),
        _CellText(item.status, center: true),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton(
                asset: 'assets/icons/btn_endorse.svg',
                bgColor: const Color(0xFFFDC13C), // kuning
                onTap: () {},
              ),
              _buildActionButton(
                asset: 'assets/icons/btn_delete.svg',
                bgColor: const Color(0xFFF85B5B), // merah
                onTap: () {},
              ),
              _buildActionButton(
                asset: 'assets/icons/btn_lacak.svg',
                bgColor: const Color(0xFFB9B9B9), // abu
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 🔹 Tombol aksi di kolom paling kanan
  Widget _buildActionButton({
    required String asset,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 5,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            asset,
            width: 16,
            height: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ✅ Komponen teks tabel (header & cell)
class _HeaderCell extends StatelessWidget {
  final String text;
  final bool center;
  const _HeaderCell(this.text, {this.center = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: center ? Alignment.center : Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: getResponsiveFont(context, 16),
          color: primaryLightColor,
        ),
      ),
    );
  }
}

class _CellText extends StatelessWidget {
  final String text;
  final bool center;
  const _CellText(this.text, {this.center = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: center ? Alignment.center : Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: getResponsiveFont(context, 14),
          color: primaryLightColor,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
