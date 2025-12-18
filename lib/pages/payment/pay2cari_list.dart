import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/payment/pay2cari_bloc.dart';
import 'package:joss_app/pages/payment/pay2cari_list_widget.dart';

class Pay2CariPage extends StatefulWidget {
	final String ar1Id;
	const Pay2CariPage({super.key, required this.ar1Id});

	@override
	Pay2CariPageState createState() => Pay2CariPageState();
}

class Pay2CariPageState extends State<Pay2CariPage> {
	late Pay2CariBloc pay2CariBloc;
	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			refreshData();
		});
	}

	@override
	Widget build(BuildContext context) {
		pay2CariBloc = BlocProvider.of<Pay2CariBloc>(context);
		return Column(
			mainAxisSize: MainAxisSize.min,

			children: [
				Padding(
					padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
					child: Row(
					children: [
						Expanded(
						child: Text(
							"Detail Pay2Cari",
							style: Theme.of(context).textTheme.titleLarge,
						),
						),
						IconButton(
						icon: const Icon(Icons.close),
						onPressed: () => Navigator.pop(context),
						),
					],
					),
				),

				const Divider(height: 1),
				Expanded(child: Pay2CariListWidget()),
				
			],
		
		);
	}
	void refreshData() {
		pay2CariBloc.add(
			RefreshPay2CariEvent(ar1Id: widget.ar1Id));
	}
}
