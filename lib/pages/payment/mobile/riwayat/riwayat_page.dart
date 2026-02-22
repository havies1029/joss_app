import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/payment/mobile/riwayat/riwayat_table_page.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/payment/pay1list_bloc.dart';


import '../../../../common/constants.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  RiwayatPageState createState() => RiwayatPageState();
}

class RiwayatPageState extends State<RiwayatPage> {
  late Pay1ListBloc pay1ListBloc;
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    pay1ListBloc = context.read<Pay1ListBloc>();
    Future.delayed(const Duration(milliseconds: 500), () {
      refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    pay1ListBloc = BlocProvider.of<Pay1ListBloc>(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: hPadding * 1.5,
          vertical: 10,
        ),
        color: secondaryBlackColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListPageFilterBarUIWidget(
              searchController: _searchController,
              searchButton: buildSearchButton(),
            ),
            const SizedBox(height: 10),
            buildList(),
          ],
        ),
      ),
    );
  }


  void refreshData() {
    pay1ListBloc.add(
        RefreshPay1ListEvent(searchText: _searchController.text, hal: 0));
  }

  IconButton buildSearchButton() {
    return IconButton(
        icon: const Icon(
          Icons.autorenew_rounded,
          size: 35.0,
        ),
        onPressed: () {
          pay1ListBloc.add(RefreshPay1ListEvent(
              searchText: _searchController.text, hal: 0));
        });
  }

  Widget buildList() {
    return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[RiwayatTablePage(searchText: _searchController.text)],
        ));
  }

}
