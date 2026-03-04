import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gen_promo/promo2cari_bloc.dart';
import 'package:joss_app/pages/gen_promo/promo2cari_list_widget.dart';

class Promo2CariPage extends StatefulWidget {
  final String promo1Id;
	const Promo2CariPage({super.key, required this.promo1Id});

  @override
  Promo2CariPageState createState() => Promo2CariPageState();
}

class Promo2CariPageState extends State<Promo2CariPage> {
	late Promo2CariBloc promo2CariBloc;
	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			refreshData();
		});
	}

	@override
	Widget build(BuildContext context) {
		promo2CariBloc = BlocProvider.of<Promo2CariBloc>(context);
		return Center(
			child: Promo2CariListWidget(),
		);
	}
	void refreshData() {
		promo2CariBloc.add(
			RefreshPromo2CariEvent(promo1Id: widget.promo1Id));
	}
}
