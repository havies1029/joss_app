import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/klaimlacak/klaimprogresscari_bloc.dart';
import 'package:joss_app/common/constants.dart';

import 'klaimprogresscari_list_widget.dart';
// import 'package:joss_app/pages/klaimlacak/klaimprogresscari_list_widget.dart';

class KlaimprogresscariPage extends StatefulWidget {
	final String klaim1Id;
	const KlaimprogresscariPage({super.key, required this.klaim1Id});

	@override
	KlaimprogresscariPageState createState() => KlaimprogresscariPageState();
}

class KlaimprogresscariPageState extends State<KlaimprogresscariPage> {
	late KlaimprogresscariBloc klaimprogresscariBloc;
	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			refreshData();
		});
	}

	@override
	Widget build(BuildContext context) {
		klaimprogresscariBloc = BlocProvider.of<KlaimprogresscariBloc>(context);
		return Container(
			color: secondaryBlackColor,
			child: Column(
				children: [
					Expanded(
							child: KlaimprogresscariListWidget(
								klaim1Id: widget.klaim1Id,
							)),
				],
			),
		);
	}

	void refreshData() {
		klaimprogresscariBloc
				.add(RefreshKlaimprogresscariEvent(klaim1Id: widget.klaim1Id));
	}
}