import 'package:joss_app/blocs/klaimringkas/klaimringkascari_bloc.dart';
import 'package:joss_app/blocs/klaimringkas/mstatusringkascari_bloc.dart';
import 'package:joss_app/pages/klaimringkas/klaimringkascari_list.dart';
import 'package:joss_app/pages/klaimringkas/mstatusringkascari_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KlaimringkascariMainPage extends StatefulWidget {
  const KlaimringkascariMainPage({super.key});

  @override
  KlaimringkascariMainPageState createState() => KlaimringkascariMainPageState();
}

class KlaimringkascariMainPageState extends State<KlaimringkascariMainPage> {

	@override
	Widget build(BuildContext context) {
		return MultiBlocListener(
      listeners: [
        BlocListener<MstatusringkasCariBloc, MstatusringkasCariState>(
            listener: (context, state) {
              // Ketika selectedStatusId berubah, refresh data KlaimringkasCariBloc
              context.read<KlaimringkasCariBloc>().add(
                RefreshKlaimringkasCariEvent(
                  selectedStatusId: state.selectedStatusId,
                ),
              );
            }, listenWhen: (previous, current) {
          return previous.selectedStatusId != current.selectedStatusId;
        }),

      ],
      child: Column(

        children: [
          SizedBox(
            height: 52, // tinggi bar tombol (silakan adjust)
            child: MstatusringkasCariPage(), // ini yg ListView horizontal
          ),

          const SizedBox(height: 8),
          Expanded(child: const KlaimringkasCariPage())
        ],
      ),
    );
	}
}
