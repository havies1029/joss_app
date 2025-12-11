import 'package:joss_app/blocs/gen_regmv/regmv7form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_regmv/regmv7cari_bloc.dart';
import 'package:joss_app/pages/gen_regmv/regmv7cari_tile_widget.dart';

class Regmv7CariListWidget extends StatefulWidget {
	final String regmv1Id;
	const Regmv7CariListWidget({super.key, required this.regmv1Id});

	@override
	Regmv7CariListWidgetState createState() => Regmv7CariListWidgetState();
}

class Regmv7CariListWidgetState extends State<Regmv7CariListWidget> {
	late Regmv7CariBloc regmv7CariBloc;
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
		regmv7CariBloc = BlocProvider.of<Regmv7CariBloc>(context);
		return BlocListener<Regmv7FormBloc, Regmv7FormState>(
          listener: (context, state) {
            if (state.isSaved) {
              refreshData();
            }
          },
          child: BlocConsumer<Regmv7CariBloc, Regmv7CariState>(
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
                    Regmv7CariTileWidget(
                      accNama: state.items[index].accNama,
                      regmv7Id: state.items[index].regmv7Id,
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
			regmv7CariBloc.add(FetchRegmv7CariEvent());
		}
	}

  void refreshData() {
		regmv7CariBloc.add(
			RefreshRegmv7CariEvent(regmv1Id: widget.regmv1Id));
	}

}
