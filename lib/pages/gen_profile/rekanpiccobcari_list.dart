import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/gen_profile/rekanpiccobcari_bloc.dart';
import 'package:joss_app/pages/gen_profile/rekanpiccobcari_list_widget.dart';

class RekanPicCobCariPage extends StatefulWidget {
  final String rekanPicId;
  const RekanPicCobCariPage({super.key, required this.rekanPicId});

  @override
  RekanPicCobCariPageState createState() => RekanPicCobCariPageState();
}

class RekanPicCobCariPageState extends State<RekanPicCobCariPage> {
  late RekanPicCobCariBloc rekanPicCobCariBloc;
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    rekanPicCobCariBloc = BlocProvider.of<RekanPicCobCariBloc>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListPageFilterBarUIWidget(
              searchController: _searchController,
              searchButton: buildSearchButton()),
          buildList()
        ],
      ),
    );
  }

  void refreshData() {
    rekanPicCobCariBloc.add(RefreshRekanPicCobCariEvent(rekanPicId: widget.rekanPicId, searchText: _searchController.text));
  }

  IconButton buildSearchButton() {
    return IconButton(
        icon: const Icon(
          Icons.autorenew_rounded,
          size: 35.0,
        ),
        onPressed: () {
          rekanPicCobCariBloc.add(RefreshRekanPicCobCariEvent(rekanPicId: widget.rekanPicId, searchText: _searchController.text));
        });
  }

  Widget buildList() {
    return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            RekanPicCobCariListWidget(searchText: _searchController.text)
          ],
        ));
  }
}