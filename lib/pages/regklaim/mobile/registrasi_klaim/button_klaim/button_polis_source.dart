import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/constants.dart';
import '../../../../../../blocs/regklaim/polissourcecari_bloc.dart';
import '../../../../../../models/regklaim/polissourcecari_model.dart';
import '../../../../../common/loading_indicator.dart';

class ButtonPolisSourceWidget extends StatefulWidget {
  const ButtonPolisSourceWidget({super.key});

  @override
  State<ButtonPolisSourceWidget> createState() =>
      _ButtonPolisSourceWidgetState();
}

class _ButtonPolisSourceWidgetState extends State<ButtonPolisSourceWidget> {
  String? _pressedPolissourceId;

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
          final items = _supportedItems(state.items);
          if (items.isEmpty) return const SizedBox.shrink();

          final hasSelectedItem = items.any(
            (e) => e.polissourceId == state.selectedPolissourceId,
          );

          if (!hasSelectedItem) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              context.read<PolissourcecariBloc>().add(
                    SelectPolissourcecariEvent(
                      polissourceId: items.first.polissourceId,
                    ),
                  );
            });
          }

          if (items.length == 1) {
            return const SizedBox.shrink();
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(items.length, (index) {
                final item = items[index];
                final isSelected =
                    state.selectedPolissourceId == item.polissourceId;
                final isPressed = _pressedPolissourceId == item.polissourceId;

                return Padding(
                  padding: EdgeInsets.only(
                    right: index == items.length - 1 ? 0 : hPadding,
                  ),
                  child: GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _pressedPolissourceId = item.polissourceId;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        _pressedPolissourceId = null;
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        _pressedPolissourceId = null;
                      });
                    },
                    onTap: () {
                      if (state.selectedPolissourceId != item.polissourceId) {
                        context.read<PolissourcecariBloc>().add(
                              SelectPolissourcecariEvent(
                                polissourceId: item.polissourceId,
                              ),
                            );
                      }
                    },
                    child: AnimatedScale(
                      scale: isPressed ? 0.97 : 1,
                      duration: const Duration(milliseconds: 120),
                      curve: Curves.easeOut,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? primaryColor : pGrey,
                          borderRadius:
                              BorderRadius.circular(cardBorderRadius),
                        ),
                        child: Text(
                          item.sourceNama,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: bodyTextStyle(context).copyWith(
                            color:
                                isSelected ? Colors.white : primaryLightColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  List<PolissourcecariModel> _supportedItems(
    List<PolissourcecariModel> items,
  ) {
    final result = <PolissourcecariModel>[];

    for (final sourceId in const ["10", "20"]) {
      final matches = items.where((e) => e.polissourceId == sourceId);
      if (matches.isNotEmpty) {
        result.add(matches.first);
      }
    }

    return result;
  }
}
