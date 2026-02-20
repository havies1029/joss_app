import 'package:joss_app/blocs/klaimrinci/groupcobcari_bloc.dart';
import 'package:joss_app/blocs/klaimrinci/mstatusrincicari_bloc.dart';
import 'package:joss_app/pages/klaimlacak/klaimprogresscari_main.dart';
import 'package:joss_app/pages/klaimrinci/groupcobcari_list.dart';
import 'package:joss_app/pages/klaimrinci/mstatusrincicari_list.dart';
import 'package:joss_app/pages/perbaruiklaimmv/perbaruiklaimmv_page.dart';
import 'package:joss_app/pages/perbaruiklaimpar/perbaruiklaimpar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class KlaimRinciCariMainPage extends StatefulWidget {
  const  KlaimRinciCariMainPage({super.key});

  @override
  KlaimRinciCariMainPageState createState() => KlaimRinciCariMainPageState();
}

class KlaimRinciCariMainPageState extends State<KlaimRinciCariMainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Klaim Rincian"),
      ),
      backgroundColor: Colors.grey[100],

      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        backgroundColor: Colors.blue,
        children: [
          SpeedDialChild(
            child: Icon(Icons.edit),
            label: 'Perbarui Klaim',
            onTap: () {
              final selectedKlaimRecord = context.read<GroupcobCariBloc>().state.selectedKlaimRecord;
              if (selectedKlaimRecord != null) {
                final String cobId = selectedKlaimRecord.cobId;
                final String cobNama = selectedKlaimRecord.cobNama;

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    if (cobId == "10002") {
                      return PerbaruiKlaimMvPage( klaim1Id: selectedKlaimRecord.klaim1Id, cobGroupNama: cobNama); // Sesuaikan parameter sesuai kebutuhan
                    }
                    else if (cobId == "10001") {
                      return PerbaruiKlaimParPage(klaim1Id: selectedKlaimRecord.klaim1Id, cobGroupNama: cobNama, cobGroupId: cobId); // Sesuaikan parameter sesuai kebutuhan
                    }
                    else {
                      return PerbaruiKlaimParPage(klaim1Id: selectedKlaimRecord.klaim1Id, cobGroupNama: cobNama, cobGroupId: cobId); // Sesuaikan parameter sesuai kebutuhan
                    }
                  }),
                );

              }
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.search),
            label: 'Lacak Klaim',
            onTap: () {
              final selectedKlaimRecord = context.read<GroupcobCariBloc>().state.selectedKlaimRecord;
              if (selectedKlaimRecord != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return KlaimProgressCariMainPage(klaim1Id: selectedKlaimRecord.klaim1Id);
                  }),
                );
              }
            },
          ),
        ],
      ),


      body: MultiBlocListener(
        listeners: [
          BlocListener<MstatusrinciCariBloc, MstatusrinciCariState>(
              listener: (context, state) {
                // Ketika selectedStatusId berubah, refresh data KlaimringkasCariBloc
                context.read<GroupcobCariBloc>().add(
                  RefreshGroupcobCariEvent(
                    statusId: state.selectedStatusId, searchText: state.searchText,
                  ),
                );
              }, listenWhen: (previous, current) {
            return ((previous.selectedStatusId != current.selectedStatusId) ||
                (previous.searchText != current.searchText));
          }),

        ],
        child: Column(

          children: [
            SizedBox(
              height: 152, // tinggi bar tombol (silakan adjust)
              child: MstatusrinciCariPage(), // ini yg ListView horizontal
            ),

            const SizedBox(height: 8),
            Expanded(child: const GroupcobCariPage())
          ],
        ),
      ),
    );
  }
}
