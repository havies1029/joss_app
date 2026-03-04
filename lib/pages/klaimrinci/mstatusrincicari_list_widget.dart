import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/klaimrinci/mstatusrincicari_bloc.dart';

class MstatusrinciCariListWidget extends StatefulWidget {
	final String searchText;
	const MstatusrinciCariListWidget({super.key, required this.searchText});

	@override
	MstatusrinciCariListWidgetState createState() => MstatusrinciCariListWidgetState();
}

class MstatusrinciCariListWidgetState extends State<MstatusrinciCariListWidget> {
	late MstatusrinciCariBloc mstatusrinciCariBloc;


	@override
	Widget build(BuildContext context) {
		mstatusrinciCariBloc = BlocProvider.of<MstatusrinciCariBloc>(context);
		return BlocConsumer<MstatusrinciCariBloc, MstatusrinciCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {

		return state.items.isNotEmpty
			? SizedBox(
          height: 44,
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
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      side: BorderSide(color: isSelected ? Colors.blue : Colors.black12),
                      backgroundColor: isSelected ? Colors.blue.withOpacity(0.12) : null,
                    ),
                    onPressed: () {
                      context
                          .read<MstatusrinciCariBloc>()
                          .add(SelectedIdChanged(id));
                    },
                    child: Text(
                      item.groupNama,
                      style: TextStyle(
                        color: isSelected ? Colors.blue : null,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
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
							fontWeight: FontWeight.bold),
					),
				),
			);
		} else {
			return const Center(
					child: Text(
						'No Data Available!!',
						style: TextStyle(
							color: Colors.red,
							fontSize: 12.0,
							fontWeight: FontWeight.bold),
					),
				);
			}
			}, buildWhen: (previous, current) {
				return (current.status == ListStatus.success);
			}, listener: (context, state) {}
		);
	}

}
