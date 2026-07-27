import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gen_cob_app/cobmanpol_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/loading_indicator.dart';

class ButtonGroupCobAsetWidget extends StatefulWidget {
  const ButtonGroupCobAsetWidget({super.key});

  @override
  State<ButtonGroupCobAsetWidget> createState() =>
      _ButtonGroupCobAsetWidgetState();
}

class _ButtonGroupCobAsetWidgetState extends State<ButtonGroupCobAsetWidget> {
  @override
  void initState() {
    super.initState();
    final state = context.read<CobManPolBloc>().state;
    if (state.status == ListStatus.initial && state.items.isEmpty) {
      context.read<CobManPolBloc>().add(RefreshCobManPolEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = headingStyle(context, fontSize: 14);
    final Color chipSelected = primaryColor;
    final double radius = cardBorderRadius;

    return BlocBuilder<CobManPolBloc, CobManPolState>(
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
          final filteredItems = state.items.toList();

          if (filteredItems.isEmpty) {
            return const Center(child: Text("Data tidak ditemukan"));
          }

          if (state.selectedCOBId.isEmpty) {
            context
                .read<CobManPolBloc>()
                .add(SelectCobButton(filteredItems.first.mCobApp1Id));
          }

          final chips = filteredItems.map((cob) {
            final bool selected = state.selectedCOBId == cob.mCobApp1Id;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                backgroundColor: pGrey,
                label: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 180),
                  child: Text(
                    cob.cobNama,
                    style: textStyle.copyWith(
                      color: selected ? Colors.white : primaryLightColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
                selected: selected,
                selectedColor: chipSelected,
                showCheckmark: false,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                ),
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                onSelected: (_) {
                  context
                      .read<CobManPolBloc>()
                      .add(SelectCobButton(cob.mCobApp1Id));
                },
              ),
            );
          }).toList();

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: chips),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
