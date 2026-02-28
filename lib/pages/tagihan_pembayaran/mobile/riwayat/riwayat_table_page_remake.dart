import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/payment/historybayarcari_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/payment/historybayarcari_model.dart';
import 'package:joss_app/pages/payment/mobile/riwayat/table_widgets/riwayat_table_compact.dart';
import 'package:joss_app/pages/payment/mobile/riwayat/table_widgets/riwayat_table_normal.dart';

class RiwayatTablePageRemake extends StatefulWidget {
  final String searchText;
  const RiwayatTablePageRemake({super.key, required this.searchText});

  @override
  State<RiwayatTablePageRemake> createState() => _RiwayatTablePageRemakeState();
}

class _RiwayatTablePageRemakeState extends State<RiwayatTablePageRemake> {
  final ScrollController _vController = ScrollController();
  final ScrollController _hController = ScrollController();
  bool _fetchLock = false;

  @override
  void initState() {
    super.initState();
    _vController.addListener(_onScroll);
  }

void _onScroll() {
  if (!_vController.hasClients) return;

  final bloc = context.read<HistorybayarCariBloc>();
  final state = bloc.state;

  if (state.hasReachedMax) return;

  // kalau bloc masih loading, jangan trigger dan buka lock lagi
  if (state.isLoading) {
    _fetchLock = false;
    return;
  }

  final nearBottom = _vController.position.extentAfter < 200;

  // ✅ near bottom dan lock belum aktif
  if (nearBottom && !_fetchLock) {
    _fetchLock = true;
    bloc.add(FetchHistorybayarCariEvent());
  }

  // ✅ kalau sudah menjauh dari bottom, reset lock supaya bisa fetch lagi nanti
  if (!nearBottom) {
    _fetchLock = false;
  }
}

  @override
  void dispose() {
    _vController.dispose();
    _hController.dispose();
    super.dispose();
  }

  void _onTapRow(HistorybayarCariModel item) {
    context.read<HistorybayarCariBloc>().add(SelectHistorybayarCariEvent(selected: item));
    // panggil open detail kamu di sini kalau mau
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 900;

    return BlocBuilder<HistorybayarCariBloc, HistorybayarCariState>(
      buildWhen: (p, c) =>
          p.status != c.status ||
          p.items != c.items ||
          p.isLoaded != c.isLoaded, // ✅ supaya indikator muncul
      builder: (context, state) {
        if (state.status != ListStatus.success) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.items.isEmpty) {
          return const Center(child: Text("No Data Available!!"));
        }

        return SingleChildScrollView(
          controller: _vController,
          child: Column(
            children: [
              isNarrow
                  ? RiwayatTableCompact(
                      items: state.items,
                      //hController: _hController,
                      onTap: _onTapRow,
                    )
                  : RiwayatTableNormal(
                      items: state.items,
                      onTap: _onTapRow,
                    ),
              const SizedBox(height: 16),
              if (state.isLoading == true)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        );
      },
    );
  }
}