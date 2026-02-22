import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/notiflog/logtrscaritopx_bloc.dart';
import 'package:joss_app/pages/notiflog/logtrscaritopx_list_widget.dart';

class LogtrscaritopxPage extends StatefulWidget {
  const LogtrscaritopxPage({super.key});

  @override
  LogtrscaritopxPageState createState() => LogtrscaritopxPageState();
}

class LogtrscaritopxPageState extends State<LogtrscaritopxPage> {
  late LogtrscaritopxBloc logtrscaritopxBloc;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), refreshData);
  }

  @override
  Widget build(BuildContext context) {
    logtrscaritopxBloc = BlocProvider.of<LogtrscaritopxBloc>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Log Transaksi Top 5",
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
      body: SafeArea(
        child: LogtrscaritopxListWidget(),
      ),
    );
  }

  void refreshData() {
    logtrscaritopxBloc.add(
      RefreshLogtrscaritopxEvent(),
    );
  }
}
