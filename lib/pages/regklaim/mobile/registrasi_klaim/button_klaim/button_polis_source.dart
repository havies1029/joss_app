import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/constants.dart';
import '../../../../../../blocs/regklaim/polissourcecari_bloc.dart';
import '../../../../../common/loading_indicator.dart';

class ButtonPolisSourceWidget extends StatefulWidget {
  const ButtonPolisSourceWidget({super.key});

  @override
  State<ButtonPolisSourceWidget> createState() => _ButtonPolisSourceWidgetState();
}

class _ButtonPolisSourceWidgetState extends State<ButtonPolisSourceWidget> {
  @override
  void initState() {
    super.initState();
    context.read<PolissourcecariBloc>().add(RefreshPolissourcecariEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PolissourcecariBloc, PolissourcecariState>(
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
          final items = state.items;
          if (items.isEmpty) return const SizedBox.shrink();

          if (state.selectedPolissourceId.isEmpty) {
            final hasDefault10 = items.any((e) => e.polissourceId == "10");
            final defaultId = hasDefault10 ? "10" : items.first.polissourceId;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              context.read<PolissourcecariBloc>().add(
                SelectPolissourcecariEvent(polissourceId: defaultId),
              );
            });
          }

          return Wrap(
            spacing: hPadding,
            runSpacing: hPadding,
            children: items.map((item) {
              final isSelected = state.selectedPolissourceId == item.polissourceId;

              return SizedBox(
                width: (MediaQuery.of(context).size.width -
                    (hPadding * 1.5 * 2) -
                    hPadding) /
                    2,
                child: AppButton.primary(
                  text: item.sourceNama,
                  backgroundColor: isSelected ? primaryColor : formGrey,
                  textColor: primaryLightColor,
                  borderRadius: cardBorderRadius,
                  elevation: 0,
                  isOutlined: false,
                  onPressed: () {
                    context.read<PolissourcecariBloc>().add(
                      SelectPolissourcecariEvent(
                        polissourceId: item.polissourceId,
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
