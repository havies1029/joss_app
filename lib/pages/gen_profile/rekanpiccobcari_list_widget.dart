import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_profile/rekanpiccobcari_bloc.dart';
import 'package:joss_app/pages/gen_profile/rekanpiccobcari_tile_widget.dart';
import 'package:joss_app/models/gen_profile/rekanpiccobcari_model.dart';

class RekanPicCobCariListWidget extends StatefulWidget {
  final String searchText;
  const RekanPicCobCariListWidget({super.key, required this.searchText});

  @override
  RekanPicCobCariListWidgetState createState() => RekanPicCobCariListWidgetState();
}

class RekanPicCobCariListWidgetState extends State<RekanPicCobCariListWidget> {
  late RekanPicCobCariBloc rekanPicCobCariBloc;
  List<RekanPicCobCariModel> rekanPicCobCari = [];
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
    rekanPicCobCariBloc = BlocProvider.of<RekanPicCobCariBloc>(context);
    return BlocConsumer<RekanPicCobCariBloc, RekanPicCobCariState>(
        builder: (context, state) {
          if (state.status == ListStatus.success) {
            if (!state.hasReachedMax) {
              rekanPicCobCari.addAll(state.items);
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
                        RekanPicCobCariTileWidget(
                          mrekanpiccobId: state.items[index].mrekanpiccobId,
                          cobNama: state.items[index].cobNama,
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
      rekanPicCobCariBloc.add(FetchRekanPicCobCariEvent());
    }
  }

}