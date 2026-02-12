import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/klaimringkas/mstatusringkascari_bloc.dart';
import 'package:joss_app/pages/klaimringkas/mstatusringkascari_list_widget.dart';

class MstatusringkasCariPage extends StatefulWidget {
	const MstatusringkasCariPage({super.key});

	@override
	MstatusringkasCariPageState createState() => MstatusringkasCariPageState();
}

class MstatusringkasCariPageState extends State<MstatusringkasCariPage> {
	late MstatusringkasCariBloc mstatusringkasCariBloc;
	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			refreshData();
		});
	}

	@override
	Widget build(BuildContext context) {
		mstatusringkasCariBloc = BlocProvider.of<MstatusringkasCariBloc>(context);
		return buildList();
	}
	void refreshData() {
		mstatusringkasCariBloc.add(
			RefreshMstatusringkasCariEvent());
	}

	Widget buildList() {
		return MstatusringkasCariListWidget();
	}

}
