import 'package:joss_app/pages/simulmv/simulmvcrud_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/widgets/floatingmenumaster_widget.dart';
import 'package:joss_app/blocs/simulmv/simulmvlist_bloc.dart';
import 'package:joss_app/blocs/simulmv/simulmvcrud_bloc.dart';
import 'package:joss_app/pages/simulmv/simulmvlist_list_widget.dart';

class SimulmvListPage extends StatefulWidget {
  const SimulmvListPage({super.key});

  @override
  SimulmvListPageState createState() => SimulmvListPageState();
}

class SimulmvListPageState extends State<SimulmvListPage> {
  late SimulmvListBloc simulmvListBloc;
  late SimulmvCrudBloc simulmvCrudBloc;
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
    simulmvListBloc = BlocProvider.of<SimulmvListBloc>(context);
    simulmvCrudBloc = BlocProvider.of<SimulmvCrudBloc>(context);

    return MultiBlocListener(
        listeners: [
          BlocListener<SimulmvListBloc, SimulmvListState>(
              listener: (context, state) {
            if (state.viewMode == "tambah") {
              showDialogViewData(state.viewMode, "");
            } else if (state.viewMode == "ubah") {
              showDialogViewData(state.viewMode, state.recordId);
            }
          }, listenWhen: (previous, current) {
            return previous.viewMode != current.viewMode;
          }),
          BlocListener<SimulmvCrudBloc, SimulmvCrudState>(
              listener: (context, state) {
            if (state.isSaved) {
              refreshData();
            }
          }, listenWhen: (previous, current) {
            return previous.isSaved != current.isSaved;
          }),
        ],
        child: Scaffold(
          floatingActionButton:
              FloatingMenuMasterWidget(onTambah: onTambahData),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // ListPageFilterBarUIWidget(
                //     searchController: _searchController,
                //     searchButton: buildSearchButton()),
                buildList()
              ],
            ),
          ),
        ));
  }

  void refreshData() {
    simulmvListBloc.add(
        RefreshSimulmvListEvent(searchText: _searchController.text, hal: 0));
  }

  void onTambahData() {
    simulmvListBloc.add(TambahSimulmvListEvent());
  }

  IconButton buildSearchButton() {
    return IconButton(
        icon: const Icon(
          Icons.autorenew_rounded,
          size: 35.0,
        ),
        onPressed: () {
          simulmvListBloc.add(RefreshSimulmvListEvent(
              searchText: _searchController.text, hal: 0));
        });
  }

  Widget buildList() {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SimulmvListListWidget(searchText: _searchController.text)
      ],
    ));
  }

  void showDialogViewData(String viewMode, String recordId) {
    FocusScope.of(context).requestFocus(FocusNode());

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SimulmvCrudMainPage(); //ubah
    }));
    /*
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return SimulmvCrudFormPage(viewMode: viewMode, recordId: recordId);
			},
			useSafeArea: true)
		.then((value) {
			simulmvListBloc.add(CloseDialogSimulmvListEvent());
		});
    */
  }
}
