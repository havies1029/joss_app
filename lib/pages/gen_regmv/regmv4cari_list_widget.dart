import 'package:joss_app/blocs/gen_regmv/regmv4form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_regmv/regmv4cari_bloc.dart';
import 'package:joss_app/pages/gen_regmv/regmv4cari_tile_widget.dart';

class Regmv4CariListWidget extends StatefulWidget {
	final String regmv1Id;
	const Regmv4CariListWidget({super.key, required this.regmv1Id});

	@override
	Regmv4CariListWidgetState createState() => Regmv4CariListWidgetState();
}

class Regmv4CariListWidgetState extends State<Regmv4CariListWidget> {
	late Regmv4CariBloc regmv4CariBloc;
	final ScrollController _scrollController = ScrollController();

	@override
	void initState() {
		super.initState();
		_scrollController.addListener(_onScroll);
    Future.delayed(const Duration(milliseconds: 500), () {
			refreshData();
		});
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
		regmv4CariBloc = BlocProvider.of<Regmv4CariBloc>(context);
		return BlocListener<Regmv4FormBloc, Regmv4FormState>(
        listener: (context, state) {
          if (state.isSaved) {
            refreshData();
          }
        },
        child: BlocConsumer<Regmv4CariBloc, Regmv4CariState>(
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
                    Regmv4CariTileWidget(
                      caption: state.items[index].caption,
                      regmv4Id: state.items[index].regmv4Id,
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
          ),
        );
	}
	void _onScroll() {
		if (!_scrollController.hasClients) return;
		if (_scrollController.position.pixels ==
				_scrollController.position.maxScrollExtent) {
			regmv4CariBloc.add(FetchRegmv4CariEvent());
		}
	}

	void refreshData() {
		regmv4CariBloc.add(
			RefreshRegmv4CariEvent(regmv1Id: widget.regmv1Id));
	}

}
