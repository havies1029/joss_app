import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/regklaim/cobklaimcari_bloc.dart';
import 'package:joss_app/pages/regklaim/cobklaimcari_tile_widget.dart';
import 'package:joss_app/pages/regklaim/polissourcecari_main.dart';
import 'package:joss_app/models/regklaim/cobklaimcari_model.dart';

class CobklaimcariListWidget extends StatefulWidget {
	final String searchText;
	const CobklaimcariListWidget({super.key, required this.searchText});

	@override
	CobklaimcariListWidgetState createState() => CobklaimcariListWidgetState();
}

class CobklaimcariListWidgetState extends State<CobklaimcariListWidget> {
	late CobklaimcariBloc cobklaimcariBloc;
	List<CobklaimcariModel> cobklaimcari = [];
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
		cobklaimcariBloc = BlocProvider.of<CobklaimcariBloc>(context);
		return BlocConsumer<CobklaimcariBloc, CobklaimcariState>(
				builder: (context, state) {
					if (state.status == ListStatus.success) {
						if (!state.hasReachedMax) {
							cobklaimcari.addAll(state.items);
						}

						return state.items.isNotEmpty
								? Flexible(
							child: ListView.builder(
									padding: EdgeInsets.zero,
									controller: _scrollController,
									itemCount: state.items.length,
									itemBuilder: (_, index) {
										final item = state.items[index];
										return InkWell(
											borderRadius: BorderRadius.circular(15.0),
											onTap: () {

												context.read<CobklaimcariBloc>().add(CobklaimcariItemSelectedEvent(selectedItem: item));

												Navigator.of(context).push(
													MaterialPageRoute(
														builder: (_) => PolissourcecariMainPage(cobKlaimId: item.mcobklaim1Id, cobKlaimNama: item.cobNama),
													),
												);
											},
											child: Container(
												margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
												padding: const EdgeInsets.all(0.2),
												decoration: BoxDecoration(
														borderRadius: BorderRadius.circular(15.0)),
												child: Column(
													children: <Widget>[
														CobklaimcariTileWidget(
															cobNama: state.items[index].cobNama,
															mcobklaim1Id: state.items[index].mcobklaim1Id,
														)
													],
												),
											),
										);
									}),
						)
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
	void _onScroll() {
		if (!_scrollController.hasClients) return;
		if (_scrollController.position.pixels ==
				_scrollController.position.maxScrollExtent) {
			cobklaimcariBloc.add(FetchCobklaimcariEvent());
		}
	}

}
