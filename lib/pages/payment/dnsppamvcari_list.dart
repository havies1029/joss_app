import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/payment/dnsppamvcari_bloc.dart';
import 'package:joss_app/pages/payment/dnsppamvcari_list_widget.dart';

class DnsppamvCariPage extends StatefulWidget {
  final String sppa1Id;
	const DnsppamvCariPage({super.key, required this.sppa1Id});

	@override
	DnsppamvCariPageState createState() => DnsppamvCariPageState();
}

class DnsppamvCariPageState extends State<DnsppamvCariPage> {
	late DnsppamvCariBloc dnsppamvCariBloc;
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
		dnsppamvCariBloc = BlocProvider.of<DnsppamvCariBloc>(context);
		return Scaffold(
          appBar: AppBar(
            title: const Text("Detail Outstanding Polis"),
          ),
          body: Column(
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
		dnsppamvCariBloc.add(
			RefreshDnsppamvCariEvent(sppa1Id: widget.sppa1Id, searchText: _searchController.text));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			dnsppamvCariBloc.add(RefreshDnsppamvCariEvent(
        sppa1Id: widget.sppa1Id,
				searchText: _searchController.text));
			});
	}

	Widget buildList() {
		return Expanded(
			child: DnsppamvCariListWidget(searchText: _searchController.text));
	}

}
