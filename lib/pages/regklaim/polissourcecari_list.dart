import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/regklaim/polissourcecari_bloc.dart';
import 'package:joss_app/pages/regklaim/polissourcecari_list_widget.dart';

class PolissourcecariPage extends StatefulWidget {
  final String cobKlaimId;  
  final String cobKlaimNama;
	const PolissourcecariPage({super.key, required this.cobKlaimId, required this.cobKlaimNama});

	@override
	PolissourcecariPageState createState() => PolissourcecariPageState();
}

class PolissourcecariPageState extends State<PolissourcecariPage> {
	late PolissourcecariBloc polissourcecariBloc;
	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			refreshData();
		});
	}

	@override
	Widget build(BuildContext context) {
		polissourcecariBloc = BlocProvider.of<PolissourcecariBloc>(context);
		return Center(
			child: buildList(),
		);
	}
	void refreshData() {
		polissourcecariBloc.add(
			RefreshPolissourcecariEvent());
	}

	Widget buildList() {
		return PolissourcecariListWidget(cobKlaimId: widget.cobKlaimId, cobKlaimNama: widget.cobKlaimNama);
	}

}
