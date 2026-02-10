import 'package:joss_app/blocs/klaimringkas/mstatusringkascari_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/klaimringkas/klaimringkascari_bloc.dart';
import 'package:joss_app/pages/klaimringkas/klaimringkascari_list_widget.dart';

class KlaimringkasCariPage extends StatefulWidget {
	const KlaimringkasCariPage({super.key});

	@override
	KlaimringkasCariPageState createState() => KlaimringkasCariPageState();
}

class KlaimringkasCariPageState extends State<KlaimringkasCariPage> {
	late KlaimringkasCariBloc klaimringkasCariBloc;
  late MstatusringkasCariBloc mstatusringkasCariBloc;
  String selectedStatusId = '';
	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			refreshData();
		});
	}

	@override
	Widget build(BuildContext context) {
		klaimringkasCariBloc = BlocProvider.of<KlaimringkasCariBloc>(context);
    mstatusringkasCariBloc = BlocProvider.of<MstatusringkasCariBloc>(context);
    selectedStatusId = mstatusringkasCariBloc.state.selectedStatusId;
		return KlaimringkasCariListWidget();
	}
	void refreshData() {
		klaimringkasCariBloc.add(
			RefreshKlaimringkasCariEvent(selectedStatusId: selectedStatusId));
	}
}
