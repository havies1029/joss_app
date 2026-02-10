import 'package:joss_app/pages/regklaim/sppapoliscari_list.dart';
import 'package:flutter/material.dart';

class SppapoliscariMainPage extends StatelessWidget {
  final String cobKlaimId;  
  final String cobKlaimNama;
	const SppapoliscariMainPage({super.key, required this.cobKlaimId, required this.cobKlaimNama});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: Text('SPPA Polis Search - $cobKlaimNama'),
      ),  
			backgroundColor: Colors.grey[100],
			body: SppapoliscariPage(cobKlaimId: cobKlaimId, cobKlaimNama: cobKlaimNama),
		);
	}
}
