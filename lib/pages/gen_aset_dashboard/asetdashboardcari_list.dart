import 'package:joss_app/models/combobox/combocoblist_model.dart';
import 'package:joss_app/widgets/combobox/combocoblist_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gen_aset_dashboard/asetdashboardcari_bloc.dart';
import 'package:joss_app/pages/gen_aset_dashboard/asetdashboardcari_list_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AsetDashboardCariPage extends StatefulWidget {
  const AsetDashboardCariPage({super.key});

  @override
  AsetDashboardCariPageState createState() => AsetDashboardCariPageState();
}

class AsetDashboardCariPageState extends State<AsetDashboardCariPage> {
  late AsetDashboardCariBloc asetDashboardCariBloc;
  final comboCOBKey = GlobalKey<DropdownSearchState<ComboCobListModel>>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    asetDashboardCariBloc = BlocProvider.of<AsetDashboardCariBloc>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildFieldComboCobList(
            comboKey: comboCOBKey,
            labelText: 'COB',
            onChangedCallback: (value) {
              refreshData();
            },
            onSaveCallback: (value) {},
            validatorCallback: (value) {},
          ),
          buildList()
        ],
      ),
    );
  }

  void refreshData() {
    var selectedCob = comboCOBKey.currentState?.getSelectedItem;
    asetDashboardCariBloc.add(
        RefreshAsetDashboardCariEvent(cobAppId: selectedCob?.mCobApp1Id ?? ""));
  }

  Widget buildList() {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[AsetDashboardCariListWidget()],
    ));
  }
}
