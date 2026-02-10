import 'package:joss_app/pages/regklaim/polissourcecari_list.dart';
import 'package:flutter/material.dart';

class PolissourcecariMainPage extends StatelessWidget {
  final String cobKlaimId;  
  final String cobKlaimNama;
	const PolissourcecariMainPage({super.key, required this.cobKlaimId, required this.cobKlaimNama});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi Klaim'),
      ),
			backgroundColor: Colors.grey[100],
			body: PolissourcecariPage(cobKlaimId: cobKlaimId, cobKlaimNama: cobKlaimNama)
		);
	}
}
