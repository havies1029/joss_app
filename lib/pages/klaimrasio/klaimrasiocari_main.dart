import 'package:joss_app/pages/klaimrasio/klaimrasiocobcari_list.dart';
import 'package:flutter/material.dart';

class KlaimRasioCariMainPage extends StatefulWidget {
  const  KlaimRasioCariMainPage({super.key});

  @override
  KlaimRasioCariMainPageState createState() => KlaimRasioCariMainPageState();
}

class KlaimRasioCariMainPageState extends State<KlaimRasioCariMainPage> {

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Text("Klaim Rasio"),
      ),
			backgroundColor: Colors.grey[100],
			body: KlaimrasiocobCariPage(),
		);
	}
}
