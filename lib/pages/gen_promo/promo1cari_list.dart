import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gen_promo/promo1cari_bloc.dart';
import 'package:joss_app/pages/gen_promo/promo1cari_list_widget.dart';

class Promo1CariPage extends StatefulWidget {
	const Promo1CariPage({super.key});

	@override
	Promo1CariPageState createState() => Promo1CariPageState();
}

class Promo1CariPageState extends State<Promo1CariPage> {
	late Promo1CariBloc promo1CariBloc;
	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			refreshData();
		});
	}

	@override
	Widget build(BuildContext context) {
		promo1CariBloc = BlocProvider.of<Promo1CariBloc>(context);
		return Center(
			child: Promo1CariListWidget(),
		);
	}
	void refreshData() {
		promo1CariBloc.add(
			RefreshPromo1CariEvent());
	}
}
