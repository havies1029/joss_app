import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/notifevent/notifeventcari_bloc.dart';
import 'package:joss_app/pages/notifevent/notifeventcari_list_widget.dart';

class NotifeventcariPage extends StatefulWidget {
  const NotifeventcariPage({super.key});

  @override
  NotifeventcariPageState createState() => NotifeventcariPageState();
}

class NotifeventcariPageState extends State<NotifeventcariPage> {
  late NotifeventcariBloc notifeventcariBloc;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    notifeventcariBloc = BlocProvider.of<NotifeventcariBloc>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Notifikasi",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const SafeArea(
        child: NotifeventcariListWidget(),
      ),
    );
  }

  void refreshData() {
    notifeventcariBloc.add(RefreshNotifeventcariEvent());
  }
}
