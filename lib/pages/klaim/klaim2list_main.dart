import 'package:joss_app/pages/klaim/klaim2list_timeline.dart';
import 'package:flutter/material.dart';

class Klaim2ListMainPage extends StatelessWidget {
  final String klaim1Id;
  const Klaim2ListMainPage({super.key, required this.klaim1Id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Klaim Id : $klaim1Id"),
      ),
      backgroundColor: Colors.grey[100],
      //body: Klaim2ListPage(klaim1Id: klaim1Id),
      body: Klaim2ListTimeline(klaim1Id: klaim1Id),
    );
  }
}
