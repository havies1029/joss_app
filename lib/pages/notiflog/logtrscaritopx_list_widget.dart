import 'package:joss_app/blocs/notiflog/logtrscaritopx_bloc.dart';
import 'package:joss_app/pages/notiflog/logtrscari_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';

class LogtrscaritopxListWidget extends StatelessWidget {
  const LogtrscaritopxListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogtrscaritopxBloc, LogtrscaritopxState>(
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

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          itemCount: state.items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final item = state.items[i];

            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF3A3A3A), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: LogtrscariTileWidget(
                  jenisLog: item.jenisLog,
                  status: item.status,
                  tglDibuat: item.tglDibuat,
                  groupBulan: item.groupBulan, // optional kalau tile masih perlu
                  amount1: item.amount1,
                  curr: item.curr,
                  remark1: item.remark1,
                  groupLogId: item.groupLogId,
                ),
              ),
            );
          },
        );
      },
    );
  }
}