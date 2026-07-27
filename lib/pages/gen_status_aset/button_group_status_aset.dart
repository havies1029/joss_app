import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gen_status_aset/statusasetcari_bloc.dart';
import 'package:joss_app/common/constants.dart';

import '../../widgets/apptheme/build_status_box.dart';
import '../../common/loading_indicator.dart';

class ButtonGroupStatusAsetWidget extends StatefulWidget {
  const ButtonGroupStatusAsetWidget({super.key});

  @override
  State<ButtonGroupStatusAsetWidget> createState() =>
      _ButtonGroupStatusAsetWidgetState();
}

class _ButtonGroupStatusAsetWidgetState
    extends State<ButtonGroupStatusAsetWidget> {
  @override
  void initState() {
    super.initState();
    final state = context.read<StatusAsetCariBloc>().state;
    if (state.status == ListStatus.initial && state.items.isEmpty) {
      context.read<StatusAsetCariBloc>().add(RefreshStatusAsetCariEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatusAsetCariBloc, StatusAsetCariState>(
      builder: (context, state) {
        if (state.status == ListStatus.initial) {
          return const SizedBox(
            height: 44,
            child: Align(
              alignment: Alignment.centerLeft,
              child: LoadingIndicator(),
            ),
          );
        }

        if (state.status == ListStatus.failure) {
          return const Text("Gagal memuat data",
              style: TextStyle(color: Colors.red));
        }

        if (state.status == ListStatus.success) {
          if (state.items.isEmpty) return const SizedBox.shrink();

          // default select: pilih yang pertama (sekali, aman)
          if (state.selectedStatusId.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              context.read<StatusAsetCariBloc>().add(
                    SelectStatusAsetButton(state.items.first.mstatusasetId),
                  );
            });
          }

          final allowedIds = {"10001", "10002", "10003", "10004"};

          final items = state.items
              .where((e) => allowedIds.contains(e.mstatusasetId))
              .toList();

          String statusNama(String id) {
            switch (id) {
              case "10001":
                return "Aktif";
              case "10003":
                return "Non Aktif";
              case "10002":
                return "Diproses";
              case "10004":
                return "Jatuh Tempo";
              default:
                return "";
            }
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: items.asMap().entries.map((entry) {
                final i = entry.key;
                final status = entry.value;

                final id = status.mstatusasetId;
                final isSelected = state.selectedStatusId == id;

                return Padding(
                  padding:
                      EdgeInsets.only(right: i < items.length - 1 ? 10 : 0),
                  child: StatusChip(
                    statusId: id,
                    label: statusNama(id),
                    isSelected: isSelected,
                    onTap: () {
                      context
                          .read<StatusAsetCariBloc>()
                          .add(SelectStatusAsetButton(id));
                    },
                  ),
                );
              }).toList(),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
