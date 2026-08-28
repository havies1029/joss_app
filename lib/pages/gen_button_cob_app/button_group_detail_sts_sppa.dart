import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gen_detail_sts_sppa/mdetailstssppacari_bloc.dart';
import 'package:joss_app/common/constants.dart';

import '../../common/loading_indicator.dart';
import '../../widgets/apptheme/build_status_box.dart';

class ButtonGroupDetailStsSppaWidget extends StatefulWidget {
  const ButtonGroupDetailStsSppaWidget({super.key});

  @override
  State<ButtonGroupDetailStsSppaWidget> createState() =>
      _ButtonGroupDetailStsSppaWidgetState();
}

class _ButtonGroupDetailStsSppaWidgetState
    extends State<ButtonGroupDetailStsSppaWidget> {
  @override
  void initState() {
    super.initState();
    final state = context.read<MDetailStsSppaCariBloc>().state;
    if (state.status == ListStatus.initial && state.items.isEmpty) {
      context
          .read<MDetailStsSppaCariBloc>()
          .add(RefreshMDetailStsSppaCariEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MDetailStsSppaCariBloc, MDetailStsSppaCariState>(
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
          return const Text(
            "Gagal memuat data",
            style: TextStyle(color: Colors.red),
          );
        }

        if (state.status == ListStatus.success) {
          if (state.items.isEmpty) return const SizedBox.shrink();

          if (state.selectedDetailStsSppaId.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              context.read<MDetailStsSppaCariBloc>().add(
                    SelectMDetailStsSppaButton(
                      state.items.first.mdetailstssppaId,
                    ),
                  );
            });
          }

          final items = state.items;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: items.asMap().entries.map((entry) {
                final i = entry.key;
                final status = entry.value;

                final id = status.mdetailstssppaId;
                final isSelected = state.selectedDetailStsSppaId == id;

                return Padding(
                  padding:
                      EdgeInsets.only(right: i < items.length - 1 ? 10 : 0),
                  child: StatusChip(
                    statusId: id,
                    label: status.statusNama,
                    isSelected: isSelected,
                    onTap: () {
                      context
                          .read<MDetailStsSppaCariBloc>()
                          .add(SelectMDetailStsSppaButton(id));
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
