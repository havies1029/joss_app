import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/klaimringkas/klaimringkascari_bloc.dart';
import 'package:joss_app/blocs/klaimringkas/mstatusringkascari_bloc.dart';
import 'package:joss_app/widgets/apptheme/build_status_box.dart';

class KlaimRingkasanStatusWidget extends StatelessWidget {
  const KlaimRingkasanStatusWidget({super.key});

  // ✅ hardcode 3 status (sesuaikan id dengan backend kamu)
  static const _statuses = <Map<String, String>>[
    {"id": "10", "label": "Berjalanx"},
    {"id": "20", "label": "Selesai"},
    {"id": "30", "label": "Batal"},
  ];

  @override
  Widget build(BuildContext context) {
    final selectedId = context.select<MstatusringkasCariBloc, String>(
      (b) => b.state.selectedStatusId,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _statuses.map((s) {
          final id = s["id"]!;
          final label = s["label"]!;
          final isSelected = id == selectedId;

          return Row(
            children: [
              StatusChip(
                statusId: id,
                height: 30,
                label: label,
                isSelected: isSelected,
                onTap: () {
                  // set selected status
                  context.read<MstatusringkasCariBloc>().add(
                        SelectedIdChanged(id),
                      );

                  // ✅ opsional: langsung refresh data list klaim sesuai status
                  context.read<KlaimringkasCariBloc>().add(
                        RefreshKlaimringkasCariEvent(selectedStatusId: id),
                      );
                },
              ),
              const SizedBox(width: 8),
            ],
          );
        }).toList(),
      ),
    );
  }
}