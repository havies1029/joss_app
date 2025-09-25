import 'package:joss_app/blocs/simulmv/simulmvcrud_bloc.dart';
import 'package:joss_app/pages/simulmv/simulmvcrud_formv2.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/widgets/mobiledesign_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimulmvCrudMainPage extends StatefulWidget {
  const SimulmvCrudMainPage({super.key});

  @override
  SimulmvCrudMainPageState createState() => SimulmvCrudMainPageState();
}

class SimulmvCrudMainPageState extends State<SimulmvCrudMainPage> {
  late SimulmvCrudBloc simulmvCrudBloc;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    simulmvCrudBloc = BlocProvider.of<SimulmvCrudBloc>(context);
    return MobileDesignWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Calculator MV'),
        ),
        body: SimulmvCrudFormV2Page(viewMode: "tambah", recordId: ""),
      ),
    );
  }

  void loadData() {
    debugPrint("######### SimulmvCrudMainPage -> loadData ############");
    simulmvCrudBloc.add(SimulMVCrudInitValueEvent());
  }
}

/*import 'package:joss_app/pages/simulmv/simulmvcrud_formv2.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/widgets/mobiledesign_widget.dart';

class SimulmvCrudMainPage extends StatelessWidget {
	final String viewMode;
	final String recordId;
	const SimulmvCrudMainPage({super.key, required this.viewMode, required this.recordId});

	@override
	Widget build(BuildContext context) {
		return MobileDesignWidget(
			child: Scaffold(
				appBar: AppBar(
					title: Text('${viewMode == "tambah"?"Tambah":"Ubah"} Premi MV'),
				),
				body: SimulmvCrudFormV2Page(viewMode: viewMode, recordId: recordId)));
	}
}
  */