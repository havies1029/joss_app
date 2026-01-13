import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gen_status_aset/statusasetcari_bloc.dart';
import 'package:joss_app/common/constants.dart';

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
          return const Text(
            "Error: Loading failed",
            style: TextStyle(color: Colors.red),
          );
        }

        if (state.status == ListStatus.success) {
          if (state.items.isEmpty) {
            return const Center(child: Text("No items found"));
          }

          if (state.selectedStatusId.isEmpty) {
            context.read<StatusAsetCariBloc>().add(SelectButton(state.items.first.mstatusasetId));
          }

          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.items.map((status) {
              final bool selected = state.selectedStatusId == status.mstatusasetId;

              return ChoiceChip(
                label: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 160),
                  child: Text(
                    status.statusNama,
                    style: headingStyle(context, fontSize: 13).copyWith( // ✅ lebih kecil dari COB (14)
                      color: selected ? Colors.white : primaryLightColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
                selected: selected,
                selectedColor: primaryColor,
                backgroundColor: pGrey,
                showCheckmark: false,

                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                ),

                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3, 
                ),

                onSelected: (_) {
                  context.read<StatusAsetCariBloc>().add(SelectButton(status.mstatusasetId));
                },
              );
            }).toList(),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
