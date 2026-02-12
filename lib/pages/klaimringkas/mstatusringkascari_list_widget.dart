import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/klaimringkas/mstatusringkascari_bloc.dart';
import 'package:joss_app/widgets/apptheme/build_status_box.dart';

class MstatusringkasCariListWidget extends StatefulWidget {
	const MstatusringkasCariListWidget({super.key});

	@override
	MstatusringkasCariListWidgetState createState() => MstatusringkasCariListWidgetState();
}

class MstatusringkasCariListWidgetState extends State<MstatusringkasCariListWidget> {
	late MstatusringkasCariBloc mstatusringkasCariBloc;

	@override
	Widget build(BuildContext context) {
		mstatusringkasCariBloc = BlocProvider.of<MstatusringkasCariBloc>(context);
		return BlocConsumer<MstatusringkasCariBloc, MstatusringkasCariState>(
			buildWhen: (previous, current) {
				return (current.status == ListStatus.success);
			},
			listener: (context, state) {},
			builder: (context, state) {
      if (state.status == ListStatus.success) {

        return state.items.isNotEmpty
        ? SizedBox(
            height: 44, // atur sesuai kebutuhan
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: state.items.length,
              itemBuilder: (_, index) {
                final item = state.items[index];

                // SESUAIKAN ini dengan field id item kamu
                final id = item.mgroupstatusclaimId; // misal: item.groupId / item.id / item.statusId

                final isSelected = (id == state.selectedStatusId);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: StatusChip(
                    statusId: id,
                    label: item.groupNama,
                    isSelected: isSelected,
                    onTap: () {
                      context
                                          .read<MstatusringkasCariBloc>()
                                          .add(SelectedIdChanged(id));
                    },
                  ),
                );
              },
            )

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
			}
		);
	}

}
