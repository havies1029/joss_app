import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/payment/dnsppacari_bloc.dart';
import 'package:joss_app/pages/payment/ringkasan/detail/dnsppacari_list_widget.dart';

class DnsppaCariPage extends StatefulWidget {
  final String listcobId;
  final String currId;
	const DnsppaCariPage({super.key, required this.listcobId, required this.currId});

	@override
	DnsppaCariPageState createState() => DnsppaCariPageState();
}

class DnsppaCariPageState extends State<DnsppaCariPage> {
	late DnsppaCariBloc dnsppaCariBloc;
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
		dnsppaCariBloc = BlocProvider.of<DnsppaCariBloc>(context);
		return Scaffold(
          appBar: AppBar(
            title: const Text("List Outstanding Polis"),
          ),
          body: Column(
            children: [
              ListPageFilterBarUIWidget(
                searchController: _searchController,
                searchButton: buildSearchButton(),
              ),
              Expanded(child: DnsppaCariListWidget()),
            ],
          ),
        );
	}
	void refreshData() {
		dnsppaCariBloc.add(
			RefreshDnsppaCariEvent(
        listcobId: widget.listcobId,
        currId: widget.currId,
      ));
	}

  IconButton buildSearchButton() {
    return IconButton(
      icon: const Icon(Icons.autorenew_rounded, size: 35.0),
      onPressed: () {
        dnsppaCariBloc.add(
          RefreshDnsppaCariEvent(
            listcobId: widget.listcobId,
            currId: widget.currId,
            searchText: _searchController.text,
          ));
      },
    );
  }

}
