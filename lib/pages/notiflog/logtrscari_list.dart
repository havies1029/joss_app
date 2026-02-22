import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/notiflog/logtrscari_bloc.dart';
import 'package:joss_app/pages/notiflog/logtrscari_list_widget.dart';

enum LogFilter { semua, aktivitas, transaksi }

class LogtrscariPage extends StatefulWidget {
  const LogtrscariPage({super.key});

  @override
  LogtrscariPageState createState() => LogtrscariPageState();
}

class LogtrscariPageState extends State<LogtrscariPage> {
  late LogtrscariBloc logtrscariBloc;
  LogFilter _filter = LogFilter.semua;

  String get _groupLogId {
    switch (_filter) {
      case LogFilter.semua:
        return "";
      case LogFilter.aktivitas:
        return "10";
      case LogFilter.transaksi:
        return "20";
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), refreshData);
  }

  @override
  Widget build(BuildContext context) {
    logtrscariBloc = BlocProvider.of<LogtrscariBloc>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Semua Transaksi",
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
        child: Column(
          children: [
            // ===== FILTER DI PAGE =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: _buildFilterRow(),
            ),

            // ===== LIST =====
            Expanded(
              child: LogtrscariListWidget(
                activeGroupLogId: _groupLogId, // supaya paging ikut filter
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      children: [
        _chip("Semua", LogFilter.semua),
        const SizedBox(width: 10),
        _chip("Aktifitas", LogFilter.aktivitas),
        const SizedBox(width: 10),
        _chip("Transaksi", LogFilter.transaksi),
      ],
    );
  }

  Widget _chip(String text, LogFilter value) {
    final selected = _filter == value;
    const orange = Color(0xFFFF7A18);
    final bg = selected ? orange : const Color(0xFF2A2A2A);
    final fg = selected ? Colors.white : Colors.white.withOpacity(0.9);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        if (_filter == value) return;
        setState(() => _filter = value);
        refreshData();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: fg,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  void refreshData() {
    logtrscariBloc.add(
      RefreshLogtrscariEvent(groupLogId: _groupLogId),
    );
  }
}
