import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaim5cari_bloc.dart';
import 'package:joss_app/pages/perbaruiklaimmv/klaim5cari_list_widget.dart';

class Klaim5cariPage extends StatefulWidget {
  final String klaim1Id;
  const Klaim5cariPage({super.key, required this.klaim1Id});

  @override
  Klaim5cariPageState createState() => Klaim5cariPageState();
}

class Klaim5cariPageState extends State<Klaim5cariPage> {
  late Klaim5cariBloc klaim5cariBloc;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    klaim5cariBloc = BlocProvider.of<Klaim5cariBloc>(context);
    return buildList();
  }

  void refreshData() {
    klaim5cariBloc.add(RefreshKlaim5cariEvent(klaim1Id: widget.klaim1Id));
  }

  Widget buildList() {
    return Klaim5cariListWidget(klaim1Id: widget.klaim1Id);
  }
}
