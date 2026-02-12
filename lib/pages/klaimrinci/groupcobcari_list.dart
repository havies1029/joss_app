import 'package:joss_app/blocs/klaimrinci/mstatusrincicari_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/klaimrinci/groupcobcari_bloc.dart';
import 'package:joss_app/pages/klaimrinci/groupcobcari_list_widget.dart';

class GroupcobCariPage extends StatefulWidget {
	const GroupcobCariPage({super.key});

	@override
	GroupcobCariPageState createState() => GroupcobCariPageState();
}

class GroupcobCariPageState extends State<GroupcobCariPage> {
	late GroupcobCariBloc groupcobCariBloc;
  late MstatusrinciCariBloc mstatusrinciCariBloc;
  String selectedStatusId = '';
	final TextEditingController _searchController = TextEditingController();
	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			refreshData();
		});
	}

	@override
	Widget build(BuildContext context) {
		groupcobCariBloc = BlocProvider.of<GroupcobCariBloc>(context);
    mstatusrinciCariBloc = BlocProvider.of<MstatusrinciCariBloc>(context);
    selectedStatusId = mstatusrinciCariBloc.state.selectedStatusId;
		return GroupcobCariListWidget();
	}
	void refreshData() {
		groupcobCariBloc.add(
			RefreshGroupcobCariEvent(
        statusId: selectedStatusId,
        searchText: _searchController.text,
      ),);
	}

}
