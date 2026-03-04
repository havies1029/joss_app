import 'package:joss_app/blocs/simulpar/simulparcrud_bloc.dart';
import 'package:joss_app/pages/simulpar/simulparcurd_formv2.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/widgets/mobiledesign_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimulparCrudMainPage extends StatefulWidget {
	
	const SimulparCrudMainPage({super.key});

	@override
  SimulparCrudMainPageState createState() =>
      SimulparCrudMainPageState();
}

class SimulparCrudMainPageState extends State<SimulparCrudMainPage>{
  late SimulparCrudBloc simulparCrudBloc;

    @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
    });
  }

  @override
	Widget build(BuildContext context) {
    simulparCrudBloc = BlocProvider.of<SimulparCrudBloc>(context);
		return MobileDesignWidget(
			child: Scaffold(
				appBar: AppBar(
					title: Text('Calculator PAR'),
				),
				body: SimulparCrudFormV2Page(viewMode: "tambah", recordId: "")));
	}

  void loadData() {
    debugPrint("######### SimulparCrudMainPage -> loadData ############3");
    
    simulparCrudBloc.add(SimulPARCrudInitValueEvent());
  }
}

