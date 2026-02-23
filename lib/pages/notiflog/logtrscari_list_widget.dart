import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/notiflog/logtrscari_bloc.dart';
import 'package:joss_app/pages/notiflog/logtrscari_tile_widget.dart';

class LogtrscariListWidget extends StatefulWidget {
  final String activeGroupLogId; // "" / "10" / "20"
  const LogtrscariListWidget({super.key, required this.activeGroupLogId});

  @override
  State<LogtrscariListWidget> createState() => _LogtrscariListWidgetState();
}

class _LogtrscariListWidgetState extends State<LogtrscariListWidget> {
  late LogtrscariBloc logtrscariBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logtrscariBloc = BlocProvider.of<LogtrscariBloc>(context);

    return BlocBuilder<LogtrscariBloc, LogtrscariState>(
      builder: (context, state) {
        if (state.status == ListStatus.initial && state.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == ListStatus.success && state.items.isEmpty) {
          return const Center(
            child: Text(
              "No Data Available!!",
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
            ),
          );
        }

        // group by groupBulan
        final groups = <String, List<dynamic>>{};
        for (final it in state.items) {
          groups.putIfAbsent(it.groupBulan, () => []);
          groups[it.groupBulan]!.add(it);
        }
        final keys = groups.keys.toList();

        return ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          itemCount: keys.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, i) {
            final bulan = keys[i];
            final items = groups[bulan]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 2, bottom: 10),
                  child: Text(
                    bulan,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF3A3A3A), width: 1),
                  ),
                  child: Column(
                    children: List.generate(items.length, (idx) {
                      final item = items[idx];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: LogtrscariTileWidget(
                              jenisLog: item.jenisLog,
                              status: item.status,
                              tglDibuat: item.tglDibuat,
                              groupBulan: item.groupBulan,
                              amount1: item.amount1,
                              curr: item.curr,
                              remark1: item.remark1,
                              groupLogId: item.groupLogId,
                            ),
                          ),
                          if (idx != items.length - 1)
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.white.withOpacity(0.06),
                            ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    const threshold = 200.0;
    final max = _scrollController.position.maxScrollExtent;
    final cur = _scrollController.position.pixels;

    if (max - cur <= threshold) {
      // Ideal: fetch bawa filter aktif
      // Kalau event kamu sudah ada param groupLogId, gunakan:
      // logtrscariBloc.add(FetchLogtrscariEvent(groupLogId: widget.activeGroupLogId));

      logtrscariBloc.add(FetchLogtrscariEvent());
    }
  }
}
