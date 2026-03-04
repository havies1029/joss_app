import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_aset_par/asetparcari_bloc.dart';
import 'package:joss_app/pages/gen_aset_par/asetparcari_tile_widget.dart';
import 'package:joss_app/models/gen_aset_par/asetparcari_model.dart';

class AsetParCariListWidget extends StatefulWidget {
	final String searchText;
	const AsetParCariListWidget({super.key, required this.searchText});

	@override
	AsetParCariListWidgetState createState() => AsetParCariListWidgetState();
}

class AsetParCariListWidgetState extends State<AsetParCariListWidget> {
	late AsetParCariBloc asetParCariBloc;
	List<AsetParCariModel> asetParCari = [];
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
		asetParCariBloc = BlocProvider.of<AsetParCariBloc>(context);
		return BlocConsumer<AsetParCariBloc, AsetParCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				asetParCari.addAll(state.items);
			}

		return state.items.isNotEmpty
			? Expanded(
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
                  AsetParCariTileWidget(
                    alamat: state.items[index].alamat,
                    asetParId: state.items[index].asetParId,
                    curr: state.items[index].curr,
                    nomor: state.items[index].nomor,
                    polisNo: state.items[index].polisNo,
                    premi: state.items[index].premi,
                    status: state.items[index].status,
                    sumInsured: state.items[index].sumInsured,
                  )
                ],
              ),
            )),
        )
			: const Center(
				child: Padding(
					padding: EdgeInsets.only(top: 80.0),
					child: Text(
						'No Data Properti Available!!',
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
						'No Data Properti Available!!',
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
			asetParCariBloc.add(FetchAsetParCariEvent());
		}
	}

}
