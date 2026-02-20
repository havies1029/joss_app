import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvstatuscari_bloc.dart';
import 'package:joss_app/pages/perbaruiklaimmv/klaimmvstatuscari_tile_widget.dart';
import 'package:joss_app/models/perbaruiklaimmv/klaimmvstatuscari_model.dart';

class KlaimmvstatuscariListWidget extends StatefulWidget {
	final String searchText;
	const KlaimmvstatuscariListWidget({super.key, required this.searchText});

	@override
	KlaimmvstatuscariListWidgetState createState() => KlaimmvstatuscariListWidgetState();
}

class KlaimmvstatuscariListWidgetState extends State<KlaimmvstatuscariListWidget> {
	late KlaimmvstatuscariBloc klaimmvstatuscariBloc;
	List<KlaimmvstatuscariModel> klaimmvstatuscari = [];
	final ScrollController _scrollController = ScrollController();

	@override
	void initState() {
		super.initState();
		_scrollController.addListener(_onScroll);
	}

	@override
	void dispose() {
		_scrollController
			..removeListener(_onScroll)
			..dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		klaimmvstatuscariBloc = BlocProvider.of<KlaimmvstatuscariBloc>(context);
		return BlocConsumer<KlaimmvstatuscariBloc, KlaimmvstatuscariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				klaimmvstatuscari.addAll(state.items);
			}

			return state.items.isNotEmpty
					? Column(
				children: state.items.map((item) {
					return RadioListTile<bool>(
						value: true,
						groupValue: item.isPilih,
						onChanged: null, // ⛔ tidak aktif, cuma tampilan
						title: Text(
							item.statusNama ?? '',
							style: const TextStyle(
								color: Colors.white,
								fontSize: 14,
							),
						),
						activeColor: Colors.white,
						controlAffinity: ListTileControlAffinity.leading,
						dense: true,
						visualDensity:
						const VisualDensity(horizontal: -2, vertical: -2),
					);
				}).toList(),
			)
					: const Center(
				child: Padding(
					padding: EdgeInsets.only(top: 40),
					child: Text(
						'No Data Available',
						style: TextStyle(
							color: Colors.red,
							fontSize: 12,
							fontWeight: FontWeight.bold,
						),
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
	void _onScroll() {
		if (!_scrollController.hasClients) return;
		if (_scrollController.position.pixels ==
				_scrollController.position.maxScrollExtent) {
			klaimmvstatuscariBloc.add(FetchKlaimmvstatuscariEvent());
		}
	}

}
