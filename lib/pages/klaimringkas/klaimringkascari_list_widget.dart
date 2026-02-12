import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/klaimringkas/klaimringkascari_bloc.dart';
import 'package:joss_app/pages/klaimringkas/klaimringkascari_tile_widget.dart';

class KlaimringkasCariListWidget extends StatefulWidget {
	const KlaimringkasCariListWidget({super.key});

	@override
	KlaimringkasCariListWidgetState createState() => KlaimringkasCariListWidgetState();
}

class KlaimringkasCariListWidgetState extends State<KlaimringkasCariListWidget> {
	late KlaimringkasCariBloc klaimringkasCariBloc;
	final ScrollController _scrollController = ScrollController();

	@override
	Widget build(BuildContext context) {
		klaimringkasCariBloc = BlocProvider.of<KlaimringkasCariBloc>(context);
		return BlocConsumer<KlaimringkasCariBloc, KlaimringkasCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {

		return state.items.isNotEmpty
			? ListView.builder(
				padding: EdgeInsets.zero,
				controller: _scrollController,
				itemCount: state.items.length,
				itemBuilder: (_, index) => Container(
					margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
					padding: const EdgeInsets.all(0.2),
					decoration: BoxDecoration(
						borderRadius: BorderRadius.circular(15.0)),
					child: Column(
						children: <Widget>[
							KlaimringkasCariTileWidget(
								cobNama: state.items[index].cobNama,
								currNama: state.items[index].currNama,
								klaimAmount: state.items[index].klaimAmount,
								klaimQty: state.items[index].klaimQty,
								nourut: state.items[index].nourut,
							)
						],
					),
				))
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
