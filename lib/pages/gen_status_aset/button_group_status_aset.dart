import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gen_status_aset/statusasetcari_bloc.dart';
import 'package:joss_app/common/constants.dart';

import '../../widgets/apptheme/build_status_box.dart';

// pastiin StatusType & StatusChip ke-import

class ButtonGroupStatusAsetWidget extends StatefulWidget {
  const ButtonGroupStatusAsetWidget({super.key});

  @override
  State<ButtonGroupStatusAsetWidget> createState() => _ButtonGroupStatusAsetWidgetState();
}

class _ButtonGroupStatusAsetWidgetState extends State<ButtonGroupStatusAsetWidget> {
  @override
  void initState() {
    super.initState();
    context.read<StatusAsetCariBloc>().add(RefreshStatusAsetCariEvent());
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
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (state.status == ListStatus.failure) {
          return const Text("Error: Loading failed", style: TextStyle(color: Colors.red));
        }

        if (state.status == ListStatus.success) {
          if (state.items.isEmpty) return const SizedBox.shrink();

          // default select: pilih yang pertama (sekali, aman)
          if (state.selectedStatusId.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              context.read<StatusAsetCariBloc>().add(
                SelectButton(state.items.first.mstatusasetId),
              );
            });
          }

          // urutan sesuai desain (kalau ada di items)
          final order = ["Semua", "Aktif", "Non Aktif", "Diproses", "Berakhir", "Jatuh Tempo"];
          final items = [...state.items]..sort((a, b) {
            final ia = order.indexOf(a.statusNama);
            final ib = order.indexOf(b.statusNama);
            return (ia == -1 ? 999 : ia).compareTo(ib == -1 ? 999 : ib);
          });

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: items.asMap().entries.map((entry) {
                final i = entry.key;
                final status = entry.value;

                final id = status.mstatusasetId;
                final isSelected = state.selectedStatusId == id;

                final type = StatusType.fromId(id);

                return Padding(
                  padding: EdgeInsets.only(right: i < items.length - 1 ? 10 : 0),
                  child: StatusChip(
                    assetPath: type?.asset ?? "assets/icons/no_data.svg", // fallback
                    label: status.statusNama,
                    iconColor: type?.color ?? sGrey,
                    isSelected: isSelected,
                    onTap: () {
                      context.read<StatusAsetCariBloc>().add(SelectButton(id));
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
