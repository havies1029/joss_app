import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/klaimrinci/mstatusrincicari_bloc.dart';
import 'package:joss_app/widgets/apptheme/build_status_box.dart';

class KlaimRincianStatusWidget extends StatefulWidget {
  const KlaimRincianStatusWidget({super.key});

  @override
  State<KlaimRincianStatusWidget> createState() =>
      _KlaimRincianStatusWidgetState();
}

class _KlaimRincianStatusWidgetState extends State<KlaimRincianStatusWidget> {
  late MstatusrinciCariBloc mstatusrinciCariBloc;

  @override
  void initState() {
    super.initState();

    mstatusrinciCariBloc = context.read<MstatusrinciCariBloc>();
    mstatusrinciCariBloc.add(RefreshMstatusrinciCariEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MstatusrinciCariBloc, MstatusrinciCariState>(
      buildWhen: (previous, current) {
        return current.status == ListStatus.success ||
            previous.selectedStatusId != current.selectedStatusId;
      },
      listener: (context, state) {},
      builder: (context, state) {
        if (state.status != ListStatus.success || state.items.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 40,
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: state.items.map((item) {
                        final id = item.mgroupstatusclaimId;
                        final isSelected = id == state.selectedStatusId;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: StatusChip(
                            statusId: id,
                            height: 30,
                            label: item.groupNama,
                            isSelected: isSelected,
                            onTap: () {
                              context.read<MstatusrinciCariBloc>().add(
                                SelectedIdChanged(id),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}