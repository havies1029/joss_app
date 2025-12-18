import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/widgets/floatingmenumaster_widget.dart';
import 'package:joss_app/blocs/payment/pay1list_bloc.dart';
import 'package:joss_app/blocs/payment/pay1crud_bloc.dart';
import 'package:joss_app/pages/payment/paymentcrud_page/pay1crud_form.dart';
import 'package:joss_app/pages/payment/paymentcrud_page/pay1list_list_widget.dart';

class Pay1ListPage extends StatefulWidget {
	const Pay1ListPage({super.key});

	@override
	Pay1ListPageState createState() => Pay1ListPageState();
}

class Pay1ListPageState extends State<Pay1ListPage> {
	late Pay1ListBloc pay1ListBloc;
	late Pay1CrudBloc pay1CrudBloc;
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
		pay1ListBloc = BlocProvider.of<Pay1ListBloc>(context);
		pay1CrudBloc = BlocProvider.of<Pay1CrudBloc>(context);

		return MultiBlocListener(
			listeners: [
				BlocListener<Pay1ListBloc, Pay1ListState>(
					listener: (context, state) {
						if (state.viewMode == "tambah") {
							showDialogViewData(context, state.viewMode, "");
						} else if (state.viewMode == "ubah") {
							showDialogViewData(context, state.viewMode, state.recordId);
						}
				}, listenWhen: (previous, current) {
					return previous.viewMode != current.viewMode;
				}),
				BlocListener<Pay1CrudBloc, Pay1CrudState>(
					listener: (context, state) {
						if (state.isSaved) {
							refreshData();
						}
				}, listenWhen: (previous, current) {
					return previous.isSaved != current.isSaved;
				}),
			],
			child: Scaffold(
				floatingActionButton: FloatingMenuMasterWidget(
					onTambah: onTambahData),
				body: Center(
					child: Column(
						mainAxisAlignment: MainAxisAlignment.start,
						children: [
							ListPageFilterBarUIWidget(
								searchController: _searchController,
								searchButton: buildSearchButton()),
							buildList()
						],

					),
				),
			));
	}

	void refreshData() {
		pay1ListBloc.add(
			RefreshPay1ListEvent(searchText: _searchController.text, hal: 0));
	}

	void onTambahData() {
		pay1ListBloc.add(TambahPay1ListEvent());
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
				children: <Widget>[Pay1ListListWidget(searchText: _searchController.text)],
		));
	}

	void showDialogViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return Pay1CrudFormPage(viewMode: viewMode, recordId: recordId);
			},
			useSafeArea: true)
		.then((value) {
			pay1ListBloc.add(CloseDialogPay1ListEvent());
		});
	}

}
