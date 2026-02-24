import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/klaimringkas/mstatusringkascari_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/apptheme/build_status_box.dart';

class KlaimRingkasanStatusWidget extends StatefulWidget {
  const KlaimRingkasanStatusWidget({super.key});

  @override
  State<KlaimRingkasanStatusWidget> createState() =>
      _KlaimRingkasanStatusWidgetState();
}

class _KlaimRingkasanStatusWidgetState
    extends State<KlaimRingkasanStatusWidget> {
  late MstatusringkasCariBloc _mstatusringkasCariBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mstatusringkasCariBloc = BlocProvider.of<MstatusringkasCariBloc>(context);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      _refreshStatus();
    });
  }

  void _refreshStatus() {
    _mstatusringkasCariBloc.add(RefreshMstatusringkasCariEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MstatusringkasCariBloc, MstatusringkasCariState>(
      buildWhen: (previous, current) {
        return (current.status == ListStatus.success);
      },
      listener: (context, state) {},
      builder: (context, state) {
        if (state.selectedStatusId.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            context.read<MstatusringkasCariBloc>().add(
              SelectedIdChanged(state.items.first.mgroupstatusclaimId),
            );
          });
        }

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
                        context.read<MstatusringkasCariBloc>()
                            .add(SelectedIdChanged(id));
                      },
                    ), SizedBox(width: 8)
                  ],
                );
              }).toList(),
            ),
          )
              : const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 80.0),
              child: Text(
                'No Data Available!!',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}