import 'package:joss_app/blocs/gen_cob_app/cobcari_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonGroupCobAsetWidget extends StatefulWidget {
	const ButtonGroupCobAsetWidget({super.key});

	@override
	ButtonGroupCobAsetWidgetState createState() => ButtonGroupCobAsetWidgetState();
}

class ButtonGroupCobAsetWidgetState extends State<ButtonGroupCobAsetWidget> {

  @override
  void initState() {
    super.initState();
    // Initializing the bloc to fetch data
    context.read<CobCariBloc>().add(RefreshCobCariEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CobCariBloc, CobCariState>(
      builder: (context, state) {
        if (state.status == ListStatus.initial) {
          return Center(child: CircularProgressIndicator());
        } else if (state.status == ListStatus.success) {

          if (state.selectedCOBId.isEmpty) {
            // If no COB is selected, select the first one by default
            context.read<CobCariBloc>().add(SelectButton(state.items.first.mCobApp1Id));
          }

          return state.items.isNotEmpty ? Wrap(
            spacing: 10,
            children: state.items.map((cob) {
              final isSelected = state.selectedCOBId == cob.mCobApp1Id;

              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? Colors.blue : Colors.grey,
                ),
                onPressed: () {
                  context.read<CobCariBloc>().add(SelectButton(cob.mCobApp1Id));
                },
                child: Text(cob.cobNama),
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
