import 'package:joss_app/blocs/gen_cob_app/cobcari_bloc.dart' as cobcari;
import 'package:joss_app/blocs/gen_status_aset/statusasetcari_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonGroupStatusAsetWidget extends StatefulWidget {
	const ButtonGroupStatusAsetWidget({super.key});

	@override
	ButtonGroupStatusAsetWidgetState createState() => ButtonGroupStatusAsetWidgetState();
}

class ButtonGroupStatusAsetWidgetState extends State<ButtonGroupStatusAsetWidget> {

  @override
  void initState() {
    super.initState();
    // Initializing the bloc to fetch data
    context.read<StatusAsetCariBloc>().add(RefreshStatusAsetCariEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatusAsetCariBloc, StatusAsetCariState>(
      builder: (context, state) {
        if (state.status == ListStatus.initial) {
          return Center(child: CircularProgressIndicator());
        } else if (state.status == ListStatus.success) {

          if (state.selectedStatusId.isEmpty) {
            // If no status is selected, select the first one by default
            context.read<StatusAsetCariBloc>().add(SelectButton(state.items.first.mstatusasetId));
          } 

          return state.items.isNotEmpty ? Wrap(
            spacing: 10,
            children: state.items.map((status) {
              final isSelected = state.selectedStatusId == status.mstatusasetId;

              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? Colors.blue : Colors.grey,
                ),
                onPressed: () {
                  context.read<StatusAsetCariBloc>().add(SelectButton(status.mstatusasetId));
                },
                child: Text(status.statusNama),
              );
            }).toList(),
          ) : Center(child: Text("No items found"));
        } else if (state.status == ListStatus.failure) {
          return Text("Error: Loading failed",
              style: TextStyle(color: Colors.red));
        }

        return SizedBox.shrink();
      },
    );
  }
}
