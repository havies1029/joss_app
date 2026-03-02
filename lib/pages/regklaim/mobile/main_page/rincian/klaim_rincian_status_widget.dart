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
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      mstatusrinciCariBloc.add(RefreshMstatusrinciCariEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    mstatusrinciCariBloc = BlocProvider.of<MstatusrinciCariBloc>(context);

    return BlocConsumer<MstatusrinciCariBloc, MstatusrinciCariState>(
      buildWhen: (previous, current) {
        return (current.status == ListStatus.success) ||
            (previous.selectedStatusId != current.selectedStatusId);
      },
      listener: (context, state) {},
      builder: (context, state) {

        if (state.status == ListStatus.success) {
          return state.items.isNotEmpty
              ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: state.items.map((item) {
                final id = item.mgroupstatusclaimId;
                final isSelected = (id == state.selectedStatusId);

                return Row(
                  children: [
                    StatusChip(
                      statusId: id,
                      height: 30,
                      label: item.groupNama,
                      isSelected: isSelected,
                      onTap: () {
                        context.read<MstatusrinciCariBloc>()
                            .add(SelectedIdChanged(id));
                      },
                    ), SizedBox(width: 8)
                  ],
                );
              }).toList(),
            ),
          )
              : const SizedBox.shrink();
        }
        return const SizedBox.shrink();
      },
    );
  }
}