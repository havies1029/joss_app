import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/regendors/regendorscari_bloc.dart';
import 'package:joss_app/pages/regendors/regendorscari_tile_widget.dart';
import 'package:joss_app/models/regendors/regendorscari_model.dart';

class RegendorsCariListWidget extends StatefulWidget {
	final String searchText;
	const RegendorsCariListWidget({super.key, required this.searchText});

	@override
	RegendorsCariListWidgetState createState() => RegendorsCariListWidgetState();
}

class RegendorsCariListWidgetState extends State<RegendorsCariListWidget> {
	late RegendorsCariBloc regendorsCariBloc;
	List<RegendorsCariModel> regendorsCari = [];
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
		regendorsCariBloc = BlocProvider.of<RegendorsCariBloc>(context);
		return BlocConsumer<RegendorsCariBloc, RegendorsCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				regendorsCari.addAll(state.items);
			}

		return state.items.isNotEmpty
			? Flexible(
				child: ListView.builder(
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
								RegendorsCariTileWidget(
									endorsTgl: state.items[index].endorsTgl,
									notePerubahan: state.items[index].notePerubahan,
									regendors1Id: state.items[index].regendors1Id,
									insuranceName: state.items[index].insuranceName,
                  sppa1Id: state.items[index].sppa1Id,
								)
							],
						),
					)),
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
			regendorsCariBloc.add(FetchRegendorsCariEvent());
		}
	}

}
